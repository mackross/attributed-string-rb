require "test_helper"
class EqualtyTest < Minitest::Test

  def test_attr_strings_are_equal_with_same_attrs
    assert AttributedString.new("Hello, World!", bold: true) == AttributedString.new("Hello, World!", bold: true)
  end

  def test_attr_strings_not_equal_with_different_attrs
    refute AttributedString.new("Hello, World!", bold: true) == AttributedString.new("Hello, World!", bold: false)
  end

  def test_attr_strings_not_equal_with_different_attrs
    refute AttributedString.new("Hello  World.", bold: true) == AttributedString.new("Hello, World!", bold: false)
  end

  def test_equal_strings_with_different_attribute_stores
    s1 = AttributedString.new("hello")
    s2 = AttributedString.new("hello")
    s1.add_attrs(0..2, color: :red)
    s2.add_attrs(0..1, color: :red)
    s2.add_attrs(2..2, color: :red)
    assert_equal s1, s2
  end

  def test_strings_with_different_attributes
    s1 = AttributedString.new("hello")
    s2 = AttributedString.new("hello")
    s1.add_attrs(0..2, color: :red)
    s2.add_attrs(0..2, color: :blue)
    refute_equal s1, s2
  end

  def test_strings_with_different_attribute_ranges
    s1 = AttributedString.new("hello")
    s2 = AttributedString.new("hello")
    s1.add_attrs(0..2, color: :red)
    s2.add_attrs(1..3, color: :red)
    refute_equal s1, s2
  end

  def test_equal_empty_strings
    s1 = AttributedString.new("")
    s2 = AttributedString.new("")
    assert_equal s1, s2
  end

  def test_equal_strings_without_attributes
    s1 = AttributedString.new("hello")
    s2 = AttributedString.new("hello")
    assert_equal s1, s2
  end

  def test_strings_with_attachments
    s1 = AttributedString.new("hello")
    s2 = AttributedString.new("hello")
    s1.add_attachment(:image, position: 1)
    s2.add_attachment(:image, position: 1)
    assert_equal s1, s2
  end

  def test_strings_with_different_attachments
    s1 = AttributedString.new("hello")
    s2 = AttributedString.new("hello")
    s1.add_attachment(:image1, position: 1)
    s2.add_attachment(:image2, position: 1)
    refute_equal s1, s2
  end
end
