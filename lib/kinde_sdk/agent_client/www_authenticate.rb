# frozen_string_literal: true

require "strscan"

module KindeSdk
  class AgentClient
    # Parser for +WWW-Authenticate+ header values (RFC 7235): several
    # challenges in one value, quoted strings with escapes, commas inside
    # quotes, and scheme and parameter names in any case.
    #
    # @example
    #   header = 'Basic realm="a, b", Bearer error="invalid_token", resource_metadata="https://rs.example/prm"'
    #   KindeSdk::AgentClient::WwwAuthenticate.bearer(header)
    #   # => { "error" => "invalid_token", "resource_metadata" => "https://rs.example/prm" }
    module WwwAuthenticate
      TOKEN = /[!#$%&'*+\-.^_`|~0-9A-Za-z]+/.freeze
      TOKEN68 = %r{[A-Za-z0-9\-._~+/]+=*(?=[ \t]*(?:,|\z))}.freeze
      PARAM_START = /#{TOKEN.source}[ \t]*=/.freeze
      QUOTED = /"((?:\\.|[^"\\])*)(?:"|\z)/m.freeze
      private_constant :TOKEN, :TOKEN68, :PARAM_START, :QUOTED

      class << self
        # Every challenge in the header, in order.
        #
        # @param value [String, Array<String>, nil] one header value, or all of them
        # @return [Array<Hash>] one Hash per challenge: +:scheme+ (String,
        #   lower-case), +:params+ (Hash{String=>String}, names lower-case) and
        #   +:token68+ (String or nil). Malformed input gives fewer challenges,
        #   never an error.
        # @example
        #   KindeSdk::AgentClient::WwwAuthenticate.parse('Bearer scope="offline"')
        #   # => [{ scheme: "bearer", params: { "scope" => "offline" }, token68: nil }]
        def parse(value)
          Array(value).flat_map { |entry| parse_value(entry) }
        end

        # The parameters of the first +Bearer+ challenge.
        #
        # @param value [String, Array<String>, nil] one header value, or all of them
        # @return [Hash{String=>String}, nil] nil when there is no Bearer challenge
        # @example
        #   KindeSdk::AgentClient::WwwAuthenticate.bearer(response.headers["www-authenticate"])
        #   # => { "resource_metadata" => "https://api.example.com/.well-known/oauth-protected-resource/mcp" }
        def bearer(value)
          challenge = parse(value).find { |entry| entry[:scheme] == "bearer" }
          challenge && challenge[:params]
        end

        private

        def parse_value(value)
          scanner = StringScanner.new(value.to_s.scrub("?"))
          challenges = []
          until scanner.eos?
            scanner.skip(/[\s,]+/)
            break if scanner.eos?

            scheme = scanner.scan(TOKEN)
            if scheme.nil?
              skip_to_comma(scanner)
              next
            end
            challenges << read_challenge(scanner, scheme)
          end
          challenges
        rescue StandardError
          challenges || []
        end

        def read_challenge(scanner, scheme)
          challenge = { scheme: scheme.downcase, params: {}, token68: nil }
          return challenge unless scanner.skip(/[ \t]+/)

          if (token68 = scanner.scan(TOKEN68))
            challenge[:token68] = token68
          elsif scanner.check(PARAM_START)
            read_params(scanner, challenge[:params])
          end
          challenge
        end

        # Reads auth-params until the next item is not one, which means a new
        # challenge starts there.
        def read_params(scanner, params)
          loop do
            name = scanner.scan(TOKEN)
            scanner.skip(/[ \t]*=[ \t]*/)
            value = read_value(scanner)
            params[name.downcase] = value unless params.key?(name.downcase)
            scanner.skip(/[ \t]*/)
            break unless scanner.skip(/(?:,[ \t]*)+/) && scanner.check(PARAM_START)
          end
        end

        def read_value(scanner)
          if scanner.scan(QUOTED)
            scanner[1].gsub(/\\(.)/m, '\1')
          else
            scanner.scan(/[^\s,]*/).to_s
          end
        end

        def skip_to_comma(scanner)
          scanner.skip(/[^,]+/) || scanner.getch
        end
      end
    end
  end
end
