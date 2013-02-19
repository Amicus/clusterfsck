require 'commander'
require_relative "edit"

module ClusterFsck
  module Commands
    class Create
      include AmicusEnvArgumentParser

      def run_command(args, options = {})
        set_amicus_env_and_key_from_args(args)
        obj = s3_object(key)
        raise ConflictError, "#{key} already exists!" if obj.exists?
        obj.write('')
        Edit.new.run_command(args)
      end

    end
  end
end
