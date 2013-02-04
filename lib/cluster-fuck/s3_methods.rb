module ClusterFuck
  module S3Methods

    class ConflictError < StandardError; end

    def s3_object(object_name)
      bucket.objects[full_s3_path(object_name)]
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

    def all_files
      bucket.objects.with_prefix(amicus_env).collect(&:key)
    end

    def full_s3_path(key)
      "#{amicus_env}/#{key}"
    end

  protected


    def amicus_env
      AMICUS_ENV
    end

  end
end
