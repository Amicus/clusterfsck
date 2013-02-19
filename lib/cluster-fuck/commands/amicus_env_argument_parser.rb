module ClusterFuck
  module Commands
    module AmicusEnvArgumentParser

      def self.included(base)
        base.send(:attr_reader, :key) unless base.respond_to?(:reader_key)
        base.send(:include, ClusterFuck::S3Methods)
      end

      def set_amicus_env_and_key_from_args(args)
        if args.length > 1
          @amicus_env, @key = args
        else
          @key = args.first
        end
      end


    end
  end
end
