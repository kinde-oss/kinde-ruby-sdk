# frozen_string_literal: true

require "uri"

module KindeSdk
  class AgentClient
    # URL rules shared by the agent client: which URLs may be contacted and how
    # a URL is shown in an error message.
    #
    # @api private
    module Url
      # The only hosts plain +http+ is allowed for.
      LOOPBACK_HOSTS = ["localhost", "127.0.0.1", "[::1]"].freeze

      class << self
        # @param url [Object]
        # @return [URI::Generic, nil] the parsed absolute URL, or nil when it is
        #   not a String holding an absolute URL with a host
        def parse(url)
          return nil unless url.is_a?(String) && !url.empty?

          uri = URI.parse(url)
          uri.scheme && uri.host && !uri.host.empty? ? uri : nil
        rescue URI::InvalidURIError
          nil
        end

        # +https+, or +http+ on +localhost+, +127.0.0.1+ or +[::1]+. Nothing else.
        #
        # @param url [Object]
        # @param loopback [Boolean] false refuses +http+ on a loopback host
        #   too. Used for URLs a server supplied when the resource itself is
        #   not on a loopback host: a remote server must not be able to point
        #   the client at a service on the client's own machine.
        # @return [Boolean]
        def secure?(url, loopback: true)
          uri = parse(url)
          return false if uri.nil?

          case uri.scheme.downcase
          when "https" then true
          when "http" then loopback && loopback?(uri)
          else false
          end
        end

        # @param uri [URI::Generic]
        # @return [Boolean] whether the host is +localhost+, +127.0.0.1+ or +[::1]+
        def loopback?(uri)
          LOOPBACK_HOSTS.include?(uri.host.to_s.downcase)
        end

        # @param url [Object]
        # @return [String] the URL without query, fragment and userinfo, for
        #   error messages and log lines
        def display(url)
          uri = parse(url)
          return "(invalid URL)" if uri.nil?

          "#{origin(uri)}#{uri.path}"
        end

        # @param uri [URI::Generic]
        # @return [String] +scheme://host[:port]+, lower-case, default port left out
        def origin(uri)
          port = uri.port == uri.default_port ? "" : ":#{uri.port}"
          "#{uri.scheme.downcase}://#{uri.host.downcase}#{port}"
        end

        # @param one [URI::Generic]
        # @param other [URI::Generic]
        # @return [Boolean] same scheme, host (case-insensitive) and port
        def same_origin?(one, other)
          origin(one) == origin(other)
        end

        # Whether +path+ is +base+ or sits under it on a +/+ boundary, after
        # one trailing slash is removed from each.
        #
        # @param base [String]
        # @param path [String]
        # @return [Boolean]
        def path_covers?(base, path)
          base = base.to_s.delete_suffix("/")
          path = path.to_s.delete_suffix("/")
          path == base || path.start_with?("#{base}/")
        end
      end
    end
  end
end
