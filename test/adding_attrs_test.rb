require 'test_helper'

class AddingAttrsTest < Minitest::Test

  def test_add_out_of_range
    @attr_string.add_attrs(0..14, bold: true)
    # should work silently but fix the range
    @attr_string.concat("!")
    assert_equal({}, @attr_string.attrs_at(13))
    @attr_string.attrs_at(13)
  end

  def test_negative_index
    flunk
  end

  def test_add_attrs_simple
    @attr_string.add_attrs(0..4, bold: true)
    0.upto(4) do |i|
      assert_equal({ bold: true }, @attr_string.attrs_at(i))
    end
    5.upto(12) do |i|
      assert_equal({}, @attr_string.attrs_at(i))
    end
  end

  def test_add_attrs_excluded_end_range
    @attr_string.add_attrs(0...5, bold: true)
    0.upto(4) do |i|
      assert_equal({ bold: true }, @attr_string.attrs_at(i))
    end
    5.upto(12) do |i|
      assert_equal({}, @attr_string.attrs_at(i))
    end
  end

  def test_add_attrs_overlap_overwrite
    @attr_string.add_attrs(0..4, font_size: 9)
    @attr_string.add_attrs(2..8, font_size: 12)
    0.upto(1) do |i|
      assert_equal({ font_size: 9 }, @attr_string.attrs_at(i))
    end
    2.upto(8) do |i|
      assert_equal({ font_size: 12 }, @attr_string.attrs_at(i))
    end
    9.upto(12) do |i|
      assert_equal({}, @attr_string.attrs_at(i))
    end
  end


end
