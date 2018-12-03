# frozen_string_literal: true

require 'aws-sdk-s3'
require 'dry/monads/all'
require 'duckface'
require 'sample_data_dump/entities/table_configuration'
require 'sample_data_dump/helpers/dump_file'
require 'sample_data_dump/interfaces/compressed_dump_storage_gateway'
require 'sample_data_dump_aws_s3_compressed_dump_storage/settings'

module SampleDataDumpAwsS3CompressedDumpStorage
  class Gateway
    implements_interface SampleDataDump::Interfaces::CompressedDumpStorageGateway

    def initialize(settings)
      @settings = settings
    end

    def store_compressed_dump_file(table_configuration)
      dump_file = SampleDataDump::Helpers::DumpFile.new(table_configuration, @settings)
      s3_file = s3_dump_file(dump_file.local_compressed_dump_file_name)
      s3_file.upload_file(dump_file.local_compressed_dump_file_path)
      Dry::Monads::Success(true)
    end

    def retrieve_compressed_dump_file(table_configuration)
      dump_file = SampleDataDump::Helpers::DumpFile.new(table_configuration, @settings)
      s3_file = s3_dump_file(dump_file.local_compressed_dump_file_name)
      path = s3_file.download_file(dump_file.local_compressed_dump_file_path)
      Dry::Monads::Success(path)
    end

    private

    def s3_dump_file(local_compressed_dump_file_name)
      client = Aws::S3::Client.new(aws_s3_client_options)
      resource = Aws::S3::Resource.new(client: client)
      bucket = resource.bucket(@settings.aws_s3_bucket_name)
      bucket.object(local_compressed_dump_file_name)
    end

    def aws_s3_client_options
      {
        access_key_id: @settings.aws_s3_access_key_id,
        region: @settings.aws_s3_region,
        secret_access_key: @settings.aws_s3_secret_access_key
      }
    end
  end
end
