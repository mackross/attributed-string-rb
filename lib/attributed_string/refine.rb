class AttributedString
  module Refinements
    refine String do
      unless self.class == AttributedString
      # @param attrs [Hash] A hash of attributes to apply to the string.
      # @return [Instruct::AttributedString] A new AttributedString with the given attributes.
      def to_attr_s(**attrs)
        AttributedString.new(self, **attrs)
      end

      alias_method :original_eq, :==
      private :original_eq
      def ==(other)
        return false if other.is_a?(AttributedString)
        original_eq(other)
      end

        alias_method :original_plus, :+
        private :original_plus
        def +(other)
          if other.is_a?(AttributedString)
            other.class.new(self) + other
          else
            original_plus(other)
          end
        end

        alias_method :original_concat, :concat
        private :original_concat
        def concat(*args)
          args.each do |arg|
            if arg.is_a?(AttributedString)
              raise ArgumentError, "Cannot concatenate AttributedString to String"
            end
          end
          original_concat(*args)
          self
        end
      end
    end
  end
end
