require 'spec_helper'

RSpec.describe Parliament::Utils::Helpers::VCardHelper, vcr: true do
  let(:dummy_class)  { Class.new { include Parliament::Utils::Helpers::VCardHelper }}
  let(:instance)     { dummy_class.new }
  let(:contact_point){ Parliament::Utils::Helpers::FilterHelper.filter(Parliament::Utils::Helpers::ParliamentHelper.parliament_request.contact_point_by_id.set_url_params({ contact_point_id: 'YqYGU3nA' }), 'ContactPoint').first }

  context '#create_vcard' do
    it 'will create a vcard' do
      expect(instance.create_vcard(contact_point).class).to eq(Vcard::Vcard)
    end

    context 'created vcard' do
      let(:generated_vcard){ instance.create_vcard(contact_point) }

      context 'fields' do
        let(:generated_vcard_fields){ generated_vcard.fields }

        it 'will have the correct formatting' do
          expect(generated_vcard_fields[0].instance_variable_get(:@line)).to eq('BEGIN:VCARD')
          expect(generated_vcard_fields[8].instance_variable_get(:@line)).to eq('END:VCARD')
          expect(generated_vcard_fields[1].instance_variable_get(:@line)).to include('VERSION')
        end

        it 'will have the correct address' do
         expect(generated_vcard.address.street.to_s).to eq('addressLine1 - 1, addressLine2 - 1, postCode - 1')
        end

        it 'will have the correct email' do
          expect(generated_vcard.email.to_s).to eq('email - 1')
        end

        it 'will have the correct phone number' do
          expect(generated_vcard.telephone.to_s).to eq('phoneNumber - 1')
        end

        it 'will have the correct faxnumber' do
          expect(generated_vcard.telephones[1].to_s).to eq('faxNumber - 1')
        end
      end
    end
  end

  context 'private methods' do
    let(:vcard_maker){ Vcard::Vcard::Maker.make2 { |maker| maker.add_name { instance.send(tested_method_name, contact_point_with_altered_attribute, maker) }}}

    let(:contact_point_with_altered_attribute) do
      contact_point.instance_variable_set(instance_variable, value)
      contact_point
    end

    context '#contacts_set' do
      let(:tested_method_name){ :contacts_set }
      let(:instance_variable) { :@email }

      context 'add email' do
        context 'blank email' do
          let(:value){ '' }

          it 'will not add an email' do
            expect(vcard_maker.email.to_s).to eq(value)
          end
        end

        context 'valid email' do
          let(:value){ 'test@email.com' }

          it 'will add correct email' do
            expect(vcard_maker.email.to_s).to eq(value)
          end
        end
      end

      context 'add phone number' do
        let(:instance_variable){ :@phoneNumber }

        context 'blank number' do
          let(:value){ '' }

          it 'will not add a phone number' do
            # Vcard returns the fax number if there is no phone number
            expect(vcard_maker.telephones.count).to eq(1)
            expect(vcard_maker.telephone.to_s).to eq('faxNumber - 1')
          end
        end

        context 'valid phone number' do
          let(:value){ '0123456789' }

          it 'will add a correct phone number' do
            expect(vcard_maker.telephone.to_s).to eq(value)
          end
        end
      end

      context 'add fax' do
        let(:instance_variable){ :@faxNumber }

        context 'blank fax' do
          let(:value){ '' }

          it 'will not add a fax number' do
            # Vcard returns the phone number if there is no fax number
            expect(vcard_maker.telephones.count).to eq(1)
            expect(vcard_maker.telephone.to_s).to eq('phoneNumber - 1')
          end
        end

        context 'valid fax' do
          let(:value){ 'test_fax_number' }

          it 'will add a correct fax number' do
            expect(vcard_maker.telephones[1].to_s).to eq(value)
          end
        end
      end
    end

    context '#postal_address_set' do
      let(:tested_method_name){ :postal_address_set }
      let(:instance_variable) { :@contactPointHasPostalAddress }

      context 'no postal addresses' do
        let(:value){ [] }

        it 'will return false' do
          expect(vcard_maker.addresses).to eq(value)
        end
      end

      context 'valid postal address' do
        let(:value){ [double(full_address: 'Test Address')] }

        it 'will return the correct address' do
          expect(vcard_maker.addresses.first.street).to eq('Test Address')
        end
      end
    end

    context '#person_set' do
      let(:vcard_maker) do
        Vcard::Vcard::Maker.make2 do |maker|
          maker.add_name { |name| instance.send(:person_set, contact_point_with_altered_attribute, name) }
        end
      end

      let(:instance_variable) { :@contactPointHasParliamentaryIncumbency }

      context 'no name' do
        let(:value){ nil }

        it 'will return a blank name' do
          expect(vcard_maker.name.fullname).to eq('')
        end
      end

      context 'valid name' do
        let(:value){ [double(:member, member: double(:member, given_name: 'Test Given Name', family_name: 'Test Family Name'))] }

        it 'will return the correct name' do
          expect(vcard_maker.name.fullname).to eq('Test Given Name Test Family Name')
        end
      end
    end
  end
end
