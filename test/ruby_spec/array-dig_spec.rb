require 'minitest_helper'

# https://github.com/ruby/spec/blob/f8358bd32e6d2c492f8d7e7bb5a35524d2756c3c/core/array/dig_spec.rb
describe "Array#dig" do
  it "returns #at with one arg" do
    assert_equal 'a', ['a'].dig(0)
    assert_nil ['a'].dig(1)
  end

  it "recurses array elements" do
    a = [ [ 1, [2, '3'] ] ]
    assert_equal 1, a.dig(0, 0)
    assert_equal '3', a.dig(0, 1, 1)
    assert_equal 2, a.dig(0, -1, 0)
  end

  it "raises without any args" do
    e = assert_raises(ArgumentError) { [10].dig() }
    # jrochkind added...
    assert_match /\Awrong number of arguments/, e.message
  end

  it "calls #dig on the result of #at with the remaining arguments" do
    h = [[nil, [nil, nil, 42]]]

    # We don't have the test infrastructure for should_receive
    #h[0].should_receive(:dig).with(1, 2).and_return(42)

    assert_equal 42, h.dig(0, 1, 2)
  end
end