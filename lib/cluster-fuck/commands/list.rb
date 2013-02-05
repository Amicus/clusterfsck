require 'commander'

module ClusterFuck
  module Commands
    class List
      include ClusterFuck::S3Methods

      def run_command(args, options = {})
        @amicus_env = if args.length > 0
                        args.first
                      else
                        ClusterFuck.amicus_env
                      end

        $stdout.puts(all_files.join("\n"))
      end

    end
  end
end
