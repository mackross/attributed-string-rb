require_relative "test_helper"

class ReverseTest < Minitest::Test

  def test_reverse
    assert_raises(AttributedString::Todo) do
      @attr_string.reverse!
    end
    assert_raises(AttributedString::Todo) do
      @attr_string.reverse
    end
  end
end
