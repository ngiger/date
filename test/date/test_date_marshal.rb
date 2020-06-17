# frozen_string_literal: true
require 'test/unit'
require 'date'

class TestDateMarshal < Test::Unit::TestCase

  def test_marshal
    d = Date.new
    m = Marshal.dump(d)
    d2 = Marshal.load(m)
    assert_equal(d, d2)
    assert_equal(d.start, d2.start)
    assert_instance_of(String, d2.to_s)

    d = Date.today
    m = Marshal.dump(d)
    d2 = Marshal.load(m)
    assert_equal(d, d2)
    assert_equal(d.start, d2.start)
    assert_instance_of(String, d2.to_s)

    d = DateTime.now
    m = Marshal.dump(d)
    d2 = Marshal.load(m)
    assert_equal(d, d2)
    assert_equal(d.start, d2.start)
    assert_instance_of(String, d2.to_s)

    d = Date.today
    a = d.marshal_dump
    d.freeze
    assert(d.frozen?)
    expected_error = defined?(FrozenError) ? FrozenError : RuntimeError
    assert_raise(expected_error){d.marshal_load(a)}

    d = DateTime.now
    a = d.marshal_dump
    d.freeze
    assert(d.frozen?)
    expected_error = defined?(FrozenError) ? FrozenError : RuntimeError
    assert_raise(expected_error){d.marshal_load(a)}

    d = Date.new + 1/2r + 2304/65437r/86400
    m = Marshal.dump(d)
    d2 = Marshal.load(m)
    assert_equal(d, d2)
    assert_equal(d.start, d2.start)
    assert_instance_of(String, d2.to_s)

  end

  def test_marshal_backward_compatibility
      hexdump = "0408553a09446174655b0b690069006902c0a8553a0d526174696f6e616c5b076c2b0800001a71180269029dff6900660c32323939313631"
      binary = [hexdump].pack('H*')
      obj = Marshal.load(binary)
  end

  def test_memsize
    require 'objspace'
    t = DateTime.new(2018, 11, 13)
    size = ObjectSpace.memsize_of(t)
    t2 = Marshal.load(Marshal.dump(t))
    assert_equal(t, t2)
    assert_equal(size, ObjectSpace.memsize_of(t2), "not reallocated but memsize changed")
  end
end
