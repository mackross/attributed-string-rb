require "test_helper"

class PrependTest < Minitest::Test
  def test_prepend
    hello = AttributedString.new("Hello,", bold: true)
    world = AttributedString.new(" World!", italic: true)
    hello.prepend(world)
    assert_equal(" World!Hello,", hello.to_s)
    assert_equal " World!", world.to_s
    0.upto(6) do |i|
      assert_equal({ italic: true }, hello.attrs_at(i))
    end
    7.upto(12) do |i|
      assert_equal({ bold: true }, hello.attrs_at(i))
    end
  end
end
