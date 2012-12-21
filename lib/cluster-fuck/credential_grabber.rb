module ClusterFuck

  class CredentialGrabber
    FOG_PATH = "~/.fog"
    CF_PATH = "~/.cluster-fuck"

    def self.find
      new.find
    end

    def find
      from_cluster_fuck_file || from_fog_file
    end

    def from_fog_file
      if exists?(FOG_PATH)
        fog_credentials = YAML.load_file(FOG_PATH)
        {
            access_key_id: fog_credentials[:default][:aws_access_key_id],
            secret_access_key: fog_credentials[:default][:aws_secret_access_key],
        }
      end
    end

    def from_cluster_fuck_file
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
