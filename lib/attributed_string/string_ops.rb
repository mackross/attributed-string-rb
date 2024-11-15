class AttributedString < String
  class Todo < NotImplementedError
    def message = "Not implemented, consider adding a pull request"
  end

  def insert(index, other)
    if other.is_a?(AttributedString) && other.length > 0
      index = index < 0 ? self.length + index + 1 : index
      new_ranges = split_ranges(@store, index, other.length)
      store = other.instance_variable_get(:@store).map { |obj| obj.dup }
      transpose_ranges(store, index)
      @store.concat(store, new_ranges)
    end
    super
  end


  def concat(other)
    if other.is_a?(AttributedString)
      store = other.instance_variable_get(:@store).map { |obj| obj.dup }
      transpose_ranges(store, self.length)
      @store.concat(store)
    end
    super
  end
  alias_method :<<, :concat

  def prepend(other)
    if other.is_a?(AttributedString)
      store = other.instance_variable_get(:@store).map { |obj| obj.dup }
      transpose_ranges(@store, other.length)
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

  private

  # @api private
  # splits the ranges in the store at the given index
  # if the index is negative, it will be counted from the end of the string
  # @param index [Integer] the index to split the ranges at
  def split_ranges(store, index, gap)
    new_ranges = []
    store.each_with_index do |obj, idx|
      range = obj[:range]
      next if index < range.min
      next if index > range.max
      start = range.min
      if range.exclude_end?
        new_ranges << { range: (index + gap) ... (range.end + gap), attributes: obj[:attributes] }
        range = start...index
      else
        new_ranges << { range: (index + gap) .. (range.end + gap) , attributes: obj[:attributes] }
        range = start..index-1
      end
      obj[:range] = range
    end
    new_ranges
  end


  def transpose_ranges(store, distance)
    store.each do |obj|
      if obj[:range].exclude_end?
        obj[:range] = (obj[:range].begin + distance)...(obj[:range].end + distance)
      else
        obj[:range] = (obj[:range].begin + distance)..(obj[:range].end + distance)
      end
    end
  end
end
