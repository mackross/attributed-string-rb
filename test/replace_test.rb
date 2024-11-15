require_relative "test_helper"

class ReplaceTest < Minitest::Test
  def test_replace_string
    @attr_string.replace(AttributedString.new("abc", italics: true))
    assert_equal "abc", @attr_string.to_s
    0.upto(2) do |i|
      assert_equal({ italics: true }, @attr_string.attrs_at(i))
    end
  end
end
