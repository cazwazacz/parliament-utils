module Parliament
  module Utils
    module Services
      class ParliamentMarkdownScrubber < Rails::Html::PermitScrubber
        # Overrides default sanitization allowing Parliament tags and/or attributes
        def initialize
          super

          self.tags = %w[p div h1 h2 h3 h4 h5 h6 span a ol li ul strong em i itag strike del u sup sub blockquote cite table thead tbody tfoot tr th td iframe image pre code dl dt dd hr br]
          self.attributes = %w[class href src name title allowfullscreen seamless frameborder style]
        end

        def skip_node?(node)
          node.text? || node.name === 'iframe'
        end
      end
    end
  end
end
