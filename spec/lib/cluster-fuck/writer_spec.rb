require 'spec_helper'

module ClusterFuck

  describe Writer do
    let(:amicus_env) { 'development' }
    let(:key) { 'tester' }
    let(:reader) { Reader.new(key) }
    let(:mock_s3_obj) { mock(:s3_object, read: nil) }
    let(:writer) { Writer.new(key) }

    before do
      mock_s3_obj.stub(
          read: YAML.dump({
            foo: 'bar',
            deep: {
              works: 'too',
              even: 'here'
            }
          }),
          versions: mock('versions', count: 3)
      )
      Reader.any_instance.stub(:s3_object).with("#{key}").and_return(mock_s3_obj)
    end

    describe "#set" do
      it "should write back a merged configuration" do
        writer.should_receive(:s3_object).with(key).and_return(mock_s3_obj)

        mock_s3_obj.should_receive(:write).with(YAML.dump({
                  'foo' => 'bar',
                  'deep' => {
                    'works' => 'too',
                    'even' => 'changed'
                  }
        }))

        writer.set({
            deep: {
                even: 'changed'
            }
        })
      end
    end
  end
end
