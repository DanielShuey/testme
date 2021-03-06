module TestMe
  module Formatter

    def self.create format
      case format
        when :none
          return Formatter::None.new
        when :console
          return Formatter::Console.new
        when :html
          return Formatter::HTML.new
        when :json
          return false
        when :xml
          return false
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
    
    class Console
      #TODO color_scheme

      def test topic
        log "\n  test ".bright + topic.to_s.bright.color(250, 37, 115)
      end

      def given desc=nil, stubs=nil, &block
        log "    given " + context_to_string(desc, stubs, &block)
      end

      def also desc=nil, stubs=nil, &block
        log "     also " + context_to_string(desc, stubs, &block)
      end

      def is? method, actual, expected, success
        if method.class == Proc
          log '      is ' + block_to_string(&method) + '? ' + (success ? 'YES'.bright.green : "NO".bright.red) + "\n\n"
        else
          log '      is ' + method.to_s + ', ' + expected.to_s.yellow + '? ' + (success ? 'YES'.bright.green : "NO, it was '#{actual}'".bright.red) + "\n\n"
        end
      end

      def compile
        #do nothing
      end

      def describe msg
        log '    ' + msg.bright.yellow
      end
 
    private
      def block_to_string &block
        loc = block.source_location
        read_line_number(loc[0], loc[1]).scan(/{.*}/)[0][2..-2]
      end
      
      def read_line_number(filename, number)
        counter = 0
        line = nil
        File.foreach(filename) do |line|
          counter += 1
          if counter == number
            line.chomp!
            return line
          end
        end
        line = nil if counter != number
        line
      end
      
      def log msg
        puts msg
      end

      def context_to_string desc=nil, stubs=nil, &block
        str = ""

        if desc.class == String || desc.class == Symbol
          str += ":#{desc}: ".bright.cyan
        end

        if desc.class == Hash
          stubs = desc
        end

        if stubs
          str += stubs.map{|k,v| (k.to_s + ': ' + v.to_s)}.join(', ') + ' '
        end

        if block
          str += block_to_string(&block)
        end

        return str
      end

    end
  end
end
