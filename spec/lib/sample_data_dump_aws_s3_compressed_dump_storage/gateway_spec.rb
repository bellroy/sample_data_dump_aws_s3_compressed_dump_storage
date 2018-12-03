# frozen_string_literal: true

require 'sample_data_dump_aws_s3_compressed_dump_storage/gateway'

module SampleDataDumpAwsS3CompressedDumpStorage
  describe Gateway do
    let(:gateway) do
      described_class.new(settings)
    end

    let(:logger) { Logger.new(STDOUT) }
    let(:settings) do
      Settings.new(
        aws_s3_access_key_id: 'ACCESS_KEY_ID',
        aws_s3_bucket_name: 'my-bucket',
        aws_s3_region: 'us-east',
        aws_s3_secret_access_key: 'SECRET_ACCESS_KEY',
        compacted_dump_directory: 'compacted_data_dump_test',
        config_file_path: File.dirname(__FILE__) + '/../../support/fixtures/sample_data_dump.yml'
      )
    end

    let(:table_configuration) do
      SampleDataDump::Entities::TableConfiguration.new(
        schema_name: schema_name,
        table_name: table_name,
        dump_where: dump_where,
        obfuscate_columns: obfuscate_columns
      )
    end
    let(:schema_name) { 'my_schema_name' }
    let(:table_name) { 'my_table_name' }
    let(:dump_where) { 'column_name = 123' }
    let(:obfuscate_columns) { %w[contact_given_name] }

    after(:all) { FileUtils.rm_rf('compacted_data_dump_test') }

    describe '#store_compressed_dump_file' do
      subject(:store_compressed_dump_file) do
        gateway.store_compressed_dump_file(table_configuration)
      end

      let(:aws_client) { instance_double(Aws::S3::Client) }
      let(:aws_resource) { instance_double(Aws::S3::Resource) }
      let(:aws_bucket) { instance_double(Aws::S3::Bucket) }
      let(:aws_object) { instance_double(Aws::S3::Object) }

      before do
        expect(Aws::S3::Client).to receive(:new).with(an_instance_of(Hash)).and_return(aws_client)
        expect(Aws::S3::Resource).to receive(:new).with(client: aws_client).and_return(aws_resource)
        expect(aws_resource).to receive(:bucket).with(an_instance_of(String)).and_return(aws_bucket)
        expect(aws_bucket).to receive(:object).with(an_instance_of(String)).and_return(aws_object)
        expect(aws_object).to receive(:upload_file)
      end

      it { is_expected.to be_success }
    end

    describe '#retrieve_compressed_dump_file' do
      subject(:retrieve_compressed_dump_file) do
        gateway.retrieve_compressed_dump_file(table_configuration)
      end

      let(:aws_client) { instance_double(Aws::S3::Client) }
      let(:aws_resource) { instance_double(Aws::S3::Resource) }
      let(:aws_bucket) { instance_double(Aws::S3::Bucket) }
      let(:aws_object) { instance_double(Aws::S3::Object) }

      before do
        expect(Aws::S3::Client).to receive(:new).with(an_instance_of(Hash)).and_return(aws_client)
        expect(Aws::S3::Resource).to receive(:new).with(client: aws_client).and_return(aws_resource)
        expect(aws_resource).to receive(:bucket).with(an_instance_of(String)).and_return(aws_bucket)
        expect(aws_bucket).to receive(:object).with(an_instance_of(String)).and_return(aws_object)
        expect(aws_object).to receive(:download_file).with(an_instance_of(String))
      end

      it { is_expected.to be_success }
    end
  end
end
