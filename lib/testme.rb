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
  #   ` test Player `
  def test topic; end
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

  def before &block; end
end

# ---------------------------------------------------------------- #
# Inline Testing
# ---------------------------------------------------------------- #
def testme &block; end

# ---------------------------------------------------------------- #
# Optional configuration
# ---------------------------------------------------------------- #
module TestMe
  TESTME_DIR     = defined?(::TESTME_DIR)    ? ::TESTME_DIR : '/test/'
    # default: '/test/'

  TESTME_SUFFIX  = defined?(::TESTME_SUFFIX) ? ::TESTME_SUFFIX : '.test.rb'

  TESTME_FORMAT  = defined?(::TESTME_FORMAT) ? ::TESTME_FORMAT : :console
    # choose how results are displayed
    # options: :none, :text, :console
    # default: :console

  TESTME_COLORS  = defined?(::TESTME_COLORS) ? ::TESTME_COLORS : :default
    # color scheme for console output
    # options: :default
    # default: :default
end

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
