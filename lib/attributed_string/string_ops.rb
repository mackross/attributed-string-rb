class AttributedString < String
  class Todo < NotImplementedError
    def message = "Not implemented, consider adding a pull request"
  end

  def insert(index, other)
    return super if other.empty?
    other = AttributedString.new(other) unless other.is_a?(AttributedString)
    index = normalize_index(index, len: self.length + 1)
    split_ranges(@store, index, other.length, self.length + other.length)
    store = other.instance_variable_get(:@store).map { |obj| obj.dup }
    translate_ranges(store, distance: index)
    @store.concat(store)
    super
  end

  def slice(arg, *args)
    result = super
    raise Todo, "Regular expression not implemented for slice, consider raising a pull request" if arg.is_a?(Regexp)

    range = arg.is_a?(Range) ? normalize_range(arg) : normalize_integer_slice_args(arg, *args)

    return range if range.nil?
    raise RuntimeError if range.size != result.length
    store = @store.map do |obj|
      clamped = clamp_range(obj[:range], range)
      next nil if clamped.nil?
      obj.dup.tap do |obj|
        obj[:range] = translate_range(clamped, distance: -range.begin)
      end
    end.compact

    new_string = self.class.new(result)
    new_string.instance_variable_set(:@store, store)
    new_string
  end
  alias_method :[], :slice

  def slice!(arg, *args)
    result = slice(arg, *args)
    return result if result.nil?

    range = arg.is_a?(Range) ? normalize_range(arg) : normalize_integer_slice_args(arg, *args)
    return result if range.nil?

    super(range)

    split_ranges(@store, range.begin, -range.size, self.length)

    result
  end

  def concat(other)
    if other.is_a?(AttributedString)
      store = other.instance_variable_get(:@store).map { |obj| obj.dup }
      translate_ranges(store, distance: self.length)
      @store.concat(store)
    end
    super
  end
  alias_method :<<, :concat

  def prepend(other)
    if other.is_a?(AttributedString)
      store = other.instance_variable_get(:@store).map { |obj| obj.dup }
      translate_ranges(@store, distance: other.length)
      @store.concat(store)
    end
    super
  end


  # modifies the string or returns a modified string
  def replace(other)
    super
    @store = other.instance_variable_get(:@store).map { |obj| obj.dup }
  end

  def +(other)
    self.dup.concat(other)
  end

  def []=(arg, *args, value)
      if arg.is_a?(Regexp)
        raise Todo, "Regular expression assignment not implemented for []=, consider raising a pull request"
      end
      value ||= ""
      value = value.is_a?(AttributedString) ? value : self.class.new(value)

      range = arg.is_a?(Range) ? normalize_range(arg) : normalize_integer_slice_args(arg, *args)
      return nil if range.nil?
      slice!(range)
      insert(range.begin, value)
      value
  end

  private

  def normalize_range(range, len: self.length)
    return nil unless range

     b = range.begin
     e = range.end
     exclude_end = range.exclude_end?

     # Handle nil for begin and end
     b = b.nil? ? 0 : b
     e = e.nil? ? len : e

     # Convert negative indices to positive
     b += len if b < 0
     e += len if e < 0

     # Return nil if adjusted begin index is out of bounds
     return nil if b < 0 || b > len

     # Adjust indices to be within bounds
     b = b.clamp(0, len)
     e = e.clamp(-1, len)

     # Adjust end for exclusive ranges unless both begin and end are nil
     unless range.begin.nil? && range.end.nil?
       e -= 1 if exclude_end
     end

     # Ensure the end index does not exceed len - 1
     e = [e, len - 1].min

     # Return nil if begin index is outside the string
     return nil if b >= len

     # Return empty range if begin > end
     return b...b if b > e

     # Return the normalized range
     b..e
  end

  def normalize_index(index, len: self.length)
    # Convert negative index to positive equivalent
    normalized_index = index < 0 ? len + index : index

    # Clamp the index within string bounds
    [[normalized_index, 0].max, len].min
  end

  def normalize_integer_slice_args(start, *args, len: self.length)
    length_set = args.length == 1
    length = length_set ? args[0] : 1
    # Return nil if start is nil or length is nil or negative
    return nil if !length_set && start >= len

    # Adjust negative start index
    start += len if start < 0

    # Return nil if start is still negative
    return nil if start < 0

    # Adjust length if it extends beyond the string
    max_length = len - start
    length = [length, max_length].min

    # Return nil if length is negative
    return nil if length < 0

    # Return the normalized arguments
    start...(start + length)
  end

  # @api private
  # splits the ranges in the store at the given index
  # if the index is negative, it will be counted from the end of the string
  # @param index [Integer] the index to split the ranges at
  # @param gap [Integer] the gap to insert at the index, if its negative, it will delete
  # @param new_length [Integer] the new length of the string, used to remove ranges that are out of bounds
  def split_ranges(store, index, gap, new_length)
    new_ranges = []
    store.each_with_index do |obj, idx|
      range = obj[:range]

      if gap > 0
        if index <= range.begin
          # Shift the range
          obj[:range] = translate_range(range, distance: gap)
        elsif index > range.begin && index <= range.end
          # Attribute spans over the insertion point; split into two
          original_end = range.end
          obj[:range] = range.begin..(index - 1)
          new_range = (index + gap)..(original_end + gap)
          new_obj = obj.dup
          new_obj[:range] = new_range
          new_ranges << new_obj
        end
      else
        # Deletion logic
        deletion_end = index - gap - 1  # Since gap is negative
        if range.end < index
          # Case 1: Attribute entirely before deletion; no change needed
          next
        elsif range.begin > deletion_end
          # Case 2: Attribute entirely after deletion; shift it
          obj[:range] = translate_range(range, distance: gap)
        elsif range.begin >= index && range.end <= deletion_end
          # Case 5: Attribute entirely within deletion; remove it
          store[idx] = nil
        elsif range.begin >= index && range.end > deletion_end
          # Case 3: Attribute starts within deletion, ends after deletion
          obj[:range] = (index)..(range.end + gap)
        elsif range.begin < index && range.end >= index && range.end <= deletion_end
          # Case 4: Attribute starts before deletion, ends within deletion
          obj[:range] = range.begin..(index - 1)
        elsif range.begin < index && range.end > deletion_end
          # Case 6: Attribute spans over deletion
          obj[:range] = range.begin..(range.end + gap)
        end

        # Remove ranges that are now invalid
        if obj[:range].end < obj[:range].begin || obj[:range].end < 0 || obj[:range].begin >= new_length
          store[idx] = nil
        end
      end
    end
    store.concat(new_ranges)
    store.compact!
  end

  def translate_ranges(store, distance:)
    store.each do |obj|
      obj[:range] = translate_range(obj[:range], distance:)
    end
  end

  def translate_range(range, distance:)
    range.exclude_end? ? (range.begin + distance)...(range.end + distance) : (range.begin + distance)..(range.end + distance)
  end

  def clamp_range(range, clamp_range)
    # Determine the new start index
    new_start = [range.begin, clamp_range.begin].max

    # Adjust ends based on exclude_end?
    range_end_adj = range.exclude_end? ? range.end - 1 : range.end
    clamp_end_adj = clamp_range.exclude_end? ? clamp_range.end - 1 : clamp_range.end

    # Determine the new adjusted end index
    new_end_adj = [range_end_adj, clamp_end_adj].min

    # Check if ranges do not overlap
    if new_start > new_end_adj
      return nil
    end

    # Check if each range includes new_end_adj
    range_includes_new_end = range.cover?(new_end_adj)
    clamp_includes_new_end = clamp_range.cover?(new_end_adj)

    # Determine if the new range should exclude the end
    new_exclude_end = !(range_includes_new_end && clamp_includes_new_end)

    # Construct the new range
    if new_exclude_end
      # For exclusive ranges, the end index is one beyond the last included index
      new_range = new_start... (new_end_adj + 1)
    else
      new_range = new_start..new_end_adj
    end

    new_range
  end
end
