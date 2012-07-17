module TestMe
  module Formatter

    def self.create format
      case format
        when :none
          return Formatter::None.new
        when :text
          return Formatter::Text.new
        when :console
          return Formatter::Console.new
        when :html
          return Formatter::HTML.new
      end
    end
 
    class None
      def test topic; end
      def given *args, &block; end
      def also *args, &block; end
      def is? *args; end
      def compile; end
    end

    class Html
      def test topic; end
      def given *args, &block; end
      def also *args, &block; end
      def is? *args; end
      def compile; end
    end
    
    class Text
      def test topic
        log "test " + topic.name
      end

      def given desc=nil, stubs=nil, &block
        log "given " + context_to_string(desc, stubs, &block)
      end

      def also desc=nil, stubs=nil, &block
        log "also " + context_to_string(desc, stubs, &block)
      end

      def is? method, actual, expected
        success = actual == expected

        log 'is ' + method.to_s + ', ' + expected.to_s + '? ' + (success ? 'YES' : "NO, it was '#{actual}'")
      end

      def compile
        #do nothing
      end

    private
      def block_to_string &block
        "(block)"
      end

      def context_to_string desc=nil, stubs=nil, &block
        str = ""

        if desc.class == String || desc.class == Symbol
          str += ":#{desc}: "
        end

        if desc.class == Hash
          stubs = desc
        end

        if stubs
          str += stubs.map{|k,v| (k.to_s + ': ' + v.to_s)}.join(', ')
        end

        if block
          str += block_to_string(&block)
        end

        return str
      end
    end
    
    class Console
      #TODO color_scheme

      def test topic
        log "\n  test " + topic.name.bright.color(250, 37, 115)
      end

      def given desc=nil, stubs=nil, &block
        log "    given " + context_to_string(desc, stubs, &block)
      end

      def also desc=nil, stubs=nil, &block
        log "     also " + context_to_string(desc, stubs, &block)
      end

      def is? method, actual, expected
        success = actual == expected

        log 'is ' + method.to_s + ', ' + expected.to_s + '? ' + (success ? 'YES'.green : "NO, it was '#{actual}'".red) + "\n\n"
      end

      def compile
        #do nothing
      end

    private
      def block_to_string &block
        "(block)"
      end
      
      def log msg
        puts msg
      end

      def context_to_string desc=nil, stubs=nil, &block
        str = ""

        if desc.class == String || desc.class == Symbol
          str += ":#{desc}: ".blue
        end

        if desc.class == Hash
          stubs = desc
        end

        if stubs
          str += stubs.map{|k,v| (k.to_s + ': ' + v.to_s).bright}.join(', ') + ' '
        end

        if block
          str += block_to_string(&block)
        end

        return str
      end

    end

  end
end
