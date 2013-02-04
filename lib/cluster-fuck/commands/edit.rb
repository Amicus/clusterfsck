require 'commander'

module ClusterFuck
  module Commands
    class Edit
      include Commander::UI

      attr_reader :key, :options

      def run_command(args, options)
        @key = args.first
        @options = options

        new_yaml = ask_editor(YAML.dump(reader[key].to_hash))
        writer.set(key, YAML.load(new_yaml))
      end

      def writer
        @writer ||= ClusterFuck::Writer.new
      end

      def reader
        @reader ||= ClusterFuck::Reader.new
      end

    end
  end
end
