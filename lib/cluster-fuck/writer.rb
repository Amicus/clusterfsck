module ClusterFuck
  class Writer
    include S3Methods

    attr_reader :amicus_env, :key
    def initialize(key, opts = {})
      @key = key
      @amicus_env = opts[:amicus_env] || ClusterFuck.amicus_env
    end

    #todo, thread safety and process safety please
    def set(val, version_count = nil)
      raise_unless_version_count_is_good(version_count)
      stored_object.write(val.to_yaml)
      raise_unless_version_count_is_good(version_count + 1) if version_count
    end

    def raise_unless_version_count_is_good(version_count)
      if version_count and stored_object.versions.count > version_count
        raise ConflictError, "File #{key} changed underneath you, version_count expected to be #{version_count} but was #{stored_object.versions.count}"
      end
    end

    def stored_object
      @stored_object ||= s3_object(key)
    end


  end
end
