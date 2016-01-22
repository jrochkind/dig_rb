$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'dig_rb'

require 'minitest/autorun'
require 'minitest/spec'

def ruby_version_at_least_2_3_0?
  Gem::Dependency.new('', '>= 2.3.0').match?('', RUBY_VERSION)
end

if ruby_version_at_least_2_3_0?
  $stderr.puts "\nDig_rb: Running tests under ruby version #{RUBY_VERSION} (>= 2.3.0), we will test to make sure we are NOT patching #dig, and run other tests to ensure native ruby #dig in this ruby version meets the same specs as our patched version in other ruby versions.\n\n"
end