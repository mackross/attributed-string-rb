class AttributedString < String

  alias_method :original_slice, :slice
  private :original_slice

  # Returns a new instance of AttributedString with the kwargs passed in as
  # attributes for the whole string.
  # @param string [String]
  def initialize(string = "", **attrs)
    super(string)
    @store = []
    add_attrs(0..string.length - 1, attrs) unless attrs.empty? || string.empty?
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
  def add_attrs(range, attributes)
    crange = clamped_range(range)
    binding.irb if range != range
    @store << { range: crange, attributes: attributes }
  end

  # Adds the given attributes in the hash to the range.
  #
  # If the attribute is already set, it will be converted to an array and the new value will be appended.
  #
  # @param range [Range] The range to apply the attributes to.
  # @param attributes [Hash<Symbol, Object>] The attributes to apply to the range.
  def add_arr_attrs(range, attributes)
    @store << { range: range, arr_attributes: attributes }
  end

  # Removes the given attributes from a range.
  # @param range [Range] The range to remove the attributes from.
  # @param attribute_keys [Array<Symbol>] The keys of the attributes to remove.
  def remove_attrs(range, *attribute_keys)
    @store << { range: range, delete: attribute_keys }
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
        else
          result.merge!(stored_val[:attributes])
        end
      end
    end
    result
  end

  def ==(other)
    return false unless other.is_a?(AttributedString)
    super && @store == other.instance_variable_get(:@store)
  end

  private

  def clamped_range(range)
    if range.max >= length
      if range.exclude_end?
        range.min...length
      else
        range.min..length - 1
      end
    else
      range
    end
  end

end
