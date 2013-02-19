require 'spec_helper'

module ClusterFsck

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

    let(:env_credentials) do
      {
          access_key_id: 'env_access_key',
          secret_access_key: 'env_secret_key'
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

    describe "when there is a ~/.fog file but no ~/.cluster-fsck" do
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

    describe "when there is a ~/.cluster-fsck file and no ~/.fog file" do
      before do
        credential_grabber.should_receive(:exists?).with(CredentialGrabber::CF_PATH).and_return(true)
        YAML.should_receive(:load_file).with(CredentialGrabber::CF_PATH).and_return(cf_credentials)
      end

      it "should return the credentials" do
        credential_grabber.find.should == cf_credentials
      end
    end

    describe "when there is both a ~/.cluster-fsck and a ~/.fog file" do
      before do
        credential_grabber.should_receive(:exists?).and_return(true)
        YAML.should_receive(:load_file).with(CredentialGrabber::CF_PATH).and_return(cf_credentials)
      end

      it "should return the cluster-fsck credentials" do
        credential_grabber.find.should == cf_credentials
      end
    end

    describe "when there is both ENV vars and a ~/.fog file" do
      before :each do
        ENV.stub(:[]).with("AWS_ACCESS_KEY_ID").and_return('env_access_key')
        ENV.stub(:[]).with("AWS_SECRET_ACCESS_KEY").and_return('env_secret_key')
        File.stub(:expand_path).with(CredentialGrabber::FOG_PATH).and_return(CredentialGrabber::FOG_PATH)
      end

      it "should return the cluster-fsck credentials" do
        credential_grabber.find.should == env_credentials
      end

      it "should not look at expand_path because it short circuits first" do
        credential_grabber.find
        YAML.should_not_receive(:load_file)
      end
    end

    describe "when there are no credential files" do

      it "should return nil" do
        credential_grabber.find.should be_nil
      end

    end

  end
end
