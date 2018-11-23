require 'spec_helper'

RSpec.describe RDStation::Error::Formatter do
  describe '#to_array' do
    before do
      allow(RDStation::Error::Format).to receive(:new).and_return(error_format)
    end

    context 'when receives a flat hash of errors' do
      let(:error_format) { instance_double(RDStation::Error::Format, format: RDStation::Error::Format::FLAT_HASH) }

      let(:errors) do
        {
          'error_type' => 'CONFLICTING_FIELD',
          'error_message' => 'The payload contains an attribute that was used to identify the lead'
        }
      end

      let(:error_formatter) { described_class.new(errors) }

      let(:expected_result) do
        [
          {
            'error_type' => 'CONFLICTING_FIELD',
            'error_message' => 'The payload contains an attribute that was used to identify the lead'
          }
        ]
      end

      it 'returns an array of errors including the status code and headers' do
        result = error_formatter.to_array
        expect(result).to eq(expected_result)
      end
    end

    context 'when receives a hash of arrays of errors' do
      let(:error_format) { instance_double(RDStation::Error::Format, format: RDStation::Error::Format::HASH_OF_ARRAYS) }

      let(:errors) do
        {
          'name' => [
            {
              'error_type' => 'MUST_BE_STRING',
              'error_message' => 'Name must be string.'
            }
          ]
        }
      end

      let(:error_formatter) { described_class.new(errors) }

      let(:expected_result) do
        [
          {
            'error_type' => 'MUST_BE_STRING',
            'error_message' => 'Name must be string.',
            'path' => 'body.name'
          }
        ]
      end

      it 'returns an array of errors including the status code and headers' do
        result = error_formatter.to_array
        expect(result).to eq(expected_result)
      end
    end

    context 'when receives an array of errors' do
      let(:error_format) { instance_double(RDStation::Error::Format, format: RDStation::Error::Format::ARRAY_OF_HASHES) }

      let(:errors) do
        [
          {
            'error_type' => 'CANNOT_BE_NULL',
            'error_message' => 'Cannot be null.',
            'path' => 'body.client_secret'
          }
        ]
      end

      let(:error_formatter) { described_class.new(errors) }

      let(:expected_result) do
        [
          {
            'error_type' => 'CANNOT_BE_NULL',
            'error_message' => 'Cannot be null.',
            'path' => 'body.client_secret'
          }
        ]
      end

      it 'returns an array of errors including the status code and headers' do
        result = error_formatter.to_array
        expect(result).to eq(expected_result)
      end
    end
  end
end
