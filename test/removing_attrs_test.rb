require "test_helper"

class RemovingAttrsTest < Minitest::Test
  def test_simple_remove_attribute
    @attr_string.add_attrs(0..4, bold: true)
    @attr_string.remove_attrs(0..4, :bold)
    0.upto(12) do |i|
      assert_equal({}, @attr_string.attrs_at(i))
    end
  end

  def test_remove_attribute_leaves_others
    @attr_string.add_attrs(0..4, bold: true, font_size: 12)
    @attr_string.remove_attrs(0..4, :bold)
    0.upto(4) do |i|
      assert_equal({ font_size: 12 }, @attr_string.attrs_at(i))
    end
    5.upto(12) do |i|
      assert_equal({}, @attr_string.attrs_at(i))
    end
  end

  def test_remove_attribute_splits_range
    @attr_string.add_attrs(0..4, bold: true, font_size: 12)
    @attr_string.remove_attrs(2..3, :bold)
    0.upto(1) do |i|
      assert_equal({ bold: true, font_size: 12 }, @attr_string.attrs_at(i))
    end
    2.upto(3) do |i|
      assert_equal({ font_size: 12 }, @attr_string.attrs_at(i))
    end
    4.upto(4) do |i|
      assert_equal({ bold: true, font_size: 12 }, @attr_string.attrs_at(i))
    end
    5.upto(12) do |i|
      assert_equal({}, @attr_string.attrs_at(i))
    end
  end

  def test_add_attrs_overlap_different
    @attr_string.add_attrs(0..4, bold: true)
    @attr_string.add_attrs(3..7, italic: true)
    0.upto(2) do |i|
      assert_equal({ bold: true }, @attr_string.attrs_at(i))
    end
    3.upto(4) do |i|
      assert_equal({ bold: true, italic: true }, @attr_string.attrs_at(i))
    end
    5.upto(7) do |i|
      assert_equal({ italic: true }, @attr_string.attrs_at(i))
    end
    8.upto(12) do |i|
      assert_equal({}, @attr_string.attrs_at(i))
    end
  end
end
