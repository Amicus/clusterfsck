module ClusterFuck

  describe Writer do
    let(:amicus_env) { 'development' }
    let(:reader) { Reader.new }
    let(:mock_s3_obj) { mock(:s3_object, read: nil) }
    let(:writer) { Writer.new }
    let(:key) { 'tester' }

    before do
      mock_s3_obj.stub(:read).and_return(YAML.dump({
          foo: 'bar',
          deep: {
            works: 'too',
            even: 'here'
          }
      }))
      Reader.any_instance.stub(:s3_object).with("#{amicus_env}/#{key}").and_return(mock_s3_obj)
    end

    describe "#set" do
      it "should write back a merged configuration" do
        writer.should_receive(:s3_object).with(writer.full_path(key)).and_return(mock_s3_obj)

        mock_s3_obj.should_receive(:write).with(YAML.dump({
                  'foo' => 'bar',
                  'deep' => {
                    'works' => 'too',
                    'even' => 'changed'
                  }
        }))

        writer.set(key, {
            deep: {
                even: 'changed'
            }
        })
      end
    end
  end

end
