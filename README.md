# Sample Data Dump - AWS S3 Compressed Dump Storage

This gem provides:
  - An AWS S3 remote data dump storage gateway for the `sample_data_dump` gem

## Usage

See the [sample_data_dump README](https://github.com/tricycle/sample_data_dump) for more
instructions.

```
settings = SampleDataDumpAwsS3CompressedDumpStorage::Settings.new(your_settings)
SampleDataDumpAwsS3CompressedDumpStorage::Gateway.new(settings)
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sample_data_dump_aws_s3_compressed_dump_storage', git: 'git@github.com:tricycle/sample_data_dump_aws_s3_compressed_dump_storage.git'
```

And then execute:

    $ bundle install
