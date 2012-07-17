def testme &block
  extend TestMe
  block.call
end

module TestMe

  def topic
    @topic
  end

  def test topic
    @@formatter ||= Formatter::create(TESTME_FORMAT)
  
    @@formatter.test topic
    
    @before = nil
    @contexts = {}
    @topic_class = topic.name
    @topic = Double.new(Object::const_get(@topic_class).new)
  end
 
  def given desc=nil, stubs=nil, &block
    @before.call if @before
  
    @@formatter.given desc, stubs, &block

    @topic = Double.new(Object::const_get(@topic_class).new)

    if desc.class == String || desc.class == Symbol
      if stubs == nil and block == nil
        load_context desc
        return
      end

      save_context desc, stubs, &block
    elsif desc.class == Hash
      stubs = desc
    end

    set_context stubs, &block
  end

  def also desc=nil, stubs=nil, &block
    @@formatter.also desc, stubs, &block

    if desc.class == String || desc.class == Symbol
      if stubs == nil and block == nil
        load_context desc
        return
      end

      save_context desc, stubs, &block
    elsif desc.class.name == 'Hash'
      stubs = desc
    end

    set_context stubs, &block
  end

  def is? *args, &block
    if block
      method = block
      result = block.call
    else
      if args[0].class == Hash
        method = args[0].first[0]
        expected = args[0].first[1]
        actual = topic.send(method)
        result = actual == expected
      end

      if args[0].class == String
        method = args[0]
        actual = eval("@topic.#{args[0]}")
        expected = args[1]
        result = actual == expected
      end
    end

    @@formatter.is? method, actual, expected

    result
  end
  
  def before &block
    @before = block
  end

private
  class Context
    attr_accessor :name, :block, :stubs
  end

  def save_context name, stubs, &block
    c = Context.new
    c.name = name
    c.stubs = stubs if stubs
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
