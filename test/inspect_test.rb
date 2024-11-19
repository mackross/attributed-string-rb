require "test_helper"

class InspectTest < Minitest::Test
  def setup
    @attr_str = AttributedString.new("Hello World")
    @attr_str.add_attrs(0..10, underline: true)
    @attr_str.add_attrs(0..4, bold: true, font_size: 3)
    @attr_str.add_attrs(5..5, bold: false)
    @attr_str.add_attrs(6..10, italic: true)
    #
    # Underline
    # '0H1e2l3l4o5 6W7o8r9l10d'
    # bold = true, font_size = 3
    # '0H1e2l3l4o5'
    # bold = false
    # '5 '
    # italic = true
    # '6W7o8r9l10d'
  end

  def test_inspect
    expected = "{ bold: true, font_size: 3, underline: true }Hello{ -font_size, bold: false } { -bold, italic: true }World{ -italic, -underline }"
    assert_equal expected, @attr_str.inspect(color: false)
  end
end
