require File.join(File.dirname(__FILE__), 'web_service_spec_helpers/request_helpers')
require File.join(File.dirname(__FILE__), 'web_service_spec_helpers/response_helpers')
require File.join(File.dirname(__FILE__), 'web_service_spec_helpers/ssj_helpers')
require File.join(File.dirname(__FILE__), 'web_service_spec_helpers/attribute_helpers')
require File.join(File.dirname(__FILE__), 'web_service_spec_helpers/authentication_helpers')

require File.join(File.dirname(__FILE__), 'accounts/account_shared_specs')
require File.join(File.dirname(__FILE__), 'users/user_shared_specs')
require File.join(File.dirname(__FILE__), 'services/service_shared_specs')

module WebServiceSpecHelpers

  module GroupHelpers
    def self.extended(base)
      base.class_inheritable_accessor :request_block
      base.class_inheritable_accessor :subject_block
      base.class_inheritable_accessor :resource_block
    end

    def request(&blk)
      self.request_block = blk
    end

    def subject(&blk)
      self.subject_block = blk
    end

    def resource(&blk)
      self.resource_block = blk
    end

    include AttributeGroupHelpers
  end

  module ExampleHelpers

    def response
      @response ||= instance_eval(&self.class.request_block)
    end

    require 'facets/kernel/instance_exec'
    def subject(pairs = {})
      @subject ||= self.class.subject_block ? instance_exec(pairs, &self.class.subject_block) : nil
    end

    def resource
      @resource ||= instance_eval(&self.class.resource_block)
    end

    def uri(*args)
      "http://example.org" + url(*args)
    end

    def uri(*args)
      "http://example.org" + url(*args)
    end

    include RequestHelpers
    include ResponseHelpers
    include SsjParser
    include SsjHelpers
    include AttributeExampleHelpers
    include AuthenticationHelpers

  end


end
