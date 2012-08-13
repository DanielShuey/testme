TESTME_INIT = true
TESTME_RUNNING = true

require 'rubygems'
require 'bundler/setup'
Bundler.require :default

testme.dir = '/test/'
testme.suffix = '.test.rb'
testme.format = :none
testme.colors = :default
