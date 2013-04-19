# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cluster-fsck/version'

Gem::Specification.new do |gem|
  gem.name          = "clusterfsck"
  gem.version       = ClusterFsck::VERSION
  gem.authors       = ["Topper Bowers, Brian Glusman"]
  gem.email         = ["topper@amicushq.com, brian@amicushq.com"]
  gem.description   = "cluster-aware S3 based config getter/setter"
  gem.summary       = %Q{
    ClusterFsck manages configurable settings and sensitive login information
    across any number of separate or related projects by reading writing simple
    values or arrays/hashes of data to and from YAML files stored on Amazon S3.
    It also allows centrally overriding or changing these on a per environment
    basis.
  }
  gem.homepage      = "http://github.com/amicus/clusterfsck"

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
