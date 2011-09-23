# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sigma/version"

Gem::Specification.new do |s|
  s.name        = "sigma"
  s.version     = Sigma::VERSION
  s.authors     = ["Justin McGinnis"]
  s.email       = ["justin.mcginnis@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Ruby bindings for the sigma micro controller+ API}
  s.description = %q{see summary}

  s.rubyforge_project = "sigma"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib", "lib/yaml_fields"]
  
  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"

end

