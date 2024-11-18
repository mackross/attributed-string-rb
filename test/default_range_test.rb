require 'test_helper'

class DefaultRangeTest < Minitest::Test
  def test_default_range_is_correct
    str = AttributedString.new("a")
    str.add_attrs(bold: true)
    assert_equal({ bold: true }, str.attrs_at(0))
    assert_equal({}, str.attrs_at(1))
  end

  def test_setting_default_range_on_empty_string
    str = AttributedString.new("", bold: true)
    assert_equal({}, str.attrs_at(0))
  end

  def test_setting_default_range_on_empty_string_after_init
    str = AttributedString.new("")
    str.add_attrs(bold: true)
    assert_equal({}, str.attrs_at(0))
  end
end
