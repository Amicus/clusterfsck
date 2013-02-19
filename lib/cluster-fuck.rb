require "cluster-fsck/version"
require 'yaml'
require 'aws-sdk'
require 'hashie'

module ClusterFsck
  CONFIG_BUCKET = 'amicus-config'
  AMICUS_ENV = if File.exists?("/mnt/configs/amicus_env.yml")
                 YAML.load_file("/mnt/configs/amicus_env.yml")['amicus_env']
               else
                 ENV['AMICUS_ENV'] || 'development'
               end

  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= Logger.new($stdout)
  end

  def self.amicus_env
    AMICUS_ENV
  end

end

require 'cluster-fsck/credential_grabber'
require 'cluster-fsck/s3_methods'
require 'cluster-fsck/configuration'
require 'cluster-fsck/reader'
require 'cluster-fsck/writer'
