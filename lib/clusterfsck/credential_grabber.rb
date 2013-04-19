module ClusterFsck

  class CredentialGrabber
    FOG_PATH = "~/.fog"
    CF_PATH = "~/.clusterfsck"

    def self.find
      new.find
    end

    def find
      from_env_vars || from_cluster_fsck_config || from_fog_file
    end

    def from_fog_file
      if exists?(File.expand_path(FOG_PATH))
        fog_credentials = YAML.load_file(File.expand_path(FOG_PATH))
        {
            access_key_id: fog_credentials[:default][:aws_access_key_id],
            secret_access_key: fog_credentials[:default][:aws_secret_access_key],
        }
      end
    rescue ArgumentError #when there is no HOME, File.expand_path above raises ArgumentError
      nil
    end

    def from_env_vars
      if ENV['AWS_ACCESS_KEY_ID'] && ENV['AWS_SECRET_ACCESS_KEY']
        {
            access_key_id: ENV['AWS_ACCESS_KEY_ID'],
            secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        }
      end
    end

    def from_cluster_fsck_config
      if ClusterFsck::CLUSTER_FSCK_CONFIG['AWS_ACCESS_KEY_ID'] &&
         ClusterFsck::CLUSTER_FSCK_CONFIG['AWS_SECRET_ACCESS_KEY']
        {
            access_key_id: ClusterFsck::CLUSTER_FSCK_CONFIG['AWS_ACCESS_KEY_ID'],
            secret_access_key: ClusterFsck::CLUSTER_FSCK_CONFIG['AWS_SECRET_ACCESS_KEY'],
        }
      end
    end

  private
    def exists?(path)
      File.exist?(path)
    end

  end

end
