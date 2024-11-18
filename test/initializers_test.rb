require 'test_helper'

class InitializersTest < Minitest::Test
  using AttributedString::Refinements

  def test_can_create_new_with_no_args
    attr_string = AttributedString.new
    assert attr_string.to_s == ""
  end

  def test_can_create_new_with_string
    attr_string = AttributedString.new("Hello, World!")
    assert attr_string.to_s == "Hello, World!"
  end

  def test_dup
    @attr_string.add_attrs(0..4, bold: true)
    dup = @attr_string.dup
    0.upto(4) do |i|
      assert_equal({ bold: true }, dup.attrs_at(i))
    end
    5.upto(12) do |i|
      assert_equal({}, dup.attrs_at(i))
    end
  end

end
