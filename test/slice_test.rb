require_relative "test_helper"

class SliceTest < Minitest::Test
  def setup
    @a = AttributedString.new("hello there")
    @a.add_attrs(0..4, bold: true)
    @a.add_attrs(6..10, italic: true)
    @a.add_attrs(0..10, underline: true)
  end
  # a = "hello there"

  # a[1]                   #=> "e"
  # a[2, 3]                #=> "llo"
  # a[2..3]                #=> "ll"
  #
  # a[-3, 2]               #=> "er"
  # a[7..-2]               #=> "her"
  # a[-4..-2]              #=> "her"
  # a[-2..-4]              #=> ""
  #
  # a[11, 0]               #=> ""
  # a[11]                  #=> nil
  # a[12, 0]               #=> nil
  # a[12..-1]              #=> nil
  #
  # a[/[aeiou](.)\1/]      #=> "ell"
  # a[/[aeiou](.)\1/, 0]   #=> "ell"
  # a[/[aeiou](.)\1/, 1]   #=> "l"
  # a[/[aeiou](.)\1/, 2]   #=> nil
  #
  # a[/(?<vowel>[aeiou])(?<non_vowel>[^aeiou])/, "non_vowel"] #=> "l"
  # a[/(?<vowel>[aeiou])(?<non_vowel>[^aeiou])/, "vowel"]     #=> "e"
  #
  # a["lo"]                #=> "lo"
  # a["bye"]               #=> nil

  #  a[1] => "e"
  def test_a_one
    expected = AttributedString.new("e", bold: true, underline: true)
    assert_equal expected, @a.slice(1)
  end

  # ...and ..
  def test_full_range
    expected = @a.dup
    assert_equal expected, @a.slice(nil..nil)
    assert_equal expected, @a.slice(nil...nil)
  end

  def test_nil_exclusive_end
    expected = AttributedString.new("re", italic: true, underline: true)
    assert_equal expected,  @a.slice(9..nil)
    assert_equal expected,  @a.slice(9...nil)
  end

  # a[2, 3] => "llo"
  def test_a_two_three
    expected = AttributedString.new("llo", bold: true, underline: true)
    assert_equal expected, @a.slice(2, 3)
  end

  # a[2..3] => "ll"
  def test_a_two_to_three
    expected = AttributedString.new("ll", bold: true, underline: true)
    assert_equal expected, @a.slice(2..3)
  end

  # a[-3, 2] => "er"
  def test_a_negative_three_two
    expected = AttributedString.new("er", italic: true, underline: true)
    assert_equal expected, @a.slice(-3, 2)
  end

  # a[7..-2] => "her"
  def test_a_seven_to_negative_two
    expected = AttributedString.new("her", italic: true, underline: true)
    assert_equal expected, @a.slice(7..-2)
  end

  # a[-4..-2] => "her"
  def test_a_negative_four_to_negative_two
    expected = AttributedString.new("her", italic: true, underline: true)
    assert_equal expected, @a.slice(-4..-2)
  end

  # a[-2..-4] => ""
  def test_a_negative_two_to_negative_four
    expected = AttributedString.new("")
    assert_equal expected, @a.slice(-2..-4)
  end

  # # a[11, 0] => ""
  def test_a_eleven_zero
    expected = AttributedString.new("")
    assert_equal expected, @a.slice(11, 0)
  end

  # # a[11] => nil
  def test_a_eleven
    assert_nil @a.slice(11)
  end

  # a[12, 0] => nil
  def test_a_twelve_zero
    assert_nil @a.slice(12, 0)
  end

  # a[12..-1] => nil
  def test_a_twelve_to_negative_one
    assert_nil @a.slice(12..-1)
  end

  # # Beginless range from start to a finite end
  # # a[..4] => "hello" with bold and underline for "hello"
  def test_beginless_to_finite_end
    expected = AttributedString.new("hello")
    expected.add_attrs(0..4, bold: true, underline: true)
    assert_equal expected, @a.slice(..4)
  end

  # Endless range from a finite start to the end of the string
  # a[6..] => "there" with italic and underline for "there"
  def test_finite_start_to_endless
    expected = AttributedString.new("there")
    expected.add_attrs(0..4, italic: true, underline: true)
    assert_equal expected, @a.slice(6..)
  end

  # Beginless range from start to a negative index (includes full string)
  # a[..-1] => "hello there" with bold and underline for "hello", italic and underline for "there"
  def test_beginless_to_negative_end
    expected = AttributedString.new("hello there")
    expected.add_attrs(0..4, bold: true, underline: true)  # "hello"
    expected.add_attrs(6..10, italic: true)  # "there"
    expected.add_attrs(0..10, underline: true)
    assert_equal expected, @a.slice(..-1)
  end

  # Endless range from a negative start index to the end
  # a[-3..] => "ere" with italic and underline for "ere"
  def test_negative_start_to_endless
    expected = AttributedString.new("ere")
    expected.add_attrs(0..2, italic: true, underline: true)
    assert_equal expected, @a.slice(-3..)
  end

  # Beginless range from start to negative index -2
  # a[..-2] => "hello ther" with bold and underline for "hello", underline and italic for "ther"
  def test_beginless_to_negative_two
    expected = AttributedString.new("hello ther")
    expected.add_attrs(0..4, bold: true, underline: true)  # "hello"
    expected.add_attrs(6..9, italic: true)  # "ther"
    expected.add_attrs(0..9, underline: true)  # "ther"
    assert_equal expected, @a.slice(..-2)
  end

  # Endless range from -1 to the end of the string (single character)
  # a[-1..] => "e" with italic and underline
  def test_negative_one_to_endless
    expected = AttributedString.new("e")
    expected.add_attrs(0..0, italic: true, underline: true)
    assert_equal expected, @a.slice(-1..)
  end

end
