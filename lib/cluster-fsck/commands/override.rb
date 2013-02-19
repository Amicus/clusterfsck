require 'commander'
require 'fileutils'

module ClusterFsck
  module Commands
    class Override
      include AmicusEnvArgumentParser

      def run_command(args, options = {})
        set_amicus_env_and_key_from_args(args)

        contents = reader.read(remote_only: true)
        FileUtils.mkdir_p(File.dirname(reader.local_override_path))
        File.open(reader.local_override_path, "w") do |f|
          f << contents.to_yaml
        end
        $stdout.puts("wrote #{reader.local_override_path} with contents of #{reader.full_s3_path(key)}")
      end

    private
      def reader
        @reader ||= ClusterFsck::Reader.new(key, amicus_env: amicus_env)
      end

    end
  end
end
