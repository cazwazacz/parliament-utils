require 'spec_helper'

RSpec.describe Parliament::Utils::Helpers::TranslationHelper do

  context 'i18n' do
    it 'sets the correct load path' do
      expect(I18n.load_path).to include('config/locales/en.yml')
    end

    it 'loads translations' do
      I18n.backend.load_translations
      expect(I18n.backend.instance_variable_get(:@translations)[:en]).to_not eq({})
      expect(I18n.backend.instance_variable_get(:@translations)[:en][:mp]).to eq('MP')
    end
  end
end
