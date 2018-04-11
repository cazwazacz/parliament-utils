require 'spec_helper'

RSpec.describe Parliament::Utils::Helpers::VCardHelper, vcr: true do

  it 'is a module' do
    expect(subject).to be_a(Module)
  end

end
