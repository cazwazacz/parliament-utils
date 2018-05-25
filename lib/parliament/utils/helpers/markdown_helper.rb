require_relative '../services/markdown_converter'
require_relative '../services/markdown_scrubber'
require 'redcarpet'

module Parliament
  module Utils
    module Helpers
      module MarkdownHelper
        # Uses redcarpet gem to convert markdown into HTML, with chosen HTML extensions
        # Uses custom Parliament::Utils::Services::ParliamentMarkdownRenderer to override default autolink behaviour of redcarpet gem
        # Uses custom Parliament::Utils::Services::ParliamentMarkdownScrubber to allow additional HTML tags and attributes
        #
        # @return template [String] Template as HTML
        def self.markdown(template)
          parliament_renderer = Parliament::Utils::Services::ParliamentMarkdownRenderer
          parliament_scrubber = Parliament::Utils::Services::ParliamentMarkdownScrubber.new

          markdown = Redcarpet::Markdown.new(parliament_renderer, tables: true, autolink: true)
          html = markdown.render(ActionController::Base.helpers.sanitize(template, scrubber: parliament_scrubber))
          ActionController::Base.helpers.sanitize(html, scrubber: parliament_scrubber).html_safe
        end
      end
    end
  end
end
