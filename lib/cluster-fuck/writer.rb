module ClusterFuck
  class Writer
    include S3Methods

    attr_reader :amicus_env

    def initialize
      @amicus_env = ClusterFuck::AMICUS_ENV
    end

    #todo, thread safety and process safety please
    def set(key, val = {})
      configuration = reader[key]
      yaml = YAML.dump(configuration.merge(val).to_hash)
      s3_object(key).write(yaml)
    end

    def reader
      @reader ||= Reader.new
    end
  end
end
