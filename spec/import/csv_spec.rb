require 'rails_helper'

describe Import::Csv, type: :csv do
  PATH = 'spec/import/buildings.csv'.freeze

  subject { Import::Csv.new(file_path: generated_csv.path) }

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
      rows = subject.import.rows
      expect(rows).to be_kind_of(Array)
      expect(rows.first).to be_kind_of(Hash)
      expect(rows.first['zip_code']).to eq('75009')
    end
  end

  describe 'filename' do
    before { subject.import }

    it 'returns filename' do
      expect(subject.filename).to eq 'buildings'
    end
  end

  describe '#tablename' do
    before { subject.import }

    it 'imports csv data as an array of hashes' do
      expect(subject.tablename).to eq('Building')
    end
  end

  describe '#save' do
    before { subject.import }
    it 'populates table with imported records' do
      subject.save

      expect(Building.count).to eq(2)
      expect(Building.first.zip_code).to eq('75009')
    end

    context 'when record already exists with same reference' do
      before do
        Building.create!(subject.rows.find { |row| row['reference'] == '1' }.merge({ 'zip_code': '75020' }))
      end
      it 'updates record with new data' do
        expect(Building.find_by(reference: '1')['zip_code']).to eq('75020')
        subject.save
        expect(Building.find_by(reference: '1')['zip_code']).to eq('75009')
      end
    end
  end
end
