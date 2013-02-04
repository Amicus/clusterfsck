require 'commander'
require_relative "edit"

module ClusterFuck
  module Commands
    class Create
      include ClusterFuck::S3Methods

      attr_reader :key
      def run_command(args, options = nil)
        @key = args.first
        obj = s3_object(key)
        raise ConflictError, "#{key} already exists!" if obj.exists?
        obj.write('')
        Edit.new.run_command(args)
      end

    end
  end
end
