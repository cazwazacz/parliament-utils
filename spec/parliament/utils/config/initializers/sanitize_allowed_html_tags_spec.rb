require 'spec_helper'
require 'action_controller/railtie'

RSpec.describe 'SanitizeHelper' do

  context 'allowed HTML tags' do

    let(:allowed_html_tags) { ActionView::Base.sanitized_allowed_tags }

    it 'will be an array' do
      expect(allowed_html_tags).to be_instance_of(Array)
    end

    it 'will be 48 HTML tags' do
      expect(allowed_html_tags.count).to eq(48)
    end

    it 'will allow table related tags' do
      expect(allowed_html_tags).to include(
        'table', 'tbody', 'td', 'tfoot', 'th', 'thead', 'tr'
      )
    end

  end

  context 'sanitized HTML content' do

    let(:sanitized_content) { ActionController::Base.helpers.sanitize('<foo><h2>Answer</h2></foo><p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Soluta voluptas <bar>fuga</bar> provident <baz>doloremque</baz>, ducimus </foo>sunt <foo>nulla alias quo? Sunt laborum ad, sequi esse obcaecati voluptatum consequuntur nulla error culpa aspernatur.</p><table><thead><tr><th>Col 1</th><th>Col 2</th></tr></thead><tbody><tr><td>Col 1</td><td>Col 2</td></tr></tbody><tfoot><tr><td colspan="2">Table footer</td></tr></tfoot></table><script>alert("Malicious code");</script>') }

    it 'will not have the script tag' do
      expect(sanitized_content).to_not include(
        '<script>', '</script>'
      )
    end

    it 'will not have the tags foo, bar and baz' do
      expect(sanitized_content).to_not include(
        '<foo>', '</foo>', '<bar>', '</bar>', '<baz>', '</baz>'
      )
    end

    it 'will contain table related tags' do
      expect(sanitized_content).to include(
        '<table>', '</table>', '<tbody>', '</tbody>', '<td>', '</td>',
        '<tfoot>', '</tfoot>', '<th>', '</th>', '<thead>', '</thead>',
        '<tr>', '</tr>'
      )
    end


  end

end
