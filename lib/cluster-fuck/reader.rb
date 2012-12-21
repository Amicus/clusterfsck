module ClusterFuck

  class Reader

    include S3Methods

    attr_reader :amicus_env
    def initialize(amicus_env)
      @amicus_env = amicus_env
    end

    def [](key)
      yaml = s3_object(full_path(key)).read
      if yaml
        Configuration.new(YAML.load(yaml))
      end
    end

    def method_missing(meth, *args, &block)
      val = self.[](meth)
      if val
        val
      else
        super
      end
    end

  end

end
