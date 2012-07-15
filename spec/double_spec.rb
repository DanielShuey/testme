require File.expand_path('..', __FILE__) + '/spec_helper.rb'

describe TestMe::Double do
  before :each do
    @topic = TestMe::Double.new
  end

  describe '#method_missing' do
    context 'with stub that returns 5' do
      before :each do
        @topic.test = 5
      end

      specify ('stub should == 5') { @topic.test.should == 5 }
    end

    context 'with stub chain that returns 5' do
      before :each do
        @topic.test.test2 = 5
      end

      specify ('stub chain should return 5') { @topic.test.test2.should == 5 }
    end

    context 'stub chaining over an object' do
      before :each do
        class TestObject
          def hello
            return 'hello'
          end

          def world
            return 'world'
          end
        end

        @topic.test = TestMe::Double.new(TestObject.new)
        @topic.test.test2 = 5
      end

      specify ('stub chain should return 5') { @topic.test.test2.should == 5 }
      specify ('original methods are still callable') { @topic.test.hello.should == 'hello' }

        context 'overriding a method over an object with stub' do
          before :each do
            @topic.test.hello = 'goodbye'
          end

          specify ('method is overridden') { @topic.test.hello.should == 'goodbye' }
          specify ('original methods are still callable') { @topic.test.world.should == 'world' }
        end
    end
  end
end
