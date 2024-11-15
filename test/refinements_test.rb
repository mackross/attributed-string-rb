class RefinementsTest < Minitest::Test
  using AttributedString::Refinements

  def test_can_create_new_from_string_using_refinement
    attr_string = "Hello, World!".to_attr_s
    assert attr_string.is_a?(AttributedString)
    assert attr_string.to_s == "Hello, World!"
  end

  def test_equals
    refute "Hello, World!" == "Hello, World!".to_attr_s
  end

  def test_concat
    new_string = "Hello " + AttributedString.new("World")
    assert new_string.is_a?(AttributedString)
  end
end
