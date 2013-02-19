require 'spec_helper'

module ClusterFsck
  describe Configuration do

    it "should be a mash" do
      Configuration.new.should be_a(Hashie::Mash)
    end

    it "should load from yaml" do
      yaml = YAML.dump({foo: 'bar'})
      Configuration.from_yaml(yaml)[:foo].should == 'bar'
    end

    # TODO (topper): this isn't explicitly testing the right thing
    # but it does *actually* test the right thing
    it "should dump to yaml" do
      hsh = {'foo' => 'bar'}
      Configuration.new(hsh).to_yaml.should == YAML.dump(hsh)
    end

  end


end
