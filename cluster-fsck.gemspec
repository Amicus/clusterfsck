# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cluster-fsck/version'

Gem::Specification.new do |gem|
  gem.name          = "cluster-fsck"
  gem.version       = ClusterFsck::VERSION
  gem.authors       = ["Topper Bowers"]
  gem.email         = ["topper@amicushq.com"]
  gem.description   = "cluster-aware S3 and ZK based config getter/setter"
  gem.summary       = ""
  gem.homepage      = ""

  # we need a big version here, because we rely on a change made in january
  # that was breaking EC2 provider credentials
  gem.add_dependency "aws-sdk", "~> 1.8.1.2"
  gem.add_dependency "hashie"
  gem.add_dependency "random-word"
  gem.add_dependency "commander", "~> 4.1.0"

  gem.add_development_dependency "rspec"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
