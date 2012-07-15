# -*- encoding: utf-8 -*-
$:.unshift(File.expand_path("../lib", __FILE__))
require 'date'

Gem::Specification.new do |s|
  s.name              = 'testme'

  s.version           = begin
      revision = (`git log --pretty=format:'' | wc -l`.to_f / 10).to_s.split('.')
      revision[0] = "0" + revision[0] if revision[0].length < 2
      "0.#{revision[0]}.#{revision[1]}"
    end

  s.date              = Date.today.to_s
  s.authors           = ['Daniel Shuey']
  s.email             = ['daniel.shuey@gmail.com']
  s.summary           = 'Minimalistic testing framework'

  s.description       = <<-END
    Minimalistic testing framework
  END

  s.homepage          = 'http://github.com/danielshuey/testme'

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w(lib)

  s.add_runtime_dependency('rainbow', ['>= 1.1.3'])
end