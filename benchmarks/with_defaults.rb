Bundler.require(:benchmarks)

class PlainRubyTest
  attr_reader :foo, :bar

  def initialize(foo: "FOO", bar: "BAR")
    @foo = foo
    @bar = bar
  end
end

require "dry-initializer"
class DryTest
  extend Dry::Initializer::Mixin

  option :foo, default: proc { "FOO" }
  option :bar, default: proc { "BAR" }
end

require "kwattr"
class KwattrTest
  kwattr foo: "FOO", bar: "BAR"
end

require "active_attr"
class ActiveAttrTest
  include ActiveAttr::AttributeDefaults

  attribute :foo, default: "FOO"
  attribute :bar, default: "BAR"
end

puts "Benchmark for instantiation with default values"

Benchmark.ips do |x|
  x.config time: 15, warmup: 10

  x.report("plain Ruby") do
    PlainRubyTest.new
  end

  x.report("dry-initializer") do
    DryTest.new
  end

  x.report("kwattr") do
    KwattrTest.new
  end

  x.report("active_attr") do
    ActiveAttrTest.new
  end

  x.compare!
end
