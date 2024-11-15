require "test_helper"
class EqualsTest < Minitest::Test

  def test_attr_strings_are_equal_with_same_attrs
    assert AttributedString.new("Hello, World!", bold: true) == AttributedString.new("Hello, World!", bold: true)
  end

  def test_attr_strings_not_equal_with_different_attrs
    refute AttributedString.new("Hello, World!", bold: true) == AttributedString.new("Hello, World!", bold: false)
  end
end
