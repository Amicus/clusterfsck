module ClusterFsck
  module Commands
    module ClusterFsckEnvArgumentParser

      def self.included(base)
        base.send(:attr_reader, :key) unless base.respond_to?(:reader_key)
        base.send(:include, ClusterFsck::S3Methods)
      end

      def set_cluster_fsck_env_and_key_from_args(args)
        if args.length > 1
          @cluster_fsck_env, @key = args
        else
          @key = args.first
        end
      end


    end
  end
end
