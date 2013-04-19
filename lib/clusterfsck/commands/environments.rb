require 'commander'

module ClusterFsck
  module Commands
    class Environments
      include ClusterFsck::S3Methods

      def run_command(args, options = {})
        $stdout.puts(all_environments.join("\n"))
      end

    end
  end
end
