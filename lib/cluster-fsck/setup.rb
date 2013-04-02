module ClusterFsck
  module Setup
    def self.config
      puts <<-UI
        ClusterFsck stores your configuration(s) in an S3 bucket, which must have a unique (global) name.
        The name will be stored in `#{ClusterFsck::CLUSTER_FSCK_PATHS[2]}` on this machine, and should be placed in
        `#{ClusterFsck::CLUSTER_FSCK_PATHS[1]}` on your production box (with a different ENV setting if desired).
        It may also be overridden on a per project basis by creating a `#{ClusterFsck::CLUSTER_FSCK_PATHS[0]}`
        file in the project root. The bucket and ENV setting are first checked from *nix environment
        variables, so these can override file settings as well.  Bucket is read from CLUSTER_FSCK_BUCKET
        and the environment (production, staging, development, etc) is read from CLUSTER_FSCK_ENV.
      UI
      unless ClusterFsck::CLUSTER_FSCK_CONFIG['CLUSTER_FSCK_BUCKET']
        set_bucket_name
      end
      unless ClusterFsck::CredentialGrabber.find
        set_aws_keys
      end
      unless ClusterFsck::S3Methods.s3.buckets[ClusterFsck::CLUSTER_FSCK_CONFIG['CLUSTER_FSCK_BUCKET']].exists?
        warn_create_bucket
      end
      ClusterFsck::CLUSTER_FSCK_CONFIG['CLUSTER_FSCK_ENV'] ||= ClusterFsck.default_env
      File.open(File.expand_path(ClusterFsck::CLUSTER_FSCK_PATHS[2]), 'w') do |f|
        f.write(YAML.dump(ClusterFsck.config_hash))
      end
      ClusterFsck::CLUSTER_FSCK_CONFIG['CLUSTER_FSCK_BUCKET']
    end

    def self.set_bucket_name
      random_name = "clusterfsck_#{RandomWord.adjs.next}_#{RandomWord.nouns.next}"
      puts <<-UI
        Enter a name for your bucket, or press enter to accept the randomly generated name:
        #{random_name}
      UI
      input_name = ask("bucket name: ")
      CLUSTER_FSCK_CONFIG['CLUSTER_FSCK_BUCKET'] = input_name.empty? ? random_name : input_name
    end

    def self.set_aws_keys
      CLUSTER_FSCK_CONFIG['AWS_ACCESS_KEY_ID'] = ask("Enter your AWS access key: ")
      CLUSTER_FSCK_CONFIG['AWS_SECRET_ACCESS_KEY'] = ask("Enter your AWS secret access key: ")
    end

    def self.warn_create_bucket
      puts "WARNING: #{ClusterFsck.config_bucket} does not exist.  Type yes below to have it created for you, or return to abort."
      input = ask("Create bucket #{ClusterFsck.config_bucket}?: ")
      S3Methods.s3.buckets.create(ClusterFsck.config_bucket) unless input.empty?
      raise "No bucket present, not created" if input.empty?
    end
  end
end