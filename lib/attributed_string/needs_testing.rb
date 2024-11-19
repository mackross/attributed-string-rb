class AttributedString < String

  def clear
    @store.clear
    super
  end
  def inspect
    # Collect all positions where attributes change
    positions = Set.new
    @store.each do |attr|
      range = attr[:range]
      positions << range.begin
      positions << range.end + 1  # Since range is inclusive
    end

    # Include the start and end positions of the string
    positions << 0
    positions << self.length

    # Sort all positions
    positions = positions.to_a.sort

    result = ""
    last_attrs = {}  # Initialize as empty hash

    positions.each_cons(2) do |start_pos, end_pos|
      next if start_pos >= end_pos  # Skip invalid ranges

      substring = self.to_s[start_pos...end_pos]
      current_attrs = attrs_at(start_pos)

      # Determine attribute changes
      if last_attrs != current_attrs
        # Close any attributes that have ended
        ended_attrs = last_attrs.keys - current_attrs.keys
        result += dim(format_attribute_endings(ended_attrs)) unless ended_attrs.empty?

        # Open any new or changed attributes
        started_attrs = current_attrs.reject { |k, v| last_attrs[k] == v }
        result += dim(format_attributes(started_attrs)) unless started_attrs.empty?
      end

      result += substring

      last_attrs = current_attrs
    end

    # Close any remaining attributes
    unless last_attrs.empty?
      result += dim(format_attribute_endings(last_attrs.keys))
    end

    result
  end

  private

  def dim(string)
    "\e[2m#{string}\e[22m"
  end

  def format_attributes(attrs)
    return "" if attrs.empty?
    "{#{attrs.map { |k, v| "#{k}: #{v}" }.join(', ')}}"
  end

  def format_attribute_endings(attr_keys)
    return "" if attr_keys.empty?
    "{#{attr_keys.map { |k| "-#{k}" }.join(' ')}}"
  end

end
