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

    if desc.class == String || desc.class == Symbol
      if stubs == nil and block == nil
        load_context desc
        return
      end

      save_context desc, stubs, true, &block
    elsif desc.class == Hash
      stubs = desc
    end

    set_context stubs, &block
  end

  def also desc=nil, stubs=nil, &block
    if desc.class == String || desc.class == Symbol
      if stubs == nil and block == nil
        load_context desc
        return
      end

      save_context desc, stubs, true, &block
    elsif desc.class.name == 'Hash'
      stubs = desc
    end

    set_context stubs, &block
  end

  def is? *args, &block
    if block
      return block.call
    else
      if args[0].class == Hash
        method = args[0].first[0]
        value = args[0].first[1]
        return topic.send(method) == value
      end

      if args[0].class == String
        actual = eval("@topic.#{args[0]}")
        expected = args[1]
        return actual == expected
      end
    end
  end

  def before &block; end

  def self.run path; end

private
  class Context
    attr_accessor :name, :block, :stubs, :clear
  end

  def save_context name, stubs, clear, &block
    c = Context.new
    c.name = name
    c.stubs = stubs if stubs
    c.clear = clear
    c.block = block if block

    @contexts[name] = c
  end

  def load_context name
    c = @contexts[name]
    set_context c.stubs, &c.block
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
