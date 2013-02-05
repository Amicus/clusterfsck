module ClusterFuck
  class Reader
    include S3Methods

    LOCAL_OVERRIDE_DIR = "cluster-fuck"
    SHARED_ENV = "shared"


    attr_reader :amicus_env, :key, :version_count
    def initialize(key, opts={})
      @key = key
      @amicus_env = opts[:amicus_env] || ClusterFuck::AMICUS_ENV
      @ignore_local = opts[:ignore_local]
    end

    def set_amicus_env_to_shared_unless_key_found!
      unless stored_object.exists?
        original_amicus_env = @amicus_env
        @amicus_env = SHARED_ENV
        raise KeyDoesNotExistError, "there was no #{key} in either #{original_amicus_env} or #{SHARED_ENV}" unless stored_object(true).exists?
      end
    end

    def read(opts = {})
      set_amicus_env_to_shared_unless_key_found!
      yaml = data_for_key(opts)
      if yaml
        @version_count = stored_object.versions.count unless has_local_override?
        Configuration.from_yaml(yaml)
      end
    end

    def has_local_override?
      File.exists?(local_override_path)
    end

    def local_override_path
      File.join(LOCAL_OVERRIDE_DIR, full_s3_path(key))
    end

  private
    def data_for_key(opts = {})
      if has_local_override? and !opts[:remote_only]
        File.read(local_override_path)
      else
        stored_object.read
      end
    end

    def stored_object(reload = false)
      return @stored_object if @stored_object and !reload
      @stored_object = s3_object(key)
    end

  end
end
