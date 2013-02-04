require 'spec_helper'

module ClusterFuck

  describe Reader do
    let(:amicus_env) { 'test' }
    let(:reader) { Reader.new }
    let(:mock_s3_obj) { mock(:s3_object, read: nil) }


    it "should set amicus_env" do
      reader.amicus_env.should == amicus_env
    end

    describe "#[]" do
      before do
        mock_s3_obj.stub(:read).and_return(YAML.dump({
            foo: 'bar'
        }))
        reader.stub(:s3_object).with("test").and_return(mock_s3_obj)
        reader.stub(:s3_object).with(:test).and_return(mock_s3_obj)
      end

      it "should load the remote file and yaml parse it" do
        reader["test"]['foo'].should == 'bar'
      end

    end
  end
end
