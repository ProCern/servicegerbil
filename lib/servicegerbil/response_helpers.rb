module ServiceGerbil
  module ResponseHelpers

    require 'merb-core'
    Merb::ControllerExceptions::STATUS_CODES.each do |name, code|
      define_method(:"be_#{name}") do
        ResponseCodeMatcher.new(code, name)
      end
    end

    def be_successful
      ResponseCodeMatcher.new(200..299, :successful)
    end

    def be_record_invalid_error
      ResponseCodeMatcher.new(406, :record_invalid)
    end

    def be_client_error
      ResponseCodeMatcher.new(400..499, :client_error)
    end

    class ResponseCodeMatcher

      def initialize(code, name)
        @code = code
        @reason_phrase = name.to_s.split('_').map{|s| s.capitalize}.join(' ')
      end

      def matches?(response)
        @response_code = response.status
        @body = response.body.to_s

        if @code.is_a?(Range)
          @response_code.in?(@code)
        else
          @response_code.to_s == @code.to_s
        end
      end

      def failure_message
      "Expected response to be #{@code} #{@reason_phrase}, but it was #{@response_code}."
      end

      def negative_failure_message
      "Expected response to not be #{@code} #{@reason_phrase}"
      end

    end

  end
end

