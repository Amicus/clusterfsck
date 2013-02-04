require 'spec_helper'
require 'commander'
require 'cluster-fuck/cli'

module ClusterFuck::Commands
  describe Edit do
    let(:blank_options) { Commander::Command::Options.new }
    subject { Edit.new }
    let(:key) { "test-key" }
    let(:mock_writer) { mock("writer", set: true) }

    let(:dummy_val) do
      {
          key => {
            'test' => true
          }
      }
    end

    let(:dummy_yaml) { YAML.dump(dummy_val) }
    let(:mock_s3_obj) { mock(:s3_object, read: dummy_yaml) }

    before do
      ClusterFuck::Reader.any_instance.stub(:s3_object).and_return(mock_s3_obj)
    end

    describe "with a key" do
      let(:args) { [key] }
      let(:options) { blank_options }

      it "should open the yaml version of the key in an editor" do
        subject.should_receive(:ask_editor).with(dummy_yaml).and_return(dummy_yaml)
        subject.stub(:writer).and_return(mock_writer)
        mock_writer.should_receive(:set).with(key, dummy_val).once
        subject.run_command(args, options)
      end

    end



  end
end
