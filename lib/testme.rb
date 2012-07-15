#********************************************************************#
#*                                                                  *#
#*                              Test Me                             *#
#*                                                                  *#
#********************************************************************#

module TestMe
  # ---------------------------------------------------------------- #
  # Alleviate the 'the big ball of mud'
  # Test what you mean
  # Pure Ruby DSL
  # ---------------------------------------------------------------- #

  # Retrieve the topic of the test
  def topic; end
  # ---------------------------------------------------------------- #

  # Set the topic of the test
  #   ` test Person `
  def test topic; end
  # ---------------------------------------------------------------- #

  # Provide a context
  #   stubbing an attribute
  #     ` given name: 'Bob', surname: 'Smith' `
  #   calling a method
  #     ` given topic.talk_to 'Bob' `
  def given *args, &block; end
  # ---------------------------------------------------------------- #

  # Provide a context over the existing context
  #   ` given name: 'Bob' `
  #   ` also surname: 'Smith' `
  def also *args, &block; end
  # ---------------------------------------------------------------- #

  # Create an assertation
  #    ` is? name: 'Bob' `
  def is? *args; end
  # ---------------------------------------------------------------- #

  # Create a base context
  # Re-runs every time 'given' is called
  #    ` before do <block> end `
  def before &block; end
  # ---------------------------------------------------------------- #

  # Run test cases in path
  def self.run path; end
  # ---------------------------------------------------------------- #
end

require 'rainbow'
require 'logic'
require 'double'
