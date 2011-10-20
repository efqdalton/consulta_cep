# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "consulta_cep/version"

Gem::Specification.new do |s|
  s.name        = "consulta_cep"
  s.version     = ConsultaCep::VERSION
  s.authors     = ["Dalton"]
  s.email       = ["dalthon@dlt.local"]
  s.homepage    = ""
  s.summary     = %q{A very simple gem to fetch brazilian postalcodes from www.correios.com.br }
  s.description = %q{A very simple gem to fetch brazilian postalcodes from www.correios.com.br }

  s.rubyforge_project = "consulta_cep"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'nokogiri'

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
