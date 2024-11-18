require "test_helper"

class FilterResultTest < Minitest::Test
  def setup
    super
    @attr_string.add_attrs(0..4, bold: true)
    @attr_string.add_attrs(7..11, italic: true)
    @filtered_string = @attr_string.filter do |attrs|
      attrs[:bold] == true || attrs[:italic] == true
    end
  end

  def test_filtered_string_is_frozen
    assert_raises(FrozenError) do
      @filtered_string.concat("!")
    end
  end

  def test_original_ranges_for_contiguous_range
    # The filtered string is "HelloWorld"
    # Let's get the original ranges for filtered range 0..4 ("Hello")
    ranges = @filtered_string.original_ranges_for(0..4)
    assert_equal([0..4], ranges)
  end

  def test_original_ranges_for_non_contiguous_range
    # Get the original ranges for filtered range 3..7 ("loWor")
    ranges = @filtered_string.original_ranges_for(3..7)
    # Expected original positions: [3, 4, 7, 8, 9]
    # Should be grouped into ranges: [3..4, 7..9]
    assert_equal([3..4, 7..9], ranges)
  end

  def test_original_ranges_for_single_character
    # Get the original range for a single character at index 5 ("W")
    ranges = @filtered_string.original_ranges_for(5..5)
    assert_equal([7..7], ranges)
  end

  def test_original_ranges_for_full_filtered_string
    ranges = @filtered_string.original_ranges_for(0..@filtered_string.length - 1)
    # Expected ranges: [0..4, 7..11]
    assert_equal([0..4, 7..11], ranges)
  end

  def test_original_ranges_for_invalid_range_type
    assert_raises(ArgumentError) { @filtered_string.original_ranges_for("not a range") }
  end

  def test_original_ranges_for_out_of_bounds_range
    assert_raises(ArgumentError) { @filtered_string.original_ranges_for(0..@filtered_string.length) }
  end

  def test_original_ranges_for_empty_range
    # Empty range should return an empty array
    ranges = @filtered_string.original_ranges_for(2...2)
    assert_equal([], ranges)
  end

  def test_original_ranges_for_disjoint_original_positions
    # Add non-contiguous attributes
    @attr_string.add_attrs(0..0, underline: true)
    @attr_string.add_attrs(5..5, underline: true)
    filtered = @attr_string.filter { |attrs| attrs[:underline] == true }
    # The filtered string should be "H,"
    ranges = filtered.original_ranges_for(0..1)
    # Original positions are [0,5], so ranges should be [0..0,5..5]
    assert_equal([0..0, 5..5], ranges)
  end

  def test_original_ranges_for_reverse_range
    # Reverse ranges are not valid
    assert_raises(ArgumentError) { @filtered_string.original_ranges_for(5..2) }
  end
end
