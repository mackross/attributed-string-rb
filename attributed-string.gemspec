require_relative "lib/attributed_string/version"

Gem::Specification.new do |spec|
  spec.name          = "attributed-string"
  spec.version       = AttributedString::VERSION
  spec.summary       = "An attributed string implementation for Ruby."
  spec.homepage      = "https://github.com/instruct-rb/attributed-string"
  spec.license       = "Apache-2.0"

  spec.author        = "Andrew Mackross"
  spec.email         = "andrew@mackross.net"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*", "LICENSE"]
  spec.require_path  = "lib"

  spec.metadata = {}
  spec.metadata["source_code_uri"] = "https://github.com/instruct-rb/attributed-string"
  spec.metadata["homepage_uri"] = "https://github.com/instruct-rb/attributed-string"


  spec.required_ruby_version = ">= 3.2.3"
end
