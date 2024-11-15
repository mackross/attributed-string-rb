
  require 'test_helper'

  class WithoutRefinementsTest < Minitest::Test

    def test_to_attr_s_with_no_args
      assert_raises(NoMethodError) do
        attr_string = "Hello, World!".to_attr_s
        assert attr_string.is_a?(AttributedString)
      end
    end

    def test_concat
      new_string = "Hello " + AttributedString.new("World")
      assert new_string.is_a?(String)
    end

  end
