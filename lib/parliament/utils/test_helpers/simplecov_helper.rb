module Parliament
  module Utils
    module TestHelpers
      module SimpleCovHelper
        require 'coveralls'
        require 'simplecov'

        def self.load_rspec_config(_config)
          SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                           Coveralls::SimpleCov::Formatter,
                                                                           SimpleCov::Formatter::HTMLFormatter
                                                                         ])

          profile = defined?(Rails) ? 'rails' : nil

          SimpleCov.start profile do
            add_filter 'spec'
          end
        end
      end
    end
  end
end
