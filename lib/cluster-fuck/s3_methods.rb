module ClusterFuck
  module S3Methods
    def s3_object(object_name)
      bucket.objects[object_name]
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

    def full_path(key)
      "#{amicus_env}/#{key}"
    end

  end
end
