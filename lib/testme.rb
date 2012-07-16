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
  #  ` is? 'inventory(1), 'Arrows'            `
  #  ` is? { topic.inventory(1) == 'Arrows' } `
  def is? *args, &block; end
  # ---------------------------------------------------------------- #

end

# ---------------------------------------------------------------- #
# Optional configuration
# ---------------------------------------------------------------- #
TESTME_CONFIG  = '.testme' unless defined? TESTME_CONFIG 
  # default: '.testme'

TESTME_DIR     = '/test/'  unless defined? TESTME_DIR
  # default: '/test/'

TESTME_SUBDIRS = []        unless defined? TESTME_SUBDIRS
  # default: none; e.g ['feature', 'unit']
  # allows you to test all scripts in subfolder only
  # e.g testme unit

TESTME_FORMAT  = :console  unless defined? TESTME_FORMAT
  # choose how results are displayed
  # options: :console
  # default: :console

TESTME_COLORS  = :default  unless defined? TESTME_COLORS
  # color scheme for console output
  # options: :default
  # default: :default

# ---------------------------------------------------------------- #

# ---------------------------------------------------------------- #
# This is here to disable inline tests at runtime
# ---------------------------------------------------------------- #
if TESTME_RUNNING
  # Gems
  require 'rainbow'

  # TestMe Library
  require 'double'
  require 'formatter'
  require 'logic'
end
# ---------------------------------------------------------------- #
