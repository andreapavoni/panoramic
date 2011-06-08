# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "panoramic"
  s.version     ='0.0.2' 
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andrea Pavoni"]
  s.email       = ["andrea.pavoni@gmail.com"]
  s.homepage    = "http://github.com/apeacox/panoramic"
  s.summary     = %q{Stores rails views on database}
  s.description = %q{Stores rails views on database}

  s.add_dependency 'rails', "~> 3.0.7"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
