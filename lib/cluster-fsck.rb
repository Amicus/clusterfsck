require "cluster-fsck/version"
require 'yaml'
require 'aws-sdk'
require 'hashie'
require 'random-word'
require 'commander'

module ClusterFsck
  CLUSTER_FSCK_PATHS = ['./.cluster-fsck','/usr/cluster_fsck','~/.cluster-fsck']
  DEFAULT_ENV = 'development'

  CLUSTER_FSCK_CONFIG = CLUSTER_FSCK_PATHS.map do |path_string|
    path = File.expand_path(path_string)
    YAML.load_file(path) if File.exists?(path)
  end.compact.first || {}

  CLUSTER_FSCK_ENV = ENV['CLUSTER_FSCK_ENV'] || CLUSTER_FSCK_CONFIG['ENV'] || DEFAULT_ENV

  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= Logger.new($stdout)
  end

  def self.cluster_fsck_env
    CLUSTER_FSCK_ENV
  end

  def self.config_bucket
    @config_bucket ||= ENV['CLUSTER_FSCK_BUCKET'] || CLUSTER_FSCK_CONFIG['BUCKET'] || setup_bucket
  end

  def self.setup_bucket
    random_name = "clusterfsck_#{RandomWord.adjs.next}_#{RandomWord.nouns.next}"
    puts <<-UI
      ClusterFsck stores your configuration(s) in an S3 bucket, which must have a unique (global) name.
      The name will be stored in `#{CLUSTER_FSCK_PATHS[2]}` on this machine, and should be placed in
      `#{CLUSTER_FSCK_PATHS[1]}` on your production box (with a different ENV setting if desired).
      It may also be overridden on a per project basis by creating a `#{CLUSTER_FSCK_PATHS[0]}`
      file in the project root. The bucket and ENV setting are first checked from *nix environment
      variables, so these can override file settings as well.  Bucket is read from CLUSTER_FSCK_BUCKET
      and the environment (production, staging, development, etc) is read from CLUSTER_FSCK_ENV.
      Enter a name for your bucket, or press enter to accept the randomly generated name:
      #{random_name}
    UI
    input_name = ask("bucket name: ")
    bucket_name = input_name.empty? ? random_name : input_name
    File.open(File.expand_path(CLUSTER_FSCK_PATHS[2]), 'w') do |f|
      f.write(YAML.dump({'BUCKET' => bucket_name, 'ENV' => DEFAULT_ENV }))
    end
    bucket_name
  end


end

require 'cluster-fsck/credential_grabber'
require 'cluster-fsck/s3_methods'
require 'cluster-fsck/configuration'
require 'cluster-fsck/reader'
require 'cluster-fsck/writer'
