# frozen_string_literal: true

require 'dry/struct'
require 'sample_data_dump/types'
require 'sample_data_dump/entities/settings'

module SampleDataDumpAwsS3CompressedDumpStorage
  class Settings < SampleDataDump::Entities::Settings
    attribute :aws_s3_access_key_id, SampleDataDump::Types::Strict::String.optional
    attribute :aws_s3_bucket_name, SampleDataDump::Types::Strict::String
    attribute :aws_s3_region, SampleDataDump::Types::Strict::String
    attribute :aws_s3_secret_access_key, SampleDataDump::Types::Strict::String.optional
  end
end
