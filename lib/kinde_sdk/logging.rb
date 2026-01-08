# frozen_string_literal: true

module KindeSdk
  # Shared logging module for consistent logging across all SDK components.
  # Supports Rails logger, custom logger, or falls back to stdout/stderr.
  #
  # Can be used as:
  # - Instance methods via `include KindeSdk::Logging`
  # - Class methods via `extend KindeSdk::Logging`
  # - Direct calls via `KindeSdk::Logging.log_error("message")`
  #
  # @example Using in a class (instance methods)
  #   class MyClass
  #     include KindeSdk::Logging
  #
  #     def my_method
  #       log_info("Starting operation")
  #       log_error("Something went wrong")
  #     end
  #   end
  #
  # @example Using for class methods
  #   class MyClass
  #     class << self
  #       extend KindeSdk::Logging
  #
  #       def my_class_method
  #         log_error("Class-level error")
  #       end
  #     end
  #   end
  module Logging
    # Log an error message
    #
    # @param message [String] The message to log
    def log_error(message)
      Logging.write_log(:error, message)
    end

    # Log a warning message
    #
    # @param message [String] The message to log
    def log_warning(message)
      Logging.write_log(:warn, message)
    end

    # Log an info message
    #
    # @param message [String] The message to log
    def log_info(message)
      Logging.write_log(:info, message)
    end

    # Log a debug message
    #
    # @param message [String] The message to log
    def log_debug(message)
      Logging.write_log(:debug, message)
    end

    class << self
      # Write a log message at the specified level
      # Tries multiple logger sources in order of preference:
      # 1. Rails.logger (if Rails is defined)
      # 2. Fallback to $stderr/$stdout based on level
      #
      # @param level [Symbol] The log level (:error, :warn, :info, :debug)
      # @param message [String] The message to log
      def write_log(level, message)
        formatted_message = "[KindeSdk] #{message}"

        logger_instance = resolve_logger
        if logger_instance&.respond_to?(level)
          logger_instance.public_send(level, formatted_message)
        else
          # Fallback based on level
          case level
          when :error, :warn
            $stderr.puts formatted_message
          when :info, :debug
            $stdout.puts formatted_message if ENV['KINDE_DEBUG']
          end
        end
      end

      # Resolve the appropriate logger instance
      #
      # @return [Logger, nil] The logger to use, or nil if none available
      def resolve_logger
        if defined?(Rails) && Rails.respond_to?(:logger) && Rails.logger
          Rails.logger
        end
      end
    end
  end
end


