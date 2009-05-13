# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{servicegerbil}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Sadauskas"]
  s.date = %q{2009-05-13}
  s.email = %q{psadauskas@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION.yml",
    "lib/servicegerbil.rb",
    "lib/servicegerbil/attribute_helpers.rb",
    "lib/servicegerbil/authentication_helpers.rb",
    "lib/servicegerbil/request_helpers.rb",
    "lib/servicegerbil/response_helpers.rb",
    "lib/servicegerbil/spec_config.rb",
    "lib/servicegerbil/ssj_helpers.rb",
    "lib/web_service_spec_helpers.rb",
    "test/servicegerbil_test.rb",
    "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/paul/servicegerbil}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{A set of rspec helpers for testing json-based web services}
  s.test_files = [
    "test/test_helper.rb",
    "test/servicegerbil_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<merb-core>, ["~> 1.1.0"])
      s.add_runtime_dependency(%q<facets>, ["~> 2.5.0"])
      s.add_runtime_dependency(%q<json>, ["~> 1.1.0"])
      s.add_runtime_dependency(%q<rspec>, ["~> 1.2.4"])
    else
      s.add_dependency(%q<merb-core>, ["~> 1.1.0"])
      s.add_dependency(%q<facets>, ["~> 2.5.0"])
      s.add_dependency(%q<json>, ["~> 1.1.0"])
      s.add_dependency(%q<rspec>, ["~> 1.2.4"])
    end
  else
    s.add_dependency(%q<merb-core>, ["~> 1.1.0"])
    s.add_dependency(%q<facets>, ["~> 2.5.0"])
    s.add_dependency(%q<json>, ["~> 1.1.0"])
    s.add_dependency(%q<rspec>, ["~> 1.2.4"])
  end
end
