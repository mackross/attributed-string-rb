require 'test_helper'

class AddingAttachmentTest < Minitest::Test
  def setup
    @str = AttributedString.new("a string")
    @str.add_attachment("attachment", position: 1)
  end

  def test_adding_attachment_to_empty_string
    @str = AttributedString.new("")
    @str.add_attachment("attachment", position: 0)
    assert_equal ["attachment"], @str.attachments_at(0)
  end

  def test_accessing_attachment
    assert @str.attachments_at(0).empty?
    assert_equal ["attachment"], @str.attachments_at(1)
    assert @str.attachments_at(2).empty?
  end

  def test_range_movements
    str = AttributedString.new("1")
    str.concat(@str)
    assert str.attachments_at(0).empty?
    assert str.attachments_at(1).empty?
    assert_equal ["attachment"], str.attachments_at(2)
    assert str.attachments_at(3).empty?
  end
end
