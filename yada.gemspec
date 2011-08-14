# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yada/version"

Gem::Specification.new do |s|
  s.name        = "yada"
  s.version     = Yada::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Patrick Huesler"]
  s.email       = ["patrick.huesler@googlemail.com"]
  s.homepage    = ""
  s.summary     = "Receive data, yada yada yada dashboard"
  s.description = "Receive data, yada yada yada dashboard"
  s.rubyforge_project = "yada"

  s.add_dependency 'em-websocket'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
