# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.5.3'

DECIDIM_VERSION = { git: 'https://github.com/decidim/decidim.git', branch: '0.18-stable' }

gem 'decidim', DECIDIM_VERSION

# A Decidim module to customize the localized terms in the system.
# Read more: https://github.com/CodiTramuntana/decidim-module-term_customizer
gem "decidim-term_customizer"

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

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :production do
  gem 'dalli'
  gem 'fog-aws'
  gem 'lograge'
  gem 'newrelic_rpm'
  gem 'sendgrid-ruby'
  gem 'sentry-raven'
  gem 'sidekiq'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-rails'
end
