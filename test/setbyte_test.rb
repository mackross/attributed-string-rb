require_relative "test_helper"

class SetbyteTest < Minitest::Test
  def test_setbyte
    assert_raises(AttributedString::Todo) do
      @attr_string.setbyte(0, 0)
    end
  end
end
