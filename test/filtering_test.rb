require "test_helper"

class FilteringTest < Minitest::Test
  def test_filter_with_specific_attribute
    # Add bold attribute to "Hello"
    @attr_string.add_attrs(0..4, bold: true)
    # Filter to include only characters with bold: true
    result = @attr_string.filter { |attrs| attrs[:bold] == true }

    assert_instance_of AttributedString::FilterResult, result
    # Check that the string content is "Hello"
    assert_equal("Hello", result)
    # Check that original positions are correct
    expected_positions = [0, 1, 2, 3, 4]
    expected_positions.each_with_index do |original_pos, idx|
      assert_equal(original_pos, result.original_position_at(idx))
    end
  end

  def test_filter_with_multiple_attrs
    # Add attrs to different parts
    @attr_string.add_attrs(0..4, bold: true)
    @attr_string.add_attrs(7..11, italic: true)
    # Filter to include characters that are either bold or italic
    result = @attr_string.filter do |attrs|
      attrs[:bold] == true || attrs[:italic] == true
    end

    assert_equal("HelloWorld", result)
    expected_positions = [0, 1, 2, 3, 4, 7, 8, 9, 10, 11]
    expected_positions.each_with_index do |original_pos, idx|
      assert_equal(original_pos, result.original_position_at(idx))
    end
  end

  def test_filter_always_true_block
    # No attrs added
    result = @attr_string.filter { |attrs| true }
    assert_equal(@attr_string.to_s, result)
    # Check positions
    (0...result.length).each do |idx|
      assert_equal(idx, result.original_position_at(idx))
    end
  end

  def test_filter_always_false_block
    # No attrs added
    result = @attr_string.filter { |attrs| false }
    assert_equal("", result)
    assert_raises(IndexError) { result.original_position_at(0) }
  end

  def test_filter_with_overlapping_attrs
    # Add bold to "Hello"
    @attr_string.add_attrs(0..4, bold: true)
    # Add italic to "lo, W"
    @attr_string.add_attrs(3..7, italic: true)
    # Filter to include characters with both bold and italic
    result = @attr_string.filter do |attrs|
      attrs[:bold] == true && attrs[:italic] == true
    end

    assert_equal("lo", result)
    expected_positions = [3, 4]
    expected_positions.each_with_index do |original_pos, idx|
      assert_equal(original_pos, result.original_position_at(idx))
    end
  end

  def test_filter_no_attrs
    # No attrs added
    result = @attr_string.filter { |attrs| attrs[:bold] == true }
    assert_equal("", result)
  end

  def test_filter_partial_match
    # Add bold attribute to "Hello"
    @attr_string.add_attrs(0..4, bold: true, color: 'red')
    # Filter to include characters with color: 'red'
    result = @attr_string.filter { |attrs| attrs[:color] == 'red' }
    assert_equal("Hello", result)
    expected_positions = [0, 1, 2, 3, 4]
    expected_positions.each_with_index do |original_pos, idx|
      assert_equal(original_pos, result.original_position_at(idx))
    end
  end

  def test_filter_with_non_boolean_attrs
    # Add color attribute to "World"
    @attr_string.add_attrs(7..11, color: 'blue')
    # Filter to include characters with color 'blue'
    result = @attr_string.filter { |attrs| attrs[:color] == 'blue' }
    assert_equal("World", result)
    expected_positions = [7, 8, 9, 10, 11]
    expected_positions.each_with_index do |original_pos, idx|
      assert_equal(original_pos, result.original_position_at(idx))
    end
  end

  def test_filter_combined_attrs
    # Add attrs to "Hello"
    @attr_string.add_attrs(0..4, bold: true, color: 'red')
    # Add attrs to "World"
    @attr_string.add_attrs(7..11, bold: true, color: 'blue')
    # Filter to include bold characters
    result = @attr_string.filter { |attrs| attrs[:bold] == true }
    assert_equal("HelloWorld", result)
    expected_positions = [0, 1, 2, 3, 4, 7, 8, 9, 10, 11]
    expected_positions.each_with_index do |original_pos, idx|
      assert_equal(original_pos, result.original_position_at(idx))
    end
  end

  def test_filter_no_matching_attrs
    # Add bold to "Hello"
    @attr_string.add_attrs(0..4, bold: true)
    # Filter to include characters with italic attribute
    result = @attr_string.filter { |attrs| attrs[:italic] == true }
    assert_equal("", result)
  end

  def test_original_position_out_of_bounds
    # Add bold to "Hello"
    @attr_string.add_attrs(0..4, bold: true)
    # Filter to include bold characters
    result = @attr_string.filter { |attrs| attrs[:bold] == true }
    # Attempt to access an out-of-bounds position
    assert_raises(IndexError) { result.original_position_at(5) }
  end

end
