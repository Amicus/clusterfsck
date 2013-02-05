require 'spec_helper'

module ClusterFuck

  describe Reader do
    let(:amicus_env) { 'test' }
    let(:key) { "test-key" }
    let(:reader) { Reader.new(key) }
    let(:mock_s3_obj) { mock(:s3_object, read: nil, :exists? => true) }


    it "should set amicus_env" do
      reader.amicus_env.should == amicus_env
    end

    describe "when there is a local override" do
      let(:local_yaml) { YAML.dump(foo: true) }
      let(:local_path) { "cluster-fuck/#{amicus_env}/#{key}" }

      before do
        File.should_receive(:exists?).at_least(1).times.with(local_path).and_return(true)
        File.stub(:read).with(local_path).and_return(local_yaml)
      end

      it "should #has_local_override?" do
        reader.has_local_override?.should be_true
      end

      it "should use the local override when it exists" do
        reader.read.should == Configuration.from_yaml(local_yaml)
      end
    end

    describe "#read" do
      let(:version_count) { 3 }

      before do
        mock_s3_obj.stub({
            read: YAML.dump({
              foo: 'bar'
            }),
            versions: mock('versions', count: version_count)
        })
        reader.stub(:s3_object).with(key).and_return(mock_s3_obj)
        reader.stub(:s3_object).with(key.to_sym).and_return(mock_s3_obj)
      end

      it "should load the remote file and yaml parse it" do
        reader.read['foo'].should == 'bar'
      end

      it "should set the version count" do
        reader.read
        reader.version_count.should == version_count
      end

    end
  end
end
