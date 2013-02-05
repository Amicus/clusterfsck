module ClusterFuck
  module Commands
    module AmicusEnvArgumentParser

      def self.included(base)
        [:amicus_env, :key].each do |reader_key|
          base.send(:attr_reader, reader_key) unless base.respond_to?(:reader_key)
        end
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
