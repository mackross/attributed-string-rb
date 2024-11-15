require_relative "lib/attributed_string/version"

Gem::Specification.new do |spec|
  spec.name          = "attributed-string"
  spec.version       = AttributedString::VERSION
  spec.summary       = "An attributed string implementation for Ruby."
  spec.homepage      = "https://github.com/mackross/attributed-string-rb"
  spec.license       = "Apache-2.0"

  spec.author        = "Andrew Mackross"
  spec.email         = "andrew@mackross.net"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*", "LICENSE"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 3.3"
end
