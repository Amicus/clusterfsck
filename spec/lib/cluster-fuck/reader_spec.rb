require 'spec_helper'

module ClusterFuck

  describe Reader do
    let(:amicus_env) { 'test' }
    let(:key) { "test-key" }
    let(:reader) { Reader.new(key) }
    let(:mock_s3_obj) { mock(:s3_object, read: nil) }


    it "should set amicus_env" do
      reader.amicus_env.should == amicus_env
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
