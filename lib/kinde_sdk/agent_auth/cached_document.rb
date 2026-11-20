# frozen_string_literal: true

module KindeSdk
  class AgentAuth
    # A JSON document fetched from Kinde and kept in memory for a fixed time.
    # Used for the JWKS and for the proxied authorization server metadata.
    #
    # The document is frozen at every level ({Http.get_json} parses it that
    # way) and every caller gets the same object, so nobody who reads it can
    # change what the next caller is given.
    #
    # The fetch runs while the lock is held, so concurrent callers wait for one
    # request instead of each making their own. A failed fetch (which includes
    # a document that +prepare+ refuses) is remembered for
    # {FAILURE_RETRY_INTERVAL} seconds, so the callers that waited for it (and
    # the ones that follow) fail at once instead of each repeating the timeout.
    #
    # @api private
    class CachedDocument
      MONOTONIC_CLOCK = -> { Process.clock_gettime(Process::CLOCK_MONOTONIC) }

      # Seconds after a failed fetch during which no new fetch is tried.
      FAILURE_RETRY_INTERVAL = 5

      # @param url [String]
      # @param ttl [Numeric] seconds a fetched document stays fresh
      # @param min_refresh_interval [Numeric] minimum seconds between two forced refreshes
      # @param clock [#call] returns the current time in seconds (monotonic)
      # @param prepare [#call, nil] called with each fetched document; the cache
      #   keeps the document it returns. When it raises {UnavailableError} the
      #   fetch counts as failed and nothing is kept
      def initialize(url, ttl:, min_refresh_interval: 0, clock: MONOTONIC_CLOCK, prepare: nil)
        @url = url
        @ttl = ttl
        @min_refresh_interval = min_refresh_interval
        @clock = clock
        @prepare = prepare
        @mutex = Mutex.new
        @document = nil
        @fetched_at = nil
        @forced_at = nil
        @failed_at = nil
        @failure_message = nil
      end

      # @param force [Boolean] ask for a refresh even when the document is
      #   fresh; honoured at most once per +min_refresh_interval+, counted
      #   from the last forced refresh that succeeded
      # @return [Hash] the document, frozen at every level
      # @raise [UnavailableError] when the document has to be fetched and the
      #   fetch fails, or failed less than {FAILURE_RETRY_INTERVAL} seconds ago
      def get(force: false)
        @mutex.synchronize do
          now = @clock.call
          if stale?(now)
            fetch(now)
          elsif force && force_allowed?(now)
            fetch(now)
            @forced_at = now
          end
          @document
        end
      end

      private

      def stale?(now)
        @document.nil? || now - @fetched_at >= @ttl
      end

      def force_allowed?(now)
        @forced_at.nil? || now - @forced_at >= @min_refresh_interval
      end

      def failed_recently?(now)
        !@failed_at.nil? && now - @failed_at < FAILURE_RETRY_INTERVAL
      end

      def fetch(now)
        raise UnavailableError, @failure_message if failed_recently?(now)

        @document = load_document
        @fetched_at = now
      end

      def load_document
        document = Http.get_json(@url)
        @prepare ? @prepare.call(document) : document
      rescue UnavailableError => e
        # Timed when the fetch ends: a fetch that ran into the timeout must
        # still stop the callers that waited for it.
        @failed_at = @clock.call
        @failure_message = e.message
        raise
      end
    end
  end
end
