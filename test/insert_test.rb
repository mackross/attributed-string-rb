require 'test_helper'

class TestAttributedStringInsert < Minitest::Test
  def setup
    @attr_str = AttributedString.new("foo", bold: true)
  end

  def test_insert_positive_index
    other_str = AttributedString.new("bar", italic: true)

    # Perform the insert operation
    result = @attr_str.insert(1, other_str)

    # Check the modified string value
    assert_equal "fbaroo", result

    # Check attributes at each index
    assert_equal({ bold: true }, result.attrs_at(0))      # 'f'
    assert_equal({ italic: true }, result.attrs_at(1))    # 'b'
    assert_equal({ italic: true }, result.attrs_at(2))    # 'a'
    assert_equal({ italic: true }, result.attrs_at(3))    # 'r'
    assert_equal({ bold: true }, result.attrs_at(4))      # 'o'
    assert_equal({ bold: true }, result.attrs_at(5))      # 'o'
  end

  def test_insert_negative_index
    other_str = AttributedString.new("bar", italic: true)

    # Perform the insert operation
    result = @attr_str.insert(-2, other_str)

    # Check the modified string value
    assert_equal "fobaro", result

    # Check attributes at each index
    assert_equal({ bold: true }, result.attrs_at(0))      # 'f'
    assert_equal({ bold: true }, result.attrs_at(1))      # 'o'
    assert_equal({ italic: true }, result.attrs_at(2))    # 'b'
    assert_equal({ italic: true }, result.attrs_at(3))    # 'a'
    assert_equal({ italic: true }, result.attrs_at(4))    # 'r'
    assert_equal({ bold: true }, result.attrs_at(5))      # 'o'
  end

  def test_insert_empty_other_string
    other_str = AttributedString.new("", underline: true)

    # Perform the insert operation
    result = @attr_str.insert(1, other_str)

    # Check the string value remains unchanged
    assert_equal "foo", result

    # Check that attributes are unchanged
    assert_equal({ bold: true }, result.attrs_at(0))    # 'f'
    assert_equal({ bold: true }, result.attrs_at(1))    # 'o'
    assert_equal({ bold: true }, result.attrs_at(2))    # 'o'
  end

  def test_insert_at_beginning
    other_str = AttributedString.new("bar", italic: true)

    # Perform the insert operation
    result = @attr_str.insert(0, other_str)

    # Check the modified string value
    assert_equal "barfoo", result

    # Check attributes at each index
    assert_equal({ italic: true }, result.attrs_at(0))    # 'b'
    assert_equal({ italic: true }, result.attrs_at(1))    # 'a'
    assert_equal({ italic: true }, result.attrs_at(2))    # 'r'
    assert_equal({ bold: true }, result.attrs_at(3))      # 'f'
    assert_equal({ bold: true }, result.attrs_at(4))      # 'o'
    assert_equal({ bold: true }, result.attrs_at(5))      # 'o'
  end

  def test_insert_at_end
    other_str = AttributedString.new("bar", italic: true)

    # Perform the insert operation
    result = @attr_str.insert(3, other_str)

    # Check the modified string value
    assert_equal "foobar", result

    # Check attributes at each index
    assert_equal({ bold: true }, result.attrs_at(0))      # 'f'
    assert_equal({ bold: true }, result.attrs_at(1))      # 'o'
    assert_equal({ bold: true }, result.attrs_at(2))      # 'o'
    assert_equal({ italic: true }, result.attrs_at(3))    # 'b'
    assert_equal({ italic: true }, result.attrs_at(4))    # 'a'
    assert_equal({ italic: true }, result.attrs_at(5))    # 'r'
  end

end
