
require 'rspec'

__DIR__ = File.dirname(__FILE__)

require __DIR__ + '/servicegerbil/request_helpers'
require __DIR__ + '/servicegerbil/response_helpers'
require __DIR__ + '/servicegerbil/ssj_helpers'
require __DIR__ + '/servicegerbil/attribute_helpers'
require __DIR__ + '/servicegerbil/authentication_helpers'

module ServiceGerbil

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

    include ServiceGerbil::AttributeGroupHelpers
  end

  module ExampleHelpers

    def response
      @response ||= instance_eval(&self.class.request_block)
    end

    require 'facets/kernel/instance_exec'
    def subject(pairs = {})
      @subject ||= if self.class.subject_block 
                     instance_exec(pairs, &self.class.subject_block) 
                   else 
                     nil
                   end
    end

    def resource
      @resource ||= instance_eval(&self.class.resource_block)
    end

    def uri(*args)
      "http://example.org" + url(*args)
    end

    include ServiceGerbil::RequestHelpers
    include ServiceGerbil::ResponseHelpers
    include ServiceGerbil::SsjParser
    include ServiceGerbil::SsjHelpers
    include ServiceGerbil::AttributeExampleHelpers
    include ServiceGerbil::AuthenticationHelpers

  end

end

Spec::Runner.configure do |config|

  config.extend(ServiceGerbil::GroupHelpers, :type => :service)
  config.include(ServiceGerbil::ExampleHelpers, :type => :service)

end
