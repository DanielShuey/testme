require File.expand_path('..', __FILE__) + '/spec_helper.rb'

class Mock; end

describe 'TestMe' do
  before :each do
    extend TestMe
    test Mock
  end

  describe '#topic' do
    specify('is created') {topic.class.name.should == 'TestMe::Double'}
  end

  describe '#given' do
    it 'stubs one' do
      given name: 'bob'
      topic.name.should == 'bob'
    end

    it 'stubs multiple' do
      given name: 'bob', surname: 'smith'
      topic.name.should == 'bob'
      topic.surname.should == 'smith'
    end

    context 'when given is repeated' do
      before :each do
        given name: 'bob'
        given surname: 'smith'
      end

      it 'should clear previous context' do
        topic.respond_to?(:name).should == false
      end

      it 'should create a new context' do
        topic.surname.should == 'smith'
      end
    end

    context 'when block is given' do
      before :each do
        given {topic.name = 'bob'}
      end

      it 'stubs one' do
        given name: 'bob'
        topic.name.should == 'bob'
      end
    end

    context 'when description is given' do
      before :each do
        given :name_is_bob, name: 'bob'
      end

      it 'should save the context' do
        given name: 'fred'
        given :name_is_bob
        
        topic.name.should == 'bob'
      end
    end
  end

  describe '#also' do
    it 'retains the context' do
      given name: 'bob'

      topic.name.should == 'bob'
      topic.surname.should_not == 'smith'

      also surname: 'smith'

      topic.name.should == 'bob'
      topic.surname.should == 'smith'
    end
  end

  describe '#is?' do
    context 'when name is bob' do
      before :each do
        given name: 'bob'
      end

      it 'asserts name is bob' do
        result = is? name: 'bob'
        result.should == true
      end

      it 'asserts name is not fred' do 
        result = is? name: 'fred'
        result.should_not == true
      end
    end

    context 'when Block is given' do
      before :each do
        given name: 'bob'
        @result = is? {topic.name == 'bob'}
      end

      specify('asserts correct result') { @result.should == true }
    end
  end


  context 'modified topic' do
  
    before :each do
      class ArgCounter
        def count *args; return args.size; end
        def true; return true; end
      end
      
      test ArgCounter
    end
  
    describe '#is?' do
      context 'when arguments are given' do

        before :each do
          @result = is? 'count(1)', 1
        end

        specify('asserts correct result') { @result.should == true }
      end
      
      context 'when Symbol is given' do
        specify('parses 0 arguments'){(is? :true).should == true}
        specify('parses 0 arguments'){(is? :count, 0).should == true}
        specify('parses 1 argument with auto-true'){(is? :count, [1]).should == false}
        specify('parses 1 argument with answer'){(is? :count, 1, 1).should == true}
        specify('parses multiple arguments'){(is? :count, [1,1,1], 3).should == true}
      end
    end
    
  end
  
  describe '#test' do
    before :each do
      module Mock2
        def hello; return 'hello'; end
      end
    end
    
    it 'test double of Module' do
      test Mock2
      topic.hello.should == 'hello'
    end
  end

end


