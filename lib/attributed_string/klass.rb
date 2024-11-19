class AttributedString < String

  alias_method :original_slice, :slice
  private :original_slice

  # Returns a new instance of AttributedString with the kwargs passed in as
  # attributes for the whole string.
  # @param string [String]
  def initialize(string = "", **attrs)
    super(string)
    @store = []
    add_attrs(**attrs)
  end

  def dup
    super.tap do |copy|
      new_store = @store.map do |entry|
        entry[:range] = entry[:range].dup
        entry.dup
      end
      copy.instance_variable_set(:@store, new_store)
    end
  end

  # Adds the given attributes in the hash to the range.
  # @param range [Range] The range to apply the attributes to.
  # @param attributes [Hash<Symbol, Object>] The attributes to apply to the range.
  # @return [AttributedString] self for chaining
  def add_attrs(range = 0..self.length - 1, **attributes)
    range = normalize_range(range)
    return self if attributes.empty? || self.empty? || range.nil? || range.size.zero?
    @store << { range: range, attributes: attributes }
    self
  end

  # Adds the given attributes in the hash to the range.
  #
  # If the attribute is already set, it will be converted to an array and the new value will be appended.
  #
  # @param range [Range] The range to apply the attributes to.
  # @param attributes [Hash<Symbol, Object>] The attributes to apply to the range.
  # @return [AttributedString] self for chaining
  def add_arr_attrs(range, **attributes)
    range = normalize_range(range)
    return self if attributes.empty? || self.empty? || range.nil? || range.size.zero?
    @store << { range: range, arr_attributes: attributes }
    self
  end

  # Adds an attachment to the given position.
  # @param attachment [Object] The attachment to add.
  # @param position [Integer] The position to add the attachment to.
  # @return [AttributedString] self for chaining
  def add_attachment(attachment, position:)
    range = normalize_range(position..position)
    range = 0...0 if position.zero? && self.empty?
    raise ArgumentError, "Position out of bounds" if range.nil?
    return self if attachment.nil? || (self.empty? && position != 0)
    @store << { range:, attachment: }
    self
  end

  # Returns the attachments at a specific position.
  # @param position [Integer] The index in the string.
  # @return [Array<Object>] The attachments at the given position.
  def attachments_at(position)
    result = []
    @store.each do |stored_val|
      if stored_val[:range].begin == position && stored_val[:attachment]
        result << stored_val[:attachment]
      end
    end
    result
  end


  # Need to think about how this works as the attachment store is an array
  # def remove_attachment(position)
  #   raise Todo
  # end


  # Removes the given attributes from a range.
  # @param range [Range] The range to remove the attributes from.
  # @param attribute_keys [Array<Symbol>] The keys of the attributes to remove.
  # @return [AttributedString] self for chaining
  def remove_attrs(range, *attribute_keys)
    @store << { range: range, delete: attribute_keys }
    self
  end

  # Returns the attributes at a specific position.
  # @param position [Integer] The index in the string.
  # @return [Hash] The attributes at the given position.
  def attrs_at(position)
    result = {}
    @store.each do |stored_val|
      if stored_val[:range].include?(position)
        if stored_val[:delete]
          stored_val[:delete].each do |key|
            result.delete(key)
          end
        elsif stored_val[:arr_attributes]
          stored_val[:arr_attributes].each do |key, value|
            result[key] = [result[key]] if result.key?(key) && !result[key].is_a?(Array)
            if value.is_a?(Array)
              (result[key] ||= []).concat(value)
            else
              (result[key] ||= []).push(value)
            end
          end
        elsif stored_val[:attributes]
          result.merge!(stored_val[:attributes])
        end
      end
    end
    result
  end

  def ==(other)
    return false unless other.is_a?(AttributedString)
    # not super efficient, but it works for now
    (0...length).all? { |i| attrs_at(i) == other.attrs_at(i) && attachments_at(i) == other.attachments_at(i) }
  end




end
