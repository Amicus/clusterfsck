require 'spec_helper'

module ClusterFuck

  describe CredentialGrabber do
    let(:credential_grabber) { CredentialGrabber.new }

    describe "when there is a ~/.fog file" do
      let(:fog_credentials) do
        {
          default: {
            aws_access_key_id: 'access_key',
            aws_secret_access_key: 'secret_key'
          }
        }
      end

      before do
        credential_grabber.should_receive(:exists?).with(CredentialGrabber::FOG_PATH).and_return(true)
        YAML.should_receive(:load_file).with(CredentialGrabber::FOG_PATH).and_return(fog_credentials)
      end

      it "should return the credentials" do
        credential_grabber.find.should == {
            access_key_id: 'access_key',
            secret_access_key: 'secret_key',
        }
      end

    end

    describe "when there is a ~/.cluster-fuck file" do
      let(:cf_credentials) do
        {
            access_key_id: 'access_key',
            secret_access_key: 'secret_key'
        }
      end

      before do
        credential_grabber.should_receive(:exists?).with(CredentialGrabber::FOG_PATH).and_return(false)
        credential_grabber.should_receive(:exists?).with(CredentialGrabber::CF_PATH).and_return(true)
        YAML.should_receive(:load_file).with(CredentialGrabber::CF_PATH).and_return(cf_credentials)
      end

      it "should return the credentials" do
        credential_grabber.find.should == cf_credentials
      end
    end
  end
end
