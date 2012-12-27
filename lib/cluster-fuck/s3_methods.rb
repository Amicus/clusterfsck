module ClusterFuck
  module S3Methods
    def s3_object(object_name)
      qualified_name = full_path(object_name)
      return bucket.objects[qualified_name]
    end

    def bucket
      @bucket ||= s3.buckets[CONFIG_BUCKET]
    end

    def credentials
      @credentials ||= CredentialGrabber.find
    end

    def s3
      AWS::S3.new(credentials) #could be nil, especially if on EC2
    end

protected

    def full_path(key)
      "#{AMICUS_ENV}/#{key}"
    end
  end
end
