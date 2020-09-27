require 'rails_helper'

describe Import::Csv, type: :csv do
  subject { Import::Csv.new(file_path: generated_csv.path) }

  after(:each) { File.delete(path) if File.exist?(path) }

  describe 'for buildings' do
    let(:path) { 'spec/import/buildings.csv' }

    let(:generated_csv) do
      CSV.open(path, 'wb') do |csv|
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
      context 'when there is no previous record' do
        before { subject.import }

        it 'populates table with imported records' do
          subject.save

          expect(Building.count).to eq(2)
          expect(Building.first.zip_code).to eq('75009')
        end
      end

      context 'when building already has a profile and we ask to update authorized fields' do
        before { subject.import }

        before do
          create_building_profile(reference: '1', manager_name: 'Martin Faure', zip_code: '75020')
        end

        it 'updates record with new data' do
          expect(Building.find_by(reference: '1').zip_code).to eq('75020')
          subject.save
          expect(Building.find_by(reference: '1').reload.zip_code).to eq('75009')
        end
      end

      context 'when building already has a profile and we ask to update a protected field' do
        before { subject.import }

        before do
          create_building_profile(reference: '1', manager_name: 'Martin Faure', zip_code: '75020')
          create_building_profile(reference: '1', manager_name: 'Pepito Rodriguez', zip_code: '75011')
        end

        let(:building_one) { Building.find_by(reference: '1') }

        it 'does not update protected field but updates other fields' do
          expect(building_one.manager_name).to eq('Pepito Rodriguez')
          expect(building_one.zip_code).to eq('75011')

          subject.save

          expect(building_one.reload.manager_name).to eq('Pepito Rodriguez')
          expect(building_one.reload.zip_code).to eq('75009')
        end
      end
    end
  end

  describe 'for people' do
    let(:path) { 'spec/import/people.csv' }

    let(:generated_csv) do
      CSV.open(path, 'wb') do |csv|
        csv << %w[reference firstname lastname home_phone_number mobile_phone_number email address]
        csv << ['1', 'Henri', 'Dupont', '0123456789', '0623456789', 'h.dupont@gmail.com', '10 Rue La bruyère']
        csv << ['2', 'Jean', 'Durand', '0123336789', '0663456789', 'jdurand@gmail.com', '40 Rue René Clair']
      end
    end

    describe '#save' do
      let(:person_one) { Person.find_by(reference: '1') }

      context 'when there is no previous record' do
        before { subject.import }

        it 'populates table with imported records' do
          subject.save

          expect(Person.count).to eq(2)
          expect(Person.first.email).to eq('h.dupont@gmail.com')
        end
      end

      context 'when person already has a profile and the csv contains new data' do
        before { subject.import }

        before do
          create_person_profile(reference: '1', email: 'h.dupont@gmail.com', lastname: 'Snow', home_phone_number: nil)
        end

        it 'updates record with new data' do
          expect(person_one.lastname).to eq('Snow')
          subject.save
          expect(person_one.reload.lastname).to eq('Dupont')
        end
      end

      context 'when person already has a profile and we ask to update a protected field' do
        before { subject.import }

        before do
          create_person_profile(reference: '1', email: 'h.dupont@gmail.com', lastname: 'Snow', home_phone_number: nil)
          create_person_profile(reference: '1', email: 'buzz@leclair.com', lastname: 'Gigantic', home_phone_number: '0123456789')
          create_person_profile(reference: '1', email: 'mickey@mouse.com', lastname: 'Mice', home_phone_number: '0875446799')
        end

        it 'updates record with new data' do
          expect(person_one.lastname).to eq('Mice')
          expect(person_one.email).to eq('mickey@mouse.com')
          expect(person_one.home_phone_number).to eq('0875446799')

          subject.save

          expect(person_one.reload.lastname).to eq('Dupont')
          expect(person_one.reload.email).not_to eq('h.dupont@gmail.com')
          expect(person_one.reload.home_phone_number).not_to eq('0123456789')
        end
      end
    end
  end

  def create_building_profile(reference:, manager_name:, zip_code:)
    with_building = Building.last ? :with_existing_building : nil
    building_profile = create(:building_profile, with_building, manager_name: manager_name, zip_code: zip_code)
    building = building_profile.building
    building.update(reference: reference, current_profile_id: building_profile.id)
  end

  def create_person_profile(reference:, email:, lastname:, home_phone_number:)
    with_person = Person.last ? :with_existing_person : nil
    with_phone_number = home_phone_number ? { home_phone_number: home_phone_number } : {}
    person_profile = create(:person_profile, with_person, { email: email, lastname: lastname }.merge(with_phone_number))
    person = person_profile.person
    person.update(reference: reference, current_profile_id: person_profile.id)
  end
end
