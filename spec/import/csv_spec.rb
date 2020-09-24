require 'rails_helper'

describe Import::Csv, type: :csv do
  PATH = 'spec/import/generated.csv'.freeze

  subject { Import::Csv.new(filename: generated_csv.path) }

  after(:each) { File.delete(PATH) if File.exist?(PATH) }

  let(:generated_csv) do
    CSV.open(PATH, 'wb') do |csv|
      csv << %w[reference address zip_code city country manager_name]
      csv << ['1', '10 Rue La bruyère', '75009', 'Paris', 'France', 'Martin Faure']
      csv << ['2', '40 Rue René Clair', '75018', 'Paris', 'France', 'Martin Faure']
    end
  end

  describe '#import' do
    it 'imports csv data as an array of hashes' do
      import = subject.import
      expect(import).to be_kind_of(Array)
      expect(import.first).to be_kind_of(Hash)
      expect(import.first['zip_code']).to eq('75009')
    end
  end
end
