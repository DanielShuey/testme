require File.expand_path('..', __FILE__) + '/spec_helper.rb'

include TestMe

describe TestMe do
  before :each do
    class Person
    end

    test Person
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
        @topic.respond_to?(:name).should == false
      end

      it 'should create a new context' do
        @topic.surname.should == 'smith'
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

  describe '#as' do
    it 'stores the context' do
      given name: 'bob'
    end
  end
end
