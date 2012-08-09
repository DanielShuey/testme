task :push do
  puts `rm *.gem`
  puts `gem build testme.gemspec`
  puts `gem push *.gem`
  puts `rm *.gem`
end
