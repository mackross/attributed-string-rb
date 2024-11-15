class AttributedString < String
  def inspect
    # TODO: make better
    return "AttributedString: '#{self}' store: #{@store.inspect}"
  end

  def clear
    @store.clear
    super
  end

end
