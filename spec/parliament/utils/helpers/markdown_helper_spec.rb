require 'spec_helper'

RSpec.describe Parliament::Utils::Helpers::MarkdownHelper do
  it 'is a module' do
    expect(subject).to be_a(Module)
  end

  context '#markdown' do
    context 'text' do
      let(:valid_markdown_text){ 'You can submit an oral question online using [e-tabling](https://etabling.parliament.uk/)' }
      let(:markdown_with_lax_newlines){ File.read('spec/fixtures/markdown/newline_issues.md') }
      let(:converted_markdown_with_lax_newlines){ File.read('spec/fixtures/markdown/converted_newline_issues') }

      it 'converts markdown to HTML' do
        expect(subject.markdown(valid_markdown_text)).to match('<p>You can submit an oral question online using <a href=\"https://etabling.parliament.uk/\">e-tabling</a></p>')
      end

      context 'markdown with newline issues' do
        it 'converts markdown to correcet HTML' do
          expect(subject.markdown(markdown_with_lax_newlines)).to match(converted_markdown_with_lax_newlines)
        end
      end
    end

    context 'video' do
      context 'parliament live tv video' do
        it 'converts link to iframe HTML' do
          video_url = 'https://parliamentlive.tv/event/index/1b5736b4-7c93-4827-a02f-abbf0bb36cc8?in=10:00:00&out=12:00:00'
          text = "You can include a video in your markdown #{video_url}"
          expected = "<p>You can include a video in your markdown <div class=\"video--wrapper\"><iframe src=\"https://videoplayback.parliamentlive.tv/Player/Index/1b5736b4-7c93-4827-a02f-abbf0bb36cc8?in=10:00:00&out=12:00:00&audioOnly=False&autoStart=False&statsEnabled=False\" name=\"UKPPlayer\" title=\"UK Parliament Player\" seamless=\"seamless\" frameborder=\"0\" allowfullscreen style=\"width: 100%; height: 100%;\"></iframe></div></p>\n"
          expect(subject.markdown(text)).to eq(expected)
        end
      end
    end
  end
end
