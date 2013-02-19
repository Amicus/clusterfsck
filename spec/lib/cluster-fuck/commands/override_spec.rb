require 'spec_helper'
require 'commander'
require 'cluster-fuck/cli'

module ClusterFuck::Commands
  describe Override do
    let(:mock_reader) do
      mock("reader",
           read: "contents",
           local_override_path: "/path/to/nowhere",
           full_s3_path: "test/test-key"
      )
    end
    let(:args) { ["test-key"] }

    before do
      ClusterFuck::Reader.should_receive(:new).with(args.first, amicus_env: 'test').and_return(mock_reader)
    end

    it "should read the remote contents and write the local contents" do
      FileUtils.should_receive(:mkdir_p).with(File.dirname(mock_reader.local_override_path))
      File.should_receive(:open).with(mock_reader.local_override_path, "w")
      subject.run_command(args)
    end
  end
end
