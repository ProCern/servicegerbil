Spec::Runner.configure do |config|

  config.extend(ServiceGerbil::GroupHelpers, :type => :service)
  config.include(ServiceGerbil::ExampleHelpers, :type => :service)

end

