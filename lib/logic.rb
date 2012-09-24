module TestMe
  def topic
    @topic
  end

  def test topic, *args
    @topic = nil
    @before = nil
    @contexts = {}
    @args = args
  
    @@formatter = Formatter::create(testme.format)
    
    case topic.class
      when String || Symbol
        @topic_class = Object
        @@formatter.test topic
      else
        @topic_class = topic
        @@formatter.test @topic_class
    end
    
    reset_topic
  end
 
  def given desc=nil, stubs=nil, &block
    @before.call if @before
  
    @@formatter.given desc, stubs, &block

    reset_topic

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
      
        method = args[0].to_s + ( params.size > 0 ? '(' + params.join(',') + ')' : '')
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

  def self.formatter
    return @@formatter
  end

private
  class Context
    attr_accessor :name, :block, :stubs
  end
  
  def reset_topic
   if @topic_class.instance_of? Module
      o = Object.new
      o.extend @topic_class
      @topic = Double.new(o) 
    end
    
    if @topic_class.instance_of? Class
      @topic = Double.new(@topic_class.new(*@args))
    end
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

class String
  def -@
    TestMe::formatter.describe self
  end
end
