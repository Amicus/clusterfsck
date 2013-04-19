require 'clusterfsck/version'
require 'clusterfsck/setup'
require 'yaml'
require 'aws-sdk'
require 'hashie'
require 'random-word'
require 'commander'

module ClusterFsck
  CLUSTER_FSCK_PATHS = ['./.clusterfsck','/usr/clusterfsck','~/.clusterfsck']

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
    @config_bucket ||= ENV['CLUSTER_FSCK_BUCKET'] || CLUSTER_FSCK_CONFIG['CLUSTER_FSCK_BUCKET'] || Setup.config
  end

  def self.default_env
    ENV['CLUSTER_FSCK_ENV'] || 'development'
  end

  def self.config_hash
    CLUSTER_FSCK_CONFIG
  end

end

require 'clusterfsck/credential_grabber'
require 'clusterfsck/s3_methods'
require 'clusterfsck/configuration'
require 'clusterfsck/reader'
require 'clusterfsck/writer'
