require "cluster-fuck/version"

module ClusterFuck
  CONFIG_BUCKET = 'amicus-config'
end

require 'aws-sdk'
require 'hashie'
require 'yaml'

require 'cluster-fuck/credential_grabber'
require 'cluster-fuck/s3_methods'
require 'cluster-fuck/configuration'
require 'cluster-fuck/reader'
require 'cluster-fuck/writer'
