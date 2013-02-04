require "cluster-fuck/version"

module ClusterFuck
  CONFIG_BUCKET = 'amicus-config'
  AMICUS_ENV = ENV['AMICUS_ENV'] || 'development'

  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= Logger.new($stdout)
  end

end

require 'aws-sdk'
require 'hashie'
require 'yaml'

require 'cluster-fuck/credential_grabber'
require 'cluster-fuck/s3_methods'
require 'cluster-fuck/configuration'
require 'cluster-fuck/reader'
require 'cluster-fuck/writer'
