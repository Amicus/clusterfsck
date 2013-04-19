require 'commander'
require_relative "edit"

module ClusterFsck
  module Commands
    class Create
      include ClusterFsckEnvArgumentParser

      def run_command(args, options = {})
        raise ArgumentError, "must provide a project name" if args.empty?
        set_cluster_fsck_env_and_key_from_args(args)
        obj = s3_object(key)
        raise ConflictError, "#{key} already exists!" if obj.exists?
        obj.write('')
        Edit.new.run_command(args)
      end

    end
  end
end
