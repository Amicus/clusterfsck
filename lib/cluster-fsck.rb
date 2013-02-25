require "cluster-fsck/version"
require 'yaml'
require 'aws-sdk'
require 'hashie'
require 'random-word'
require 'commander'

module ClusterFsck
  CLUSTER_FSCK_PATHS = ['./.cluster-fsck-config','/usr/cluster_fsck_config','~/.cluster-fsck-config']
  SETUP_BUCKET = ->() {
    random_name = "clusterfsck_configs_#{RandomWord.adjs.next}_#{RandomWord.nouns.next}"
    puts <<-UI
      ClusterFsck stores your configuration(s) in an S3 bucket, which must have a unique (global) name.
      The name will be stored in `#{CLUSTER_FSCK_PATHS[2]}` on this machine, and should be placed in
      `#{CLUSTER_FSCK_PATHS[1]}` on your production box (with a different ENV setting if desired).
      It may also be overridden on a per project basis by creating a `#{CLUSTER_FSCK_PATHS[0]}`
      file in the project root. Enter a name for your bucket, or press enter to accept the randomly
      generated name:
      #{random_name}
    UI
    input_name = ask("bucket name: ")
    bucket_name = input_name.empty? ? random_name : input_name
    File.open(File.expand_path(CLUSTER_FSCK_PATHS[2]), 'w') do |f|
      f.write(YAML.dump({'BUCKET' => bucket_name, 'ENV' => 'development' }))
    end
    bucket_name
  }

  CLUSTER_FSCK_CONFIG = CLUSTER_FSCK_PATHS.map do |path_string|
    path = File.expand_path(path_string)
    YAML.load_file(path) if File.exists?(path)
  end.compact.first || {}

  CONFIG_BUCKET = CLUSTER_FSCK_CONFIG['BUCKET'] || SETUP_BUCKET.call
  CLUSTER_FSCK_ENV = CLUSTER_FSCK_CONFIG['ENV'] || 'development'

  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= Logger.new($stdout)
  end

  def self.cluster_fsck_env
    CLUSTER_FSCK_ENV
  end

end

require 'cluster-fsck/credential_grabber'
require 'cluster-fsck/s3_methods'
require 'cluster-fsck/configuration'
require 'cluster-fsck/reader'
require 'cluster-fsck/writer'
