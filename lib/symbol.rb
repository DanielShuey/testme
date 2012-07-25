class Symbol
  def [] *args
    @args = *args
    self
  end
  
  def args
    @args || []
  end
end
