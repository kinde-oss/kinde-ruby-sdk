# frozen_string_literal: true

require "json"

module KindeSdk
  class AgentClient
    # What the stores share: how a key is spelled and when an unfinished
    # sign-in attempt is dropped.
    #
    # @api private
    module Storage
      METHODS = %i[read write delete].freeze
      # Namespaces that hold sign-in attempts (each with a PKCE verifier).
      PENDING_NAMESPACES = %w[pending mcp_pending].freeze
      # Seconds an unfinished sign-in attempt is kept.
      PENDING_MAX_AGE = 600

      class << self
        # @param key [Array<String>]
        # @return [String] the key as one JSON string
        def key(key)
          JSON.generate(Array(key).map(&:to_s))
        end

        # @param namespace [String]
        # @param value [Object]
        # @return [Boolean] whether +value+ is a sign-in attempt older than {PENDING_MAX_AGE}
        def stale_pending?(namespace, value)
          return false unless PENDING_NAMESPACES.include?(namespace)

          created_at = value.is_a?(Hash) ? value["created_at"] : nil
          created_at.is_a?(Integer) && Clock.now - created_at > PENDING_MAX_AGE
        end

        # @param data [Hash{String=>Hash}] namespace => entries
        # @return [String] entry counts per namespace, never a value
        def summary(data)
          data.map { |namespace, entries| "#{namespace}=#{entries.size}" }.join(" ")
        end
      end
    end

    # The default store: everything in the memory of this process. Tokens are
    # lost on restart and are not shared between processes.
    #
    # Any object with the same three methods can be passed as +storage:+.
    # +namespace+ is a String, +key+ an Array of Strings, and values are
    # JSON-compatible (Hashes with String keys, Arrays, Strings, numbers).
    # The client uses +tokens+ +[issuer, resource_url, account]+,
    # +registrations+ +[issuer, redirect_uri]+, +pending+ +[state]+ and
    # +issuers+ +[resource_url, account]+.
    #
    # @example
    #   store = KindeSdk::AgentClient::MemoryStore.new
    #   store.write("tokens", ["https://issuer", "https://api.example.com/mcp", "default"], { "access_token" => "..." })
    #   store.read("tokens", ["https://issuer", "https://api.example.com/mcp", "default"])
    class MemoryStore
      # @return [void]
      # @example
      #   KindeSdk::AgentClient.new(resource_url: url, redirect_uri: callback_url,
      #                             storage: KindeSdk::AgentClient::MemoryStore.new)
      def initialize
        @data = {}
        @mutex = Mutex.new
      end

      # @param namespace [String]
      # @param key [Array<String>]
      # @return [Object, nil] the stored value, or nil
      # @example
      #   store.read("pending", [state])
      def read(namespace, key)
        @mutex.synchronize { @data.dig(namespace.to_s, Storage.key(key)) }
      end

      # Stores a value. Sign-in attempts older than ten minutes are dropped
      # at the same time.
      #
      # @param namespace [String]
      # @param key [Array<String>]
      # @param value [Object] JSON-compatible
      # @return [Object] the value
      # @example
      #   store.write("pending", [state], { "code_verifier" => verifier, "created_at" => Time.now.to_i })
      def write(namespace, key, value)
        @mutex.synchronize do
          @data.each { |name, entries| entries.delete_if { |_key, entry| Storage.stale_pending?(name, entry) } }
          (@data[namespace.to_s] ||= {})[Storage.key(key)] = value
        end
      end

      # Removes a value and returns it, in one atomic step.
      #
      # @param namespace [String]
      # @param key [Array<String>]
      # @return [Object, nil] the removed value, or nil when there was none
      # @example
      #   store.delete("pending", [state])
      def delete(namespace, key)
        @mutex.synchronize { @data[namespace.to_s]&.delete(Storage.key(key)) }
      end

      # @return [String] entry counts only; never a token, verifier or secret
      def inspect
        "#<#{self.class.name} #{@mutex.synchronize { Storage.summary(@data) }}>".sub(/ >\z/, ">")
      end
    end

    # A store over a session-like hash, for example the Rails or Rack session
    # of the signed-in user. Everything is kept under one top-level key, which
    # is assigned again on every change so the session notices it.
    #
    # The session holds a refresh token, possibly a client secret and, for ten
    # minutes, a PKCE verifier: use a server-side or encrypted session, never a
    # plain cookie.
    #
    # @example In a Rails controller
    #   store = KindeSdk::AgentClient::SessionStore.new(session)
    #   agent = KindeSdk::AgentClient.new(resource_url: url, redirect_uri: callback_url, storage: store)
    class SessionStore
      # @param session [#[], #[]=] the session, or any Hash-like object
      # @param key [String] the one session key everything is kept under
      # @raise [ArgumentError] when +session+ cannot be read and assigned
      # @example
      #   KindeSdk::AgentClient::SessionStore.new(session, key: "my_agent")
      def initialize(session, key: "kinde_agent_client")
        unless session.respond_to?(:[]) && session.respond_to?(:[]=)
          raise ArgumentError, "session must respond to [] and []="
        end

        @session = session
        @key = key
        @mutex = Mutex.new
      end

      # @param namespace [String]
      # @param key [Array<String>]
      # @return [Object, nil] the stored value, or nil
      # @example
      #   store.read("pending", [state])
      def read(namespace, key)
        @mutex.synchronize { data.dig(namespace.to_s, Storage.key(key)) }
      end

      # Stores a value. Sign-in attempts older than ten minutes are dropped
      # at the same time.
      #
      # @param namespace [String]
      # @param key [Array<String>]
      # @param value [Object] JSON-compatible
      # @return [Object] the value
      # @example
      #   store.write("issuers", [resource_url, "default"], issuer)
      def write(namespace, key, value)
        @mutex.synchronize do
          updated = data.to_h do |name, entries|
            [name, entries.reject { |_key, entry| Storage.stale_pending?(name, entry) }]
          end
          updated[namespace.to_s] = (updated[namespace.to_s] || {}).merge(Storage.key(key) => value)
          @session[@key] = updated
        end
        value
      end

      # Removes a value and returns it, in one step.
      #
      # @param namespace [String]
      # @param key [Array<String>]
      # @return [Object, nil] the removed value, or nil when there was none
      # @example
      #   store.delete("tokens", [issuer, resource_url, "default"])
      def delete(namespace, key)
        @mutex.synchronize do
          current = data
          entries = current[namespace.to_s]
          name = Storage.key(key)
          next nil unless entries&.key?(name)

          @session[@key] = current.merge(namespace.to_s => entries.reject { |entry_key, _| entry_key == name })
          entries[name]
        end
      end

      # @return [String] entry counts only; never a token, verifier or secret
      def inspect
        "#<#{self.class.name} key=#{@key.inspect} #{@mutex.synchronize { Storage.summary(data) }}>".sub(/ >\z/, ">")
      end

      private

      def data
        stored = @session[@key]
        stored.is_a?(Hash) ? stored.select { |_name, entries| entries.is_a?(Hash) } : {}
      end
    end
  end
end
