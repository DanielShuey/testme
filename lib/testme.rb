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

  # ---------------------------------------------------------------- #
  # Optional configuration
  # ---------------------------------------------------------------- #
  attr_accessor :config_path # default: '.testme'

  attr_accessor :test_folder # default: '/test/'

  attr_accessor :subfolders  # default: none; e.g ['feature', 'unit']
                             # allows you to test all scripts in subfolder only
                             # e.g testme unit

  attr_accessor :formatter   # choose how results are displayed
                             # options: :console

  attr_accessor :colorscheme # color scheme for console output
                             # options: default
  # ---------------------------------------------------------------- #
end

require 'rainbow'

require 'double'
require 'formatter'
require 'logic'
