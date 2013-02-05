require "cluster-fuck/version"
require 'yaml'
require 'aws-sdk'
require 'hashie'

module ClusterFuck
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

require 'cluster-fuck/credential_grabber'
require 'cluster-fuck/s3_methods'
require 'cluster-fuck/configuration'
require 'cluster-fuck/reader'
require 'cluster-fuck/writer'
