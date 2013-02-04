require 'commander'

module ClusterFuck
  module Commands
    class Edit
      include Commander::UI

      attr_reader :key, :options
      def run_command(args, options = Hashie::Mash.new)
        @key = args.first
        @options = options
        raise ArgumentError, "File #{key} is overridden locally! use --force to force" if reader.has_local_override? and !options.force

        new_yaml = ask_editor(YAML.dump(reader.read(remote_only: true).to_hash))
        writer.set(Configuration.from_yaml(new_yaml), reader.version_count)
      end

      def writer
        @writer ||= ClusterFuck::Writer.new(key)
      end

      def reader
        @reader ||= ClusterFuck::Reader.new(key)
      end

    end
  end
end
