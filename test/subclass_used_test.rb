require "test_helper"

class SubclassUsedTest < Minitest::Test
  class X < AttributedString
  end
  class Y < AttributedString
  end
  def test_subclass_used_with_plus
    result = X.new + AttributedString.new
    assert result.is_a?(X)
  end

  def test_keeps_attributes_in_new_class
    string = X.new("a", a: 1)
    string2 = Y.new(string, b: 2)
    assert_equal "a", string2.to_s
    assert_equal({ a: 1, b: 2 }, string2.attrs_at(0))
  end
end
