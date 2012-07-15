module TestMe
  class Double
    def initialize subject=nil
      @subject = subject if subject
      @stub = Hash.new
    end

    def create_method_chain
      
    end

    def method_missing(method, *args, &block)
      if @stub[method]
        @stub[method].call *args, &block
      else
        @subject.send(method, *args, &block)
      end
    end

    def send_with_chain(methods, *args)
      obj = self
      [methods].flatten.each {|m| obj = obj.send(m, *args)}
      obj
    end

    def stub name, &block
      @stub[name.to_s]
    end
  end
end
