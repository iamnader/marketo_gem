$LOAD_PATH.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |spec|
  spec.name = "marketo"
  spec.version = "1.4.3"
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["Nader Akhnoukh"]
  spec.email = ["iamnader@gmail.com"]
  spec.homepage = "https://github.com/kapost/marketo_gem"
  spec.summary = "A Marketo SOAP API client."
  spec.description = "A Marketo SOAP API client."
  spec.require_path = ["lib"]

  spec.add_dependency("savon", ">= 0.8.3")
  spec.add_development_dependency "rake"
  spec.add_development_dependency "gemsmith"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-state"
  spec.add_development_dependency "pry-rescue"
  spec.add_development_dependency "pry-stack_explorer"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rb-fsevent" # Guard file events for OSX.
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "terminal-notifier"
  spec.add_development_dependency "terminal-notifier-guard"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "codeclimate-test-reporter"

  spec.files = Dir["lib/**/*"]
  spec.extra_rdoc_files = Dir["README*"]
  spec.require_paths = ["lib"]
end
