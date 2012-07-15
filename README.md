# i am test
*A straight forward testing framework*

    i am Test
      given :simple, true
        is? :simple, true

>   Alleviate the 'the big ball of mud'

>   Test what you mean

>   Pure Ruby DSL

## Setup

`gem install iamtest` (not available yet)

Put in Gemfile

`gem "testme", :git => "git@github.com:DanielShuey/testme.git"`

Start testing

    Iamtest.start!
    
As a Raketask

    task :test do
        require 'iamtest'
        Iamtest.start!
        Dir.glob(File.dirname(__FILE__) + '/tests/**/*.test.rb') {|file| require file}
    end

## Detailed Example

    i am Pizza
      given style: 'Pepperoni', owner: 'Santoni'
        is? :name, "Santoni's Pepperoni Pizza"
    
      given style: 'Pepperoni' # Context resets
        is? :name, "Santoni's Pepperoni Pizza"
    
      also owner: 'Santoni' # Add on to previous context
        is? :name, "Santoni's Pepperoni Pizza"

> ### Output

>     i am Pizza
>       given style is 'Pepperoni', owner is 'Santoni'
>         is name, Santoni's Pepperoni Pizza? YES
>        
>       given style is 'Pepperoni'
>         is name, Santoni's Pepperoni Pizza? NO, it was 'Pepperoni Pizza'!
>        
>       also owner is 'Santoni'
>         is name, Santoni's Pepperoni Pizza? YES

## RSpec Comparison of above example

    describe Pizza
      before do
        @pizza = Factory.build :pizza
      end
    
      describe '#name'
        context 'when style is Pepperoni and owner is Santoni' do
          before :all do
            @pizza.stub(:style => 'Pepperoni')
            @pizza.stub(:owner => 'Santoni')
          end
    
          it "should be Santoni's Pepperoni Pizza" do
            @pizza.name.should == "Santoni's Pepperoni Pizza"
          end
        end
        
        context 'when style is Pepperoni' do
          before :all do
            @pizza.stub(:style => 'Pepperoni')
          end
    
          it "should be Santoni's Pepperoni Pizza" do
            @pizza.name.should == "Santoni's Pepperoni Pizza"
          end
          
          context 'when style is Pepperoni' do
              before :all do
                @pizza.stub(:name => 'Santoni's')
              end

              it "should be Santoni's Pepperoni Pizza" do
                @pizza.name.should == "Santoni's Pepperoni Pizza"
              end
          end
        end
      end
    end

> ### Output

## Keywords
#### `i am`
> Defines the topic of the test

> can be accessed with `topic`

    I am Person
    
***

#### `given`
> Sets the context

    given first_name: 'Deckard', surname: 'Cain'
    
    $ topic.first_name
    $ => "Deckard" 
    
    $ topic.surname
    $ => "Cain"
    
> Clears any previous context

    given first_name: 'Deckard'
    given first_name: 'Flavie'
    
    $ topic.first_name
    $ => "Flavie"

> Create or Overwrite methods that can return anything on the topic (Stubbing)

    given non_existent_method: "this never existed before"
    
    $ topic.non_existent_method
    $ => "this never existed before"
    
> Or run your own code

    given topic.talk_to 'Cain'

***

#### `also`
> Provides a context over the existing context

    given first_name: 'Deckard'
        also surname: 'Cain'
        
    $ topic.first_name
    $ => "Deckard" 
    
    $ topic.surname
    $ => "Cain"

***

#### `is?`
> Creates an assertion

    is? :first_name, 'Deckard' 

    is? :sum, [2, 2], 4

    is? topic.sum(2, 2), 4

## "This is too easy! How can I make this more challenging?"

There is something about you that troubles me. Your manner is strange for a lonely code warrior.

## Design Decisions

#### Context Sensitive

I found that a lot of complexity with setting up tests is due to wrapping things in contexts. As tests are most often executed sequentially from the top down, this is often unnecessary.

This also eliminates teardown and tearup sequences, and can save a lot of time. Instead of executing our setup for every single test case, we only setup exactly what is needed once, and adjust as necessary between test cases. This works because we often readjust every state required to run the next test in order to maintain clarity. Meaning being able to hop in-between contexts is often unnecessary.

#### Self Documenting Tests

We are seeing less and less the use of code comments, and instead focusing more on self documenting code, tests and stories to describe our functionality.

Especially when describing contexts there is no need to re-describe them. Abstracting explicit tests and describing them with behaviour also makes tests much more difficult to maintain or delete.

#### DRY Contexts

In order to get around not having wrapped contexts we use re-usable contexts, that can be defined during the creation of the context itself. With other testing frameworks we have to define a method, however if you want to stay BDD this means you have to re-describe the context when you re-use it. 

Cucumber solves this issue by allowing you to use a sentence structure to load a context. The only problem with this is you have to create steps for even the most specific contexts which are often un-reusable, and these contexts are specified away from the tests. This causes a lot of disorganisation and fragmentation without even the most diligent testers. It makes your test code bloat really fast, and makes it difficult to control.

Iamtest draws on Cucumber's style while staying concise by allowing you to optionally define a description for the context, and just re-specify the description when re-using the context. Allowing the test to be self documenting. Keeping tests cases and logic together reduces fragmentation and makes tests easier to maintain.

#### The business case issue

> Some people may be quick to judge that this is not in the vein of Cucumber's philosophy of being able to have BA's   write the stories that are then directly implemented into the program. To me this doesn't seem like a great idea for the following reasons. 

> #### The big ball of mud
> You can almost guarantee that you will be creating a new step definition for every single sentence in the story. The fragmentation caused by separation of step definitions and stories also causes problems with test maintenance. A testers role does not involve just writing tests, it also involves deleting them, a rare occurrence in a lot of teams.

> #### Performance, Security and Maintenance
> It is the programmers job to translate the business rules into code, and it should be no different for tests. A bad coder writes spaghetti code, a bad tester writes spaghetti tests.

> I could not fathom the performance, security and maintenance issues we would have if we allowed BA's to write our code. The same goes for tests, when we have BA's write our tests for us, we run into a lot of those problems.

> BA's will also often miss the subtle nuances required in testing, such as writing test cases to cover security, the speed of test runs, and declarative tests for maintenance.

> Instead we should have BA's write our stories, and testers should translate this into concise well-defined tests. Paired development between tester and BA may be a counter-argument, but often this means simply giving up and allowing the BA to make a few mistakes in order to encourage the process, as being too picky will often discourage the BA. I for one would be not willing to make such a sacrifice.

## Credit

See License.