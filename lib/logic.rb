module TestMe
  def topic
    @topic
  end

  def test topic
    @topic = nil
    @before = nil
    @contexts = {}
  
    @@formatter ||= Formatter::create(testme.format)
    @@formatter.test topic
    
    @topic_class = topic
    
    if topic.instance_of? Module
      o = Object.new
      o.extend topic
      @topic = Double.new(o) 
    end
    
    if topic.instance_of? Class
      @topic = Double.new(topic.new)
    end
    
    raise Exception, "Topic needs to be a Class or a Module" unless @topic
  end
 
  def given desc=nil, stubs=nil, &block
    @before.call if @before
  
    @@formatter.given desc, stubs, &block

    @topic = Double.new(@topic_class.new)

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
      if args[0].is_a? Hash
        method = args[0].first[0]
        expected = args[0].first[1]
        actual = topic.send(method)
      end
      
      if args[0].is_a? Symbol
        params = args[0].args
        expected = args[1]
        actual = topic.send(args[0], *params)
      
        method = args[0].to_s + (params ? '(' + params.join(',') + ')' : '')
      end
      
      expected = true if expected.nil?
      result = actual == expected
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
  
  def class_from_string(str)
    str.split('::').inject(Object) do |mod, class_name|
      mod.const_get(class_name)
    end
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
