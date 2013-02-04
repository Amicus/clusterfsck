require 'commander'

module ClusterFuck
  module Commands
    class List
      include ClusterFuck::S3Methods

      def run_command(args, options = {})
        $stdout.puts(all_files.join("\n"))
      end

    end
  end
end
