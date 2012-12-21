module ClusterFuck
  class Writer
    include S3Methods

    attr_reader :amicus_env
    def initialize(amicus_env)
      @amicus_env = amicus_env
    end

    #todo, thread safety and process safety please
    def set(key, val = {})
      configuration = reader[key]
      yaml = YAML.dump(configuration.merge(val).to_hash)
      s3_object(full_path(key)).write(yaml)
    end

    def reader
      @reader ||= Reader.new(amicus_env)
    end
  end

end
