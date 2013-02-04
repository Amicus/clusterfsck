require 'commander'

module ClusterFuck
  module Commands
    class Edit
      include Commander::UI

      attr_reader :key, :options
      def run_command(args, options)
        @key = args.first
        @options = options

        new_yaml = ask_editor(YAML.dump(reader.read.to_hash))
        writer.set(Configuration.from_yaml(new_yaml))
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
