require 'spec_helper'
require 'commander'
require 'cluster-fuck/cli'

module ClusterFuck::Commands
  describe Create do

    let(:amicus_env) { "test" }
    let(:args) { ["test-key"] }
    let(:mock_bucket) do
      mock("bucket",
        objects: mock('objects', create: true)
      )
    end

    before do
      ClusterFuck::Commands::Edit.any_instance.stub(:run_command).and_return(true)
      subject.stub(:bucket).and_return(mock_bucket)
    end

    it "should create the file" do
      subject.bucket.objects.should_receive(:create).with("#{amicus_env}/#{args.first}")
      subject.run_command(args)
    end

    it "should open the editor with the file" do
      ClusterFuck::Commands::Edit.any_instance.should_receive(:run_command).with(args).and_return(true)
      subject.run_command(args)
    end

  end


end
