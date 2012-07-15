module TestMe
  def topic
    @topic
  end

  def test topic
    @contexts = {}
    @topic_class = topic.name
    @topic = Double.new(Object::const_get(@topic_class).new)
  end
 
  def given desc=nil, stubs=nil, &block
    @topic = Double.new(Object::const_get(@topic_class).new)

    if desc.class.name == 'String' || desc.class.name == 'Symbol'
      save_context(desc, stubs, true, block)
    elsif desc.class.name == 'Hash'
      stubs = desc
    end

    set_context stubs, &block
  end

  def also desc=nil, stubs=nil, &block
    set_context stubs, &block
  end

  def as desc
    @contexts[desc] = @topic
  end

  def is? *args; end

  def before &block; end

  def self.start!; end

  def self.run path; end

  class Context
    attr_accessor :name, :block, :stubs, :clear
  end

private
  def save_context name, stubs, clear, &block
    c = Context.new
    c.name = name
    c.block = block if block
    c.stubs = stubs if stubs
    c.clear = clear

    @contexts[name] = c
  end

  def set_context stubs=nil, &block
    if stubs
      stubs.each do |k, v|
        @topic.send("#{k}=".to_sym, v)
      end
    end

    if block
      block.call
    end
  end
end
