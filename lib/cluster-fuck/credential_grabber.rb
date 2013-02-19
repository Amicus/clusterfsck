module ClusterFsck

  class CredentialGrabber
    FOG_PATH = "~/.fog"
    CF_PATH = "~/.cluster-fsck"

    def self.find
      new.find
    end

    def find
      from_cluster_fsck_file || from_fog_file
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

    def from_cluster_fsck_file
      if exists?(CF_PATH)
        YAML.load_file(CF_PATH)
      end
    end

  private
    def exists?(path)
      File.exist?(path)
    end

  end


end
