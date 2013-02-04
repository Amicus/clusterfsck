module ClusterFuck
  class Reader
    include S3Methods

    attr_reader :amicus_env, :key, :version_count
    def initialize(key, opts={})
      @key = key
      @amicus_env = opts[:amicus_env] || ClusterFuck::AMICUS_ENV
    end

    def read
      obj = s3_object(key)
      yaml = obj.read
      if yaml
        @version_count = obj.versions.count
        Configuration.new(YAML.load(yaml))
      end
    end

  end
end
