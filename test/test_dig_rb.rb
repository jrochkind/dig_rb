require 'minitest_helper'

class TestDigRb < Minitest::Test


  # https://github.com/ruby/ruby/blob/a837be87fdf580ac4fd58c4cb2f1ee16bab11b99/test/ruby/test_array.rb#L2655
  def test_array
    h = Array[Array[{a: 1}], 0]
    assert_equal(1, h.dig(0, 0, :a))
    assert_nil(h.dig(2, 0))
    assert_raises(TypeError) {h.dig(1, 0)}
  end

  # http://ruby-doc.org/core-2.3.0/Array.html#method-i-dig
  def test_array_examples
    a = [[1, [2, 3]]]
    assert_equal(3, a.dig(0, 1, 1))
    assert_equal(nil, a.dig(1, 2, 3))

    # The docs lie, in 2.3.0 this actually raises:
    # TypeError: Fixnum does not have #dig method
    # assert_equal(nil, a.dig(0, 0, 0))
    e = assert_raises(TypeError) { a.dig(0, 0, 0) }
    assert_equal("Fixnum does not have #dig method", e.message)

    assert_equal(:bar, [42, {foo: :bar}].dig(1, :foo))
  end

  # https://github.com/ruby/ruby/blob/a837be87fdf580ac4fd58c4cb2f1ee16bab11b99/test/ruby/test_hash.rb#L1306
  def test_hash
    h = Hash[a: Hash[b: [1, 2, 3]], c: 4]
    assert_equal(1, h.dig(:a, :b, 0))
    assert_nil(h.dig(:b, 1))
    assert_raises(TypeError) {h.dig(:c, 1)}
    o = Object.new
    def o.dig(*args)
      {dug: args}
    end
    h[:d] = o
    assert_equal({dug: [:foo, :bar]}, h.dig(:d, :foo, :bar))
  end

  # http://ruby-doc.org/core-2.3.0/Hash.html#method-i-dig
  def test_hash_examples
    h = { foo: {bar: {baz: 1}}}
    assert_equal(1, h.dig(:foo, :bar, :baz))
    assert_nil(h.dig(:foo, :zot, :xyz))

    g = { foo: [10, 11, 12] }
    assert_equal(11,  g.dig(:foo, 1))
  end

  # https://github.com/ruby/ruby/blob/a837be87fdf580ac4fd58c4cb2f1ee16bab11b99/test/ruby/test_struct.rb#L363
  def test_struct
    klass = Struct.new(:a)
    o = klass.new(klass.new({b: [1, 2, 3]}))
    assert_equal(1, o.dig(:a, :a, :b, 0))
    assert_nil(o.dig(:b, 0))
  end

  # http://ruby-doc.org/core-2.3.0/Struct.html#method-i-dig
  def test_struct_examples
    klass = Struct.new(:a)
    o = klass.new(klass.new({b: [1, 2, 3]}))

    assert_equal(1, o.dig(:a, :a, :b, 0))
    assert_nil(o.dig(:b, 0))
  end

  # Not covered by any tests, but actual behavior.
  # https://github.com/jrochkind/dig_rb/issues/5
  def test_struct_supports_array_access
    klass = Struct.new(:a, :b)
    o = klass.new(:first, :second)

    assert_equal(:second, o.dig(1))
    assert_nil(o.dig(2))

    e = assert_raises(TypeError) { o.dig(Object.new) }
  end

  # https://github.com/ruby/ruby/blob/a837be87fdf580ac4fd58c4cb2f1ee16bab11b99/test/ostruct/test_ostruct.rb#L112
  def test_ostruct
    os1 = OpenStruct.new
    os2 = OpenStruct.new
    os1.child = os2
    os2.foo = :bar
    os2.child = [42]
    assert_equal :bar, os1.dig("child", :foo)
    assert_nil os1.dig("parent", :foo)
    e = assert_raises(TypeError) { os1.dig("child", 0) }
    # tested in 2.3.0:
    assert_equal("0 is not a symbol nor a string", e.message)
  end

  # http://ruby-doc.org/stdlib-2.3.0/libdoc/ostruct/rdoc/OpenStruct.html#method-i-dig
  def test_ostruct_examples
    address = OpenStruct.new('city' => "Anytown NC", 'zip' => 12345)
    person = OpenStruct.new('name' => 'John Smith', 'address' => address)

    assert_equal(12345, person.dig(:address, 'zip'))
    assert_nil(person.dig(:business_address, 'zip'))
  end


end
