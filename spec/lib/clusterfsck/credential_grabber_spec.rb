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

    describe "when there is a ~/.fog file but no ~/.clusterfsck" do
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

    describe "when there is a ~/.clusterfsck config and with or without a ~/.fog file" do
      before do
        credential_grabber.stub(:exists?).with(true)
        ClusterFsck::CLUSTER_FSCK_CONFIG.should_receive(:[]).at_least(:once)
          .with('aws_access_key_id').and_return(cf_credentials[:access_key_id])
        ClusterFsck::CLUSTER_FSCK_CONFIG.should_receive(:[]).at_least(:once)
          .with('aws_secret_access_key').and_return(cf_credentials[:secret_access_key])
      end

      it "should return the clusterfsck credentials" do
        credential_grabber.find.should == cf_credentials
      end
      it "should return the credentials" do
        credential_grabber.find.should == cf_credentials
      end
    end

    describe "when there is both ENV vars and a ~/.fog file" do
      before :each do
        ENV.stub(:[]).with("AWS_ACCESS_KEY_ID").and_return(env_credentials[:access_key_id])
        ENV.stub(:[]).with("AWS_SECRET_ACCESS_KEY").and_return(env_credentials[:secret_access_key])
        File.stub(:expand_path).with(CredentialGrabber::FOG_PATH).and_return(CredentialGrabber::FOG_PATH)
      end

      it "should return the clusterfsck credentials" do
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
