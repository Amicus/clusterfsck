require "cluster-fsck/version"
require 'yaml'
require 'aws-sdk'
require 'hashie'
require 'random-word'
require 'commander'

module ClusterFsck
  CLUSTER_FSCK_PATHS = ['./.cluster-fsck','/usr/cluster_fsck','~/.cluster-fsck']

  CLUSTER_FSCK_CONFIG = CLUSTER_FSCK_PATHS.map do |path_string|
    path = File.expand_path(path_string)
    YAML.load_file(path) if File.exists?(path)
  end.compact.first || {}

  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= Logger.new($stdout)
  end

  def self.cluster_fsck_env
    raise "Configuration failure, check ~/.clusterfsck or other config values" unless config_bucket
    @env ||= ENV['CLUSTER_FSCK_ENV'] || CLUSTER_FSCK_CONFIG['CLUSTER_FSCK_ENV'] || default_env
  end

  def self.config_bucket
    @config_bucket ||= ENV['CLUSTER_FSCK_BUCKET'] || CLUSTER_FSCK_CONFIG['CLUSTER_FSCK_BUCKET'] || setup_config
  end

  def self.setup_config
    puts <<-UI
      ClusterFsck stores your configuration(s) in an S3 bucket, which must have a unique (global) name.
      The name will be stored in `#{CLUSTER_FSCK_PATHS[2]}` on this machine, and should be placed in
      `#{CLUSTER_FSCK_PATHS[1]}` on your production box (with a different ENV setting if desired).
      It may also be overridden on a per project basis by creating a `#{CLUSTER_FSCK_PATHS[0]}`
      file in the project root. The bucket and ENV setting are first checked from *nix environment
      variables, so these can override file settings as well.  Bucket is read from CLUSTER_FSCK_BUCKET
      and the environment (production, staging, development, etc) is read from CLUSTER_FSCK_ENV.
    UI
    unless CLUSTER_FSCK_CONFIG['CLUSTER_FSCK_BUCKET']
      set_bucket_name
    end
    unless CredentialGrabber.find
      set_aws_keys
    end
    unless S3Methods.bucket.exists?
      warn_create_bucket
    end
    CLUSTER_FSCK_CONFIG['CLUSTER_FSCK_ENV'] ||= default_env
    File.open(File.expand_path(CLUSTER_FSCK_PATHS[2]), 'w') do |f|
      f.write(YAML.dump(config_hash))
    end
    CLUSTER_FSCK_CONFIG['CLUSTER_FSCK_BUCKET']
  end

  def self.set_bucket_name
    random_name = "clusterfsck_#{RandomWord.adjs.next}_#{RandomWord.nouns.next}"
    puts <<-UI
      Enter a name for your bucket, or press enter to accept the randomly generated name:
      #{random_name}
    UI
    input_name = ask("bucket name: ")
    CLUSTER_FSCK_CONFIG['CLUSTER_FSCK_BUCKET'] = input_name.empty? ? random_name : input_name
  end

  def self.set_aws_keys
    CLUSTER_FSCK_CONFIG['AWS_ACCESS_KEY_ID'] = ask("Enter your AWS access key: ")
    CLUSTER_FSCK_CONFIG['AWS_SECRET_ACCESS_KEY'] = ask("Enter your AWS secret access key: ")
  end

  def self.warn_create_bucket
    puts "WARNING: #{config_bucket} does not exist.  Type yes below to have it created for you, or return to abort."
    input = ask("Create bucket #{config_bucket}?: ")
    S3Methods.s3.buckets.create(config_bucket) unless input.empty?
    raise "No bucket present, not created" if input.empty?
  end

  def self.default_env
    ENV['CLUSTER_FSCK_ENV'] || 'development'
  end

  def self.config_hash
    CLUSTER_FSCK_CONFIG
  end

end

require 'cluster-fsck/credential_grabber'
require 'cluster-fsck/s3_methods'
require 'cluster-fsck/configuration'
require 'cluster-fsck/reader'
require 'cluster-fsck/writer'
