module TestMe
  @topic

  def topic 
    @topic
  end

  def test topic
    @topic = topic
  end
 
  def given *args, &block; end

  def also *args, &block; end

  def is? *args; end

  def before &block; end

  def self.start!; end

  def self.run path; end
end
