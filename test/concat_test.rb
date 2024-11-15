require "test_helper"

class ConcatTest < Minitest::Test
  def test_concat_string
    hello = AttributedString.new("Hello,", bold: true)
    world = AttributedString.new(" World!", italic: true)
    hello.concat(world)
    assert_equal("Hello, World!", hello.to_s)
    assert_equal " World!", world.to_s
    0.upto(5) do |i|
      assert_equal({ bold: true }, hello.attrs_at(i))
    end
    6.upto(12) do |i|
      assert_equal({ italic: true }, hello.attrs_at(i))
    end
  end

  def test_concat_string_with_double_less_than
    hello = AttributedString.new("Hello,", bold: true)
    world = AttributedString.new(" World!", italic: true)
    hello << world
    0.upto(5) do |i|
      assert_equal({ bold: true }, hello.attrs_at(i))
    end
    6.upto(12) do |i|
      assert_equal({ italic: true }, hello.attrs_at(i))
    end
  end

  def test_plus_normal_string
    attr_str = AttributedString.new("Hello, World!", bold: true)
    new_str = attr_str + " Boom!"
    assert attr_str.to_s == "Hello, World!"
    assert new_str.is_a?(AttributedString)
    0.upto(12) do |i|
      assert_equal({ bold: true }, new_str.attrs_at(i))
    end
    13.upto(18) do |i|
      assert_equal({}, new_str.attrs_at(i))
    end
  end

  def test_plus_attributed_string
    hello = AttributedString.new("Hello,", bold: true)
    world = AttributedString.new(" World!", italic: true)
    new_str = hello + world
    assert_equal "Hello, World!", new_str.to_s
    assert_equal AttributedString.new("Hello,", bold: true), hello
    assert_equal AttributedString.new(" World!", italic: true), world
    0.upto(5) do |i|
      assert_equal({ bold: true }, new_str.attrs_at(i))
    end
    6.upto(12) do |i|
      assert_equal({ italic: true }, new_str.attrs_at(i))
    end
  end
end
