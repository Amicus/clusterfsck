module ClusterFuck
  class Reader
    include S3Methods

    attr_reader :amicus_env

    def initialize
      @amicus_env = ClusterFuck::AMICUS_ENV
    end

    def [](key)
      yaml = s3_object(key).read
      if yaml
        Configuration.new(YAML.load(yaml))
      end
    end

  end
end
