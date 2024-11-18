require "test_helper"

class SubclassUsedTest < Minitest::Test
  class X < AttributedString
  end
  def test_subclass_used_with_plus
    result = X.new + AttributedString.new
    assert result.is_a?(X)
  end
end
