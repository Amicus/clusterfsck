module ClusterFuck
  class Writer
    include S3Methods

    attr_reader :amicus_env, :key, :reader
    def initialize(key, opts = {})
      @key = key
      @amicus_env = opts[:amicus_env] || ClusterFuck::AMICUS_ENV
      @reader = opts[:reader] || Reader.new(key)
    end

    #todo, thread safety and process safety please
    def set(val = {})
      configuration = reader.read
      yaml = YAML.dump(configuration.merge(val).to_hash)
      s3_object(key).write(yaml)
    end

  end
end
