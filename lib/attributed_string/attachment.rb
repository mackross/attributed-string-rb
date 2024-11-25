class AttributedString < String
  # This character Object Replacement Character is used to represent an attachment in the string.
  ATTACHMENT_CHARACTER = "\u{FFFC}".freeze

  # Adds an attachment to the given position.
  # @param attachment [Object] The attachment to add.
  # @param position [Integer] The position to add the attachment to.
  # @return [AttributedString] self for chaining
  def add_attachment(attachment, position:)
    self.insert(position, ATTACHMENT_CHARACTER)

    range = normalize_range(position..position)
    raise ArgumentError, "Position out of bounds" if range.nil?
    @store << { range:, attachment: }
    self
  end

  def has_attachment?(range: 0...self.length)
    (self.to_s[range]||'').include?(ATTACHMENT_CHARACTER)
  end

  # Returns the attachments at a specific position.
  # @param position [Integer] The index in the string.
  # @return [Array<Object>] The attachments at the given position.
  def attachment_at(position)
    result = nil
    @store.each do |stored_val|
      if stored_val[:range].begin == position && stored_val[:attachment]
        result = stored_val[:attachment]
      end
    end
    result
  end
end
