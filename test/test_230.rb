require 'minitest_helper'

if ruby_version_at_least_2_3_0?
  class Test230 < Minitest::Test
    our_home_path = File.expand_path("../..", __FILE__)
    [Array, Hash, Struct, OpenStruct].each do |klass|
      define_method("test_#{klass}_does_not_patch".to_sym) do
        source_location = klass.instance_method(:dig).source_location
        assert source_location.nil? || !source_location.first.start_with?(our_home_path), "On ruby 2.3.0+, unwanted monkey-patch of #{klass}#dig with dig_rb implementation: #{source_location}"
      end
    end
  end
end