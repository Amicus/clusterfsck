require 'commander'
require 'fileutils'

module ClusterFuck
  module Commands
    class Override
      include ClusterFuck::S3Methods

      attr_reader :key
      def run_command(args, options = {})
        @key = args.first
        contents = reader.read(remote_only: true)
        FileUtils.mkdir_p(File.dirname(reader.local_override_path))
        File.open(reader.local_override_path, "w") do |f|
          f << contents.to_yaml
        end
        $stdout.puts("wrote #{reader.local_override_path} with contents of #{reader.full_s3_path(key)}")
      end

    private
      def reader
        @reader ||= ClusterFuck::Reader.new(key)
      end

    end
  end
end
