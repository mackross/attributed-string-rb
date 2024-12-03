class AttributedString < String

  # Returns a filtered string the block will be called with each attribute,
  # value pair. It's an inclusive filter, so if the block returns true, any
  # character with that attribute will be included.
  #
  # This method has been slightly optimized to minimize allocations.
  # @see AttributedString#filter
  # @param attr_string [AttributedString]
  # @param block [Proc] the block to filter the attributes.
  # @return [AttributedString::FilterResult] a filtered string.
  def filter(&block)
    AttributedString::FilterResult.new(self, &block)
  end

  class FilterResult < String
    # @see AttributedString#filter
    def initialize(attr_string, &block)
      filtered_positions = []
      cached_block_calls = {}

      # TODO: this can be optimized to use the same method that inspect uses which doesn't go through
      # every character (it goes through each substring span with different ranges)
      # A presenter type architecture that inspect, rainbow print, and filter can share would be ideal
      attr_string.each_char.with_index do |char, index|
        attrs = attr_string.attrs_at(index)
        # Use the attrs object ID as the cache key to handle different attribute hashes
        cache_key = attrs.hash
        cached_result = cached_block_calls.fetch(cache_key) do
          result = block.call(attrs)
          cached_block_calls[cache_key] = result
          result
        end
        if cached_result
          filtered_positions << index
        end
      end

      # Group adjacent positions into ranges to minimize allocations
      ranges = []
      unless filtered_positions.empty?
        start_pos = filtered_positions.first
        prev_pos = start_pos
        filtered_positions.each_with_index do |pos, idx|
          next if idx == 0
          if pos == prev_pos + 1
            # Continue the current range
            prev_pos = pos
          else
            # End the current range and start a new one
            ranges << (start_pos..prev_pos)
            start_pos = pos
            prev_pos = pos
          end
        end
        # Add the final range
        ranges << (start_pos..prev_pos)
      end

      # Concatenate substrings from the original string based on the ranges
      result_string = ranges.map { |range| attr_string.send(:original_slice,range) }.join

      # Build the list of original positions
      original_positions = ranges.flat_map { |range| range.to_a }

      super(result_string)
      @original_positions = original_positions
      freeze
    end

    def original_position_at(index)
      @original_positions.fetch(index)
    end

    def original_ranges_for(filtered_range)
      # TODO: this doesn't work for excluded end range
      raise ArgumentError, "Invalid range" unless filtered_range.is_a?(Range)
      raise ArgumentError, "Range out of bounds" if filtered_range.end >= length
      if filtered_range.begin > filtered_range.end
        raise ArgumentError, "Reverse range is not allowed"
      end
      if filtered_range.begin == filtered_range.end && filtered_range.exclude_end?
        return []
      end

      original_positions = @original_positions[filtered_range]
      ranges = []
      start_pos = original_positions.first
      prev_pos = start_pos

      original_positions.each_with_index do |pos, idx|
        next if idx == 0
        if pos == prev_pos + 1
          # Continue the current range
          prev_pos = pos
        else
          # End the current range and start a new one
          ranges << (start_pos..prev_pos)
          start_pos = pos
          prev_pos = pos
        end
      end
      # Add the final range
      ranges << (start_pos..prev_pos)
      ranges
    end
  end
end
