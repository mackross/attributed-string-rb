require 'test_helper'

class AddingArrAttrsTest < Minitest::Test
  def test_arr_add_attributes_simple
    @attr_string.add_attrs(0..4, { user: 0 })
    0.upto(4) do |i|
      assert_equal({ user: 0 }, @attr_string.attrs_at(i))
    end
    @attr_string.add_arr_attrs(0..4, { user: 1 })
    0.upto(4) do |i|
      assert_equal({ user: [0, 1] }, @attr_string.attrs_at(i))
    end
    @attr_string.add_arr_attrs(0..4, { user: [2] })
    0.upto(4) do |i|
      assert_equal({ user: [0, 1, 2] }, @attr_string.attrs_at(i))
    end
    5.upto(12) do |i|
      assert_equal({}, @attr_string.attrs_at(i))
    end
  end
end
