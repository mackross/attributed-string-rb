class AttributedString
# Inspect prints the attributed string in an easily readable way.
# An example inspect output "{ k1: 1 }these have the attributes k1: 1 { k1: 2, k2: true }these have 2 attrs k1: 2, and k2: true { -k2 }and these have k1: 2 { -k1 }and these have none"
# could be constructed as:
#
#   ("these have the attributes k1: 1 ".to_attr_s(k1: 1) +
#   "these have 2 attrs k1: 2, and k2: true ".to_attr_s(k1: 2, k2: true) +
#   "and these have k1: 2 ".to_attr_s(k1: 2) +
#   "and these have none").inspect
#
  def inspect(color: false)
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
      attrs_before = last_attrs
      attrs_after = attrs_at(start_pos)

      # Determine attribute changes
      ended_attrs = {}
      started_attrs = {}

      # Attributes that have ended or changed
      attrs_before.each do |key, value|
        if !attrs_after.key?(key)
          # Attribute has ended
          ended_attrs[key] = value
        elsif attrs_after[key] != value
          # Attribute value has changed; treat as ending old and starting new
          ended_attrs[key] = value
          started_attrs[key] = attrs_after[key]
        end
      end

      # Attributes that have started
      attrs_after.each do |key, value|
        if !attrs_before.key?(key)
          started_attrs[key] = value
        end
      end

      # Remove attributes that both ended and started (value change)
      ended_attrs.delete_if { |k, _| started_attrs.key?(k) }

      unless ended_attrs.empty? && started_attrs.empty?
        attrs_str = ended_attrs.keys.sort.map{ |k| "-#{k}" }
        attrs_str += started_attrs.to_a.sort{ |a,b| a[0] <=> b[0] }.map{ |a| "#{a[0]}: #{a[1]}" }
        attrs_str = "{ #{attrs_str.join(', ')} }"
        result += dim(attrs_str, color: color)
      end

      # Append the substring
      result += substring

      last_attrs = attrs_after
    end

    # Close any remaining attributes
    unless last_attrs.empty?
      result += dim("{ #{last_attrs.keys.sort.map{ |k| "-#{k}" }.join(", ")} }", color: color)
    end

    result
  end


  def dim(string, color: true)
    color ? "\e[2m#{string}\e[22m" : string
  end

end
