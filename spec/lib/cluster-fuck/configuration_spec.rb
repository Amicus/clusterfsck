require 'spec_helper'

module ClusterFuck
  describe Configuration do

    it "should be a mash" do
      Configuration.new.should be_a(Hashie::Mash)
    end

  end


end
