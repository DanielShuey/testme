module TestMe
  class Double
    def initialize subject=nil
      @subject = subject if subject
      @dict = Hash.new
      @overrides = Hash.new
    end

    def method_missing(method, *args, &block)
      if @subject 
        if @subject.respond_to?(method) && !@dict.key?(method)
          return @subject.send(method, *args, &block)
        end
      end

      if method.to_s =~ /=$/
        return @dict[method.to_s.match(/^(.*)=$/)[1].to_sym] = args.first
      else
        return @dict[method] ||= Double.new
      end
    end

  end
end
