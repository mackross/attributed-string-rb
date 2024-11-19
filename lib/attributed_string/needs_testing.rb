class AttributedString < String

  def clear
    @store.clear
    super
  end

end
