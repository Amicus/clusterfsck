require 'spec_helper'

module ClusterFuck

  describe CredentialGrabber do
    let(:credential_grabber) { CredentialGrabber.new }

    before do
      credential_grabber.stub(:exists?).and_return(false)
    end

    it "should have a singleton find" do
      fake_credential_grabber = mock(:credential_grabber)
      fake_credential_grabber.should_receive(:find).and_return nil
      CredentialGrabber.should_receive(:new).and_return(fake_credential_grabber)
      CredentialGrabber.find
    end

    let(:cf_credentials) do
      {
          access_key_id: 'cf_access_key',
          secret_access_key: 'cf_secret_key'
      }
    end

    let(:fog_credentials) do
      {
        default: {
          aws_access_key_id: 'fog_access_key',
          aws_secret_access_key: 'fog_secret_key'
        }
      }
    end

    describe "when there is a ~/.fog file but no ~/.cluster-fuck" do
      before do
        File.stub(:expand_path).with(CredentialGrabber::FOG_PATH).and_return(CredentialGrabber::FOG_PATH)
        credential_grabber.should_receive(:exists?).with(CredentialGrabber::FOG_PATH).and_return(true)
        YAML.should_receive(:load_file).with(CredentialGrabber::FOG_PATH).and_return(fog_credentials)
      end

      it "should return the credentials" do
        credential_grabber.find.should == {
            access_key_id: 'fog_access_key',
            secret_access_key: 'fog_secret_key',
        }
      end
    end

    describe "when there is a ~/.cluster-fuck file and no ~/.fog file" do
      before do
        credential_grabber.should_receive(:exists?).with(CredentialGrabber::CF_PATH).and_return(true)
        YAML.should_receive(:load_file).with(CredentialGrabber::CF_PATH).and_return(cf_credentials)
      end

      it "should return the credentials" do
        credential_grabber.find.should == cf_credentials
      end
    end

    describe "when there is both a ~/.cluster-fuck and a ~/.fog file" do
      before do
        credential_grabber.should_receive(:exists?).and_return(true)
        YAML.should_receive(:load_file).with(CredentialGrabber::CF_PATH).and_return(cf_credentials)
      end

      it "should return the cluster-fuck credentials" do
        credential_grabber.find.should == cf_credentials
      end
    end

    describe "when there are no credential files" do

      it "should return nil" do
        credential_grabber.find.should be_nil
      end

    end

  end
end
