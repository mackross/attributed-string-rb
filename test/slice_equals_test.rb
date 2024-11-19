require "test_helper"

class SliceEqualsTest < Minitest::Test
  def setup
    @attr_str = AttributedString.new("abcd", z: 1)
    @attr_str.add_attrs(0..0, a: 1)
    @attr_str.add_attrs(1..1, b: 1)
    @attr_str.add_attrs(2..2, c: 1)
    @attr_str.add_attrs(3..3, d: 1)
  end

  def test_replacing_chars
    0.upto(3).each do |i|
      new = @attr_str.dup
      res = new[i] = AttributedString.new("x", x: 1)
      assert_equal(AttributedString.new("x": 1), res)
      new.each_char.with_index do |char, j|
        attrs = new.attrs_at(j)
        if j != i
          assert_equal(attrs.size, 2)
          assert_equal(attrs[char.to_sym], 1)
        else
          assert_equal(attrs.size, 1)
          assert_equal(attrs[:x], 1)
          assert_equal(char, "x")
        end
      end
    end
  end

  def test_replacing_one_char
    attr_str = AttributedString.new("Hello World")
    attr_str.add_attrs(0..10, underline: true)
    attr_str.add_attrs(0..4, bold: true, font_size: 3)
    attr_str.add_attrs(5..5, bold: false)
    attr_str.add_attrs(6..10, italic: true)
    expected = "{ bold: true, font_size: 3, underline: true }Hello{ -font_size, bold: false } { -bold, italic: true }World{ -italic, -underline }"
    assert_equal expected, attr_str.inspect(color: false)

     attr_str[5..5]= AttributedString.new("-", bold: true, font_size: 4)
    expected = "{ bold: true, font_size: 3, underline: true }Hello{ -underline, font_size: 4 }-{ -bold, -font_size, italic: true, underline: true }World{ -italic, -underline }"
    assert_equal expected, attr_str.inspect(color: false)
  end

  def test_replacing_different_size_range
    @attr_str[0..0] = AttributedString.new("xx", x: 1)
    expected = "{ x: 1 }xx{ -x, b: 1, z: 1 }b{ -b, c: 1 }c{ -c, d: 1 }d{ -d, -z }"
    assert_equal expected, @attr_str.inspect
  end

  def test_replacing_the_whole_string
    @attr_str[0..3] = AttributedString.new("xyz")
    assert_equal("xyz", @attr_str.inspect)
    @attr_str[nil..nil] = AttributedString.new("123456")
    assert_equal("123456", @attr_str.inspect)
  end

end
