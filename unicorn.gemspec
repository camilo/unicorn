# -*- encoding: binary -*-
ENV["VERSION"] or abort "VERSION= must be specified"
manifest = File.readlines('.manifest').map! { |x| x.chomp! }
require 'olddoc'
extend Olddoc::Gemspec
name, summary, title = readme_metadata

# don't bother with tests that fork, not worth our time to get working
# with `gem check -t` ... (of course we care for them when testing with
# GNU make when they can run in parallel)
test_files = manifest.grep(%r{\Atest/unit/test_.*\.rb\z}).map do |f|
  File.readlines(f).grep(/\bfork\b/).empty? ? f : nil
end.compact

Gem::Specification.new do |s|
  s.name = %q{unicorn-camilo}
  s.version = "5.0.0"
  s.authors = ["#{name} hackers"]
  s.summary = summary
  s.description = readme_description
  s.email = %q{unicorn-public@bogomips.org}
  s.executables = %w(unicorn unicorn_rails)
  s.extensions = %w(ext/unicorn_http/extconf.rb)
  s.extra_rdoc_files = extra_rdoc_files(manifest)
  s.files = manifest
  s.homepage = Olddoc.config['rdoc_url']
  s.test_files = test_files

  # for people that are absolutely stuck on Rails 2.3.2 and can't
  # up/downgrade to any other version, the Rack dependency may be
  # commented out.  Nevertheless, upgrading to Rails 2.3.4 or later is
  # *strongly* recommended for security reasons.
  s.add_dependency(%q<rack>)
  s.add_dependency(%q<kgio>, '~> 2.6')
  s.add_dependency(%q<raindrops>, '~> 0.7')

  s.add_development_dependency('test-unit', '~> 3.0')
  s.add_development_dependency('olddoc', '~> 1.0')

  s.licenses = ["GPLv2+", "Ruby 1.8"]
end
