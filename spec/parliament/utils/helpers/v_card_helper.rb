require 'spec_helper'

RSpec.describe Parliament::Utils::Helpers::VCardHelper, vcr: true do

  context '#create_vcard' do

    let (:dummy_class) { Class.new { include Parliament::Utils::Helpers::VCardHelper } }

    it 'creates a vcard' do
      binding.irb
    end
  end


end
