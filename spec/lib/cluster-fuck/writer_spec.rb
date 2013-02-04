require 'spec_helper'

module ClusterFuck

  describe Writer do
    let(:amicus_env) { 'development' }
    let(:key) { 'tester' }
    let(:reader) { Reader.new(key) }
    let(:mock_s3_obj) { mock(:s3_object, read: nil) }
    let(:writer) { Writer.new(key) }
    let(:initial_version_count) { 3 }

    before do
      mock_s3_obj.stub(
          read: YAML.dump({
            foo: 'bar',
            deep: {
              works: 'too',
              even: 'here'
            }
          }),
          versions: mock('versions', count: initial_version_count)
      )
      Reader.any_instance.stub(:s3_object).with("#{key}").and_return(mock_s3_obj)
      writer.stub(:s3_object).and_return(mock_s3_obj)
    end

    describe "#set" do
      it "should write the configuration to the file" do
        writer.should_receive(:s3_object).with(key).and_return(mock_s3_obj)

        mock_s3_obj.should_receive(:write).with(YAML.dump({
                  'deep' => {
                    'even' => 'changed'
                  }
        }))

        do_write
      end

      describe "with version counts" do

        it "should work normally when nothing has changed underneath" do
          mock_write
          mock_s3_obj.versions.stub(:count).and_return(initial_version_count, (initial_version_count + 1))

          do_write
        end

        it "should raise an error and not write when it has changed before the set" do
          mock_s3_obj.should_not_receive(:write)
          mock_s3_obj.versions.stub(:count).and_return(initial_version_count + 1)

          ->() { do_write }.should raise_error(ClusterFuck::S3Methods::ConflictError)
        end

        it "should raise an error if the version count has hopped AFTER our write" do
          mock_write
          mock_s3_obj.versions.stub(:count).and_return(initial_version_count, (initial_version_count + 2))

          ->() { do_write }.should raise_error(ClusterFuck::S3Methods::ConflictError)
        end

        def mock_write
          mock_s3_obj.should_receive(:write).with(YAML.dump({
                    'deep' => {
                      'even' => 'changed'
                    }
          }))
        end
      end

      def do_write
        writer.set(Configuration.new({
                    deep: {
                        even: 'changed'
                    }
        }), initial_version_count)
      end

    end
  end
end
