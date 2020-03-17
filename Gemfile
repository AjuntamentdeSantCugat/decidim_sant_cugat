# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.6.5'

DECIDIM_VERSION = { git: 'https://github.com/decidim/decidim.git', branch: 'release/0.21.0' }

gem 'decidim', DECIDIM_VERSION
gem 'sprockets', '~> 3.7', '< 4'

# A Decidim module to customize the localized terms in the system.
# Read more: https://github.com/mainio/decidim-module-term_customizer
gem "decidim-term_customizer", git: 'https://github.com/CodiTramuntana/decidim-module-term_customizer'

gem 'virtus-multiparams'

gem 'faker'
gem 'puma'
gem 'uglifier'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'decidim-dev', DECIDIM_VERSION
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
end

group :production do
  gem 'dalli'
  gem 'lograge'
  gem 'newrelic_rpm'
  gem 'sendgrid-ruby'
  gem 'sentry-raven'
  gem 'sidekiq'
  gem 'fog-aws'
  # security fix for excon gem, which is a fog-aws dependency
  gem 'excon', '>= 0.71.0'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-rails'
end
