require 'commander'

module ClusterFsck
  module Commands
    class List
      include ClusterFsck::S3Methods

      def run_command(args, options = {})
        @amicus_env = if args.length > 0
                        args.first
                      else
                        ClusterFsck.amicus_env
                      end

        $stdout.puts(all_files.join("\n"))
      end

    end
  end
end
