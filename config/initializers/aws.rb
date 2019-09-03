if Rails.configuration.active_storage.service == :amazon
  Aws.config.update({
    region: 'us-east-2',
    credentials: Aws::Credentials.new(ENV.fetch('AWS_ACCESS_KEY_ID'), ENV.fetch('AWS_SECRET_KEY')),
  })

  S3_BUCKET = Aws::S3::Resource.new.bucket(ENV.fetch('S3_BUCKET_NAME'))
end
