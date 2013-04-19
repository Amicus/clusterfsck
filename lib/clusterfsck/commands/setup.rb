require 'commander'

module ClusterFsck
  module Commands
    class Setup
      def run_command(args, options = {})
        ClusterFsck::Setup.config
      end
    end
  end
end
