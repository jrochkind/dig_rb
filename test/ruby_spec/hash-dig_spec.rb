require 'minitest_helper'

# https://github.com/ruby/spec/blob/9011723c1bb4346bd9c2a6b8a88195d29b5c6e41/core/hash/dig_spec.rb
describe "Hash#dig" do
  it "returns #[] with one arg" do
    h = { 0 => false, a: 1 }
    assert_equal(1, h.dig(:a))
    assert_equal(false, h.dig(0))
    assert_nil(h.dig(1))
  end

  it "does recurse" do
    h = { foo: { bar: { baz: 1 } } }
    assert_equal(1, h.dig(:foo, :bar, :baz))
    assert_nil h.dig(:foo, :bar, :nope)
    assert_nil h.dig(:foo, :baz)
    assert_nil h.dig(:bar, :baz, :foo)
  end

  it "raises without args" do
    assert_raises(ArgumentError) { { the: 'borg' }.dig() }
  end

  it "handles type-mixed deep digging" do
    h = {}
    h[:foo] = [ { bar: [ 1 ] }, [ obj = Object.new, 'str' ] ]
    def obj.dig(*args); [ 42 ] end

    assert_equal([1], h.dig(:foo, 0, :bar))
    assert_equal(1, h.dig(:foo, 0, :bar, 0))
    assert_equal 'str', h.dig(:foo, 1, 1)
    # MRI does not recurse values returned from `obj.dig`
    assert_equal [42], h.dig(:foo, 1, 0, 0)
    assert_equal [42], h.dig(:foo, 1, 0, 0, 10)
  end

  it "raises TypeError if an intermediate element does not respond to #dig" do
    h = {}
    h[:foo] = [ { bar: [ 1 ] }, [ nil, 'str' ] ]
    assert_raises(TypeError) { h.dig(:foo, 0, :bar, 0, 0) }
    assert_raises(TypeError) { h.dig(:foo, 1, 1, 0) }
  end

  it "calls #dig on the result of #[] with the remaining arguments" do
    h = { foo: { bar: { baz: 42 } } }

    #TODO? EH??
    # h[:foo].should_receive(:dig).with(:bar, :baz).and_return(42)

    assert_equal 42, h.dig(:foo, :bar, :baz)
  end

end