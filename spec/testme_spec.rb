require File.expand_path('..', __FILE__) + '/spec_helper.rb'

include TestMe
#module TestMe

  class Mock; end

  describe 'self' do
    before :each do
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
          @result = is? name: 'bob'
        end

        specify('asserts name is bob') { @result.should == true }
      end

      context 'when block is given' do
        before :each do
          given name: 'bob'
          @result = is? {topic.name == 'bob'}
        end

        specify('asserts correct result') { @result.should == true }
      end
    end

    context 'modified topic' do
      describe '#is?' do
        context 'when arguments are given' do

          before :each do

            class Parrot
              def say text
                return text
              end
            end

            test Parrot

            @result = is? 'say(5)', 5
          end

          specify('asserts correct result') { @result.should == true }
        end
      end
    end

  end

#end
