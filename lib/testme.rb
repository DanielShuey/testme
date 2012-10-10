#********************************************************************#
#*                                                                  *#
#*                              Test Me                             *#
#*                                                                  *#
#********************************************************************#

module TestMe
  # Dummy interface for inline tests - you don't want tests to run at application runtime!

  # ---------------------------------------------------------------- #
  # Alleviate the 'the big ball of mud'
  # Test what you mean
  # Pure Ruby DSL
  # ---------------------------------------------------------------- #

  # Retrieve the topic of the test
  def topic; end
  # ---------------------------------------------------------------- #

  # Set the topic of the test
  #   ` test Player `
  def test topic, *args; end
  # ---------------------------------------------------------------- #

  # Provide a context
  #   stubbing an attribute
  #     ` given name: 'Flavie', class: 'Rogue'                  `
  #     ` given { topic.name = 'Flavie; topic.class = 'Rogue' } `
  #   calling a method
  #     ` given { topic.talk_to 'Deckard' }                     `
  def given *args, &block; end
  # ---------------------------------------------------------------- #

  # Provide a context over the existing context
  #   ` given name: 'Flavie' `
  #   `  also class: 'Rogue' `
  def also *args, &block; end
  # ---------------------------------------------------------------- #

  # Create an assertion
  #  ` is? name: 'Flavie'                     `
  #  ` is? :inventory[1], 'Arrows'            `
  #  ` is? { topic.inventory(1) == 'Arrows' } `
  def is? *args, &block; end
  # ---------------------------------------------------------------- #

  # Create a base context
  # Re-runs every time 'given' is called
  #    ` before do <block> end `
  def before &block; end
  # ---------------------------------------------------------------- #

  # Describe the context (if necessary)
  #  ` -'create the context'`

  # ---------------------------------------------------------------- #
  # Config Module
  # ---------------------------------------------------------------- #
  require "configatron"
  @@config = Configatron::Store.new

  # Defaults
  @@config.dir = '/test/'
  @@config.suffix = '.test.rb'
  @@config.format = :console
  @@config.colors = :default

  def self.config; @@config; end
end

# ---------------------------------------------------------------- #
# Test Runner : Inline Testing
# ---------------------------------------------------------------- #
def testme &block
  if block && defined? TESTME_RUNNING && block
    extend TestMe
    block.call
  end

  return TestMe::config
end

# ---------------------------------------------------------------- #
# Optional configuration
# ---------------------------------------------------------------- #
#testme.dir
  # default: '/test/'

#testme.suffix
  # default: '.test.rb'

#testme.format
  # choose how results are displayed
  # options: :none, :console
  # default: :console

#testme.colors
  # color scheme for console output
  # options: :default
  # default: :default

# ---------------------------------------------------------------- #

# ---------------------------------------------------------------- #
# This is here to disable inline tests at runtime
# ---------------------------------------------------------------- #
if defined? TESTME_INIT
  # Gems
  require 'rainbow'
  require 'colorize'

  # TestMe Library
  require 'symbol'
  require 'double'
  require 'formatter'
  require 'logic'
end
# ---------------------------------------------------------------- #
