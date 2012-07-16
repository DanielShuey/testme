module TestMe
  module Formatter

    def self.selected
      case TESTME_FORMAT
        when :none
          return None.new
        when :console
          return Console.new
      end
    end

    class None
      def test topic; end
      def given *args, &block; end
      def also *args, &block; end
      def is? *args; end
      def compile; end
    end

    class Console

      #TODO color_scheme

      def test topic
        puts "\n  test " + topic.name.bright.color(250, 37, 115)
      end

      def given desc=nil, stubs=nil, &block
        puts "    given " + context_to_string(desc, stubs, &block)
      end

      def also desc=nil, stubs=nil, &block
        puts "     also " + context_to_string(desc, stubs, &block)
      end

      def is? method, actual, expected
        success = actual == expected

        puts '      is ' + method.to_s + ', ' + expected.to_s + '? ' + (success ? 'YES'.green : "NO, it was '#{actual}'".red) + "\n\n"
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
