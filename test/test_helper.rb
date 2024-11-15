require "bundler/setup"
Bundler.require(:default)

require "minitest/autorun"
require "minitest/pride"

class Minitest::Test

  def setup
    @attr_string = AttributedString.new("Hello, World!")
  end
  # custom assertions or helpers
end
