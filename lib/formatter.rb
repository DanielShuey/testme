module TestMe
  module Formatter

    class Simple

      def test topic
        puts "  test #{topic.name}"
      end

      def given desc=nil, stubs=nil, &block
        puts "    given " + context_to_string(desc, stubs, &block)
      end

      def also desc=nil, stubs=nil, &block
        puts "    also " + context_to_string(desc, stubs, &block)
      end

      def is? method, actual, expected
        success = actual == expected

        puts "      is #{method} #{expected}? " + (success ? 'YES'.green : "NO, it was '#{actual}'".red) + "\n\n"
      end

      def compile
        #do nothing
      end

    private
      def block_to_string &block
        block.to_ruby[6..-3]
      end

      def context_to_string desc=nil, stubs=nil, &block
        str = ""

        if desc.class == String || desc.class == Symbol
          str += ":#{desc} "
        end

        if desc.class == Hash
          str += stubs.map{|k,v| "#{k} is #{v}"}.join(', ') + ' '
        end

        if block
          str += block_to_string(block)
        end

        return str
      end

    end

  end
end
