require_relative "test_helper"

class SliceBangTest < Minitest::Test
  using AttributedString::Refinements
  def test_normal_string
    str = "hi".to_attr_s(bold: true)
    str.add_attrs(0..0, italic: true)
    str.add_attrs(1..1, underline: true)
    r = str.slice!(0, 1)
    assert_equal "h".to_attr_s(bold: true, italic: true), r
    assert_equal "i".to_attr_s(bold: true, underline: true), str
  end

  def test_slice_bang_beginning
    s = AttributedString.new("hello there")
    s.add_attrs(0..4, bold: true)
    s.add_attrs(6..10, italic: true)
    s.add_attrs(0..10, underline: true)

    result = s.slice!(0, 5)  # Remove "hello"

    assert_equal AttributedString.new("hello", bold: true, underline: true), result
    assert_equal " there", s.to_s

    # Remaining attributes on s
    expected = AttributedString.new(" there")
    expected.add_attrs(1..5, italic: true)
    expected.add_attrs(0..5, underline: true)

    assert_equal expected, s
  end

  def test_slice_bang_middle
    s = AttributedString.new("hello there")
    s.add_attrs(0..4, bold: true)
    s.add_attrs(6..10, italic: true)
    s.add_attrs(0..10, underline: true)

    result = s.slice!(5..6)  # Remove " t"

    # Updated expected result with both underline and italic attributes
    expected_result = AttributedString.new(" t")
    expected_result.add_attrs(0..1, underline: true)
    expected_result.add_attrs(1..1, italic: true)

    assert_equal expected_result, result

    assert_equal "hellohere", s.to_s

    # Remaining attributes on s
    expected = AttributedString.new("hellohere")
    expected.add_attrs(0..4, bold: true)
    expected.add_attrs(5..8, italic: true)
    expected.add_attrs(0..8, underline: true)

    assert_equal expected, s
  end

   def test_slice_bang_end
     s = AttributedString.new("hello there")
     s.add_attrs(0..4, bold: true)
     s.add_attrs(6..10, italic: true)
     s.add_attrs(0..10, underline: true)

     result = s.slice!(-5, 5)  # Remove "there"

     assert_equal AttributedString.new("there", italic: true, underline: true), result
     assert_equal "hello ", s.to_s

     # Remaining attributes on s
     expected = AttributedString.new("hello ")
     expected.add_attrs(0..4, bold: true)
     expected.add_attrs(0..5, underline: true)

     assert_equal expected, s
   end

   def test_slice_bang_entire_string
     s = AttributedString.new("hello")
     s.add_attrs(0..4, bold: true)

     result = s.slice!(0..-1)

     assert_equal AttributedString.new("hello", bold: true), result
     assert_equal "", s.to_s
     assert_equal({}, s.attrs_at(0))
   end

   def test_slice_bang_nonexistent_range
     s = AttributedString.new("hello")
     result = s.slice!(10, 2)

     assert_nil result
     assert_equal "hello", s.to_s
   end

   def test_slice_bang_overlapping_attribute
     s = AttributedString.new("hello world")
     s.add_attrs(0..10, font_size: 12)          # Entire string
     s.add_attrs(6..10, bold: true)             # 'world'

     result = s.slice!(3..7)  # Remove "lo wo"

     # Corrected attributes on result
     expected_result = AttributedString.new("lo wo")
     expected_result.add_attrs(0..4, font_size: 12)
     expected_result.add_attrs(3..4, bold: true)

     assert_equal expected_result, result

     assert_equal "helrld", s.to_s

     # Corrected attributes on remaining string
     expected = AttributedString.new("helrld")
     expected.add_attrs(0..5, font_size: 12)
     expected.add_attrs(3..5, bold: true)

     assert_equal expected, s
   end

   def test_slice_bang_no_attributes
     s = AttributedString.new("hello world")

     result = s.slice!(5..5)  # Remove " "

     assert_equal AttributedString.new(" "), result
     assert_equal "helloworld", s.to_s
     assert_equal({}, s.attrs_at(0))
   end
end
