require 'commander'
require_relative "edit"

module ClusterFuck
  module Commands
    class Create
      include ClusterFuck::S3Methods

      attr_reader :key
      def run_command(args, options = nil)
        @key = args.first
        bucket.objects.create(full_path(key))
        Edit.new.run_command(args)
      end

    end
  end
end
