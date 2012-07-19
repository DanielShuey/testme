# Test Me
*A minimalistic testing framework*

    test Me
      given simple: true
        is? :simple

## Setup

#### Put in your Gemfile

`gem "testme", :git => "git@github.com:DanielShuey/testme.git"`

## Run

#### Test all
default: /test/

    $ testme

#### Test all in directory
    
    $ testme test/features

#### Test file

    $ testme test/account.test.rb
    
#### Inline testing
    
    $ testme app/models
    
>

    class Account
    end

    testme do
      test Account
    end

>

    class Account

      field :name

      def what_is_my_name
        return name
      end
      
      testme {
        test Account
        given name: 'Fred'
        is? what_is_my_name: 'Fred'
      }
      
    end
    
>

    class Account
      extend TestMe; test Account
      
      field :name

      def what_is_my_name
        return name
      end
      
      #what_is_my_name
        given name: 'Fred'
        is? what_is_my_name: 'Fred'
    end
    
## Detailed Example

    test Pizza
      given owner: 'Santoni', style: 'Pepperoni' # Set the context
        is? name: "Santoni's Pepperoni Pizza"
    
      given name: 'Michel' # Reset the context
        is? name: "Santoni's Pepperoni Pizza"
        
       also :hawaiian_style, style: 'Hawaiian' # Add on to previous context and save it
        is? name: "Michels's Hawaiian Pizza"
      
      given :hawaiian_style # Reload the saved context
       also { topic.owner = 'Santoni' } # Use a block instead
        is? name: "Santoni's Hawaiian Pizza"
      
> ### Output

>     test Pizza
>       given owner: 'Santoni', style: 'Pepperoni'
>         is name, Santoni's Pepperoni Pizza? YES
>
>       given name: 'Michel'
>         is name, Santoni's Pepperoni Pizza? NO, it was Michel's Pizza! 
>
>        also :hawaiian_style: style: 'Hawaiian'
>         is name, Michel's Hawaiian Pizza? YES
>
>       given :hawaiian_style:
>        also (block)
>         is name, Santoni's Hawaiian Pizza? YES

## Keywords
#### `test`
> Defines the topic of the test

    test Account
    
>

    test App::Account

> This automatically creates an instance which you access with `topic`

    topic.name
    
> Both modules and classes can be used for the test topic

    test AccountHelper
    
> (At the moment you can only test instance methods, class methods will also be testable in a later update)

***

#### `given`
> Set the context

    given first_name: 'Deckard', surname: 'Cain'
    
    $ topic.first_name
    $ => "Deckard" 
   
    $ topic.surname
    $ => "Cain"
    
> Clear any previous context

    given first_name: 'Deckard'
    given first_name: 'Flavie'
    
    $ topic.first_name
    $ => "Flavie"

> Create or Overwrite methods that can return anything on the topic (Stubbing)

    given non_existent_method: "this never existed before"
    
    $ topic.non_existent_method
    $ => "this never existed before"
    
> Create a context using a block

    given { topic.talk_to 'Flavie' }
    
> Code run inside a block will still automatically stub for you

    given { topic.non_existent_method = "this never existed before" }
    
> Store a context

    given :deckard_cains_name, name: Name.new(first: 'Deckard', last: 'Cain')
    
> Load a context
    
    given :deckard_cains_name
    
> Create a stub chain

    given { topic.name.first = 'Deckard' }
    
> Stub chains will also only override the method you stub, while keeping the remaining associations intact

    given :deckard_cains_name { topic.name.first = 'Flavie' }
    
    $ topic.name.last
    $ => "Cain"
    
***

#### `also`
> Provides a context over the existing context

    given first_name: 'Deckard'
     also surname: 'Cain'
        
    $ topic.first_name
    $ => "Deckard" 
    
    $ topic.surname
    $ => "Cain"
    
> Anything you can do in `given` you can also do in `also`

    given name: Name.new(first: 'Deckard', last: 'Cain')
     also :flavies_name { topic.name.first = 'Flavie' }
    
    given name: Name.new(first: 'Deckard', last: 'Cain')
     also :flavies_name
    
    $ topic.name.first
    $ => "Flavie"

***

#### `is?`
> Creates an assertion

> If there are no arguments you can do it simply like this

    is? first_name: 'Deckard' 
    
> Or like this

    is? :first_name, 'Deckard'

> If there are arguments, you can put your expression inside a string

    is? 'sum(2,2)', 4
    
> Or put your arguments in an array
(Although the Array is not necessary if there is only one parameter)

    is? :sum, [2,2], 4
    
> Or you can also use a block

    is? {topic.sum(2, 2) == 4}
    
> If the expected value is `true` you don't have to state it
 
    is? 'simple?'
    
>

    is? :simple?
    
***

#### `before`
> Creates a base context

> Remains until `test` is invoked again

    before { topic.do_some_factory_stuff }

## "This is too easy! How can I make this more challenging?"

There is something about you that troubles me. Your manner is strange for a lonely code warrior.

## How long till version 1.0?

When these features are completed

 - Test class methods (only instance methods can be tested at this time)
 - Blocks need to parsed back into a string
 - Test more complex method stubbing
 - Console color schemes
 - HTML reporting

## Design Decisions

#### Context Sensitive

I found that a lot of complexity with setting up tests is due to wrapping things in contexts. As tests are often executed sequentially from the top down anyway, this is often unnecessary.

This also eliminates teardown and tearup sequences, and can save a lot of time. Instead of executing our setup for every single test case, we only setup exactly what is needed once, and adjust as necessary between test cases. This works because we often readjust every state required to run the next test in order to maintain clarity. Meaning being able to hop in-between contexts is often unnecessary.

#### Self Documenting Tests

TestMe aims to reduce the use of code comments and test descriptions, and instead focusing more on self documenting code to describe our functionality.

Especially when describing contexts there is no need to re-describe them. Abstracting explicit tests and describing them with behaviour also makes tests much more difficult to maintain or delete.

#### DRY Contexts

In order to get around not having wrapped contexts we use re-usable contexts, that can be defined during the creation of the context itself. With other testing frameworks we have to define a method, however if you want to stay BDD this means you have to re-describe the context when you re-use it. 

Cucumber solves this issue by allowing you to use a sentence structure to load a context. The only problem with this is you have to create steps for even the most specific contexts which are often un-reusable, and these contexts are specified away from the tests. This causes a lot of disorganisation and fragmentation without even the most diligent testers. It makes your test code bloat really fast, and makes it difficult to control.

TestMe draws on Cucumber's style while staying concise by allowing you to optionally define a description for the context, and just re-specify the description when re-using the context. Allowing the test to be self documenting. Keeping tests cases and logic together reduces fragmentation and makes tests easier to maintain.

## Credit

Daniel Shuey - daniel.shuey@gmail.com

## License

Copyright 2012 Daniel Shuey

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
