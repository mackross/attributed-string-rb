require_relative "test_helper"

class GsubTest < Minitest::Test
  def test_gsub
    assert_raises(AttributedString::Todo) do
      @attr_string.gsub(/Hello/, "Goodbye")
    end
    assert_raises(AttributedString::Todo) do
      @attr_string.gsub!(/Hello/, "Goodbye")
    end
  end

end
