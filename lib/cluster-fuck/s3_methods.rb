module ClusterFuck
  module S3Methods
    def s3_object(object_name)
      qualified_name = full_path(object_name)
      bucket.objects[qualified_name]
    end

    def bucket
      @bucket ||= s3.buckets[CONFIG_BUCKET]
    end

    def credentials
      @credentials ||= CredentialGrabber.find
    end

    def s3
      if credentials
        AWS::S3.new(credentials) #could be nil, especially if on EC2
      else
        AWS::S3.new
      end
    end

  protected

    def full_path(key)
      "#{AMICUS_ENV}/#{key}"
    end
  end
end
