require_relative "../test_helper"

module Tracer
  class ObjectTracerTest < TestCase
    include ActivationTests

    private

    def build_tracer
      stub_object = Object.new
      ObjectTracer.new(stub_object.object_id, stub_object.to_s, output: @output)
    end
  end

  class ObjectTracerIntegrationTest < IntegrationTestCase
    def test_object_tracer_traces_objects
      file = write_file("foo.rb", <<~RUBY)
        obj = Object.new

        def obj.foo
          100
        end

        def bar(obj)
          obj.foo
        end

        ObjectTracer.new(obj.object_id, obj.inspect).start

        bar(obj)
      RUBY

      out, err, status = execute_file(file)

      assert_empty(err)
      lines = out.strip.split("\n")
      assert_equal(2, lines.size)
      assert_match(
        %r{#depth:4  #<Object:.*> is used as a parameter obj of Object#bar at .*/foo\.rb:7},
        lines.first
      )
      assert_match(
        %r{#depth:3  #<Object:.*> receives \.foo at .*/foo\.rb:3},
        lines.last
      )
    end

    def test_object_tracer_works_with_basic_object
      file = write_file("foo.rb", <<~RUBY)
        obj = BasicObject.new

        def obj.foo
          100
        end

        def bar(obj)
          obj.foo
        end

        ObjectTracer.new(
          Object.instance_method(:object_id).bind_call(obj),
          Object.instance_method(:inspect).bind_call(obj)
        ).start

        bar(obj)
      RUBY

      out, err, status = execute_file(file)

      assert_empty(err)
      lines = out.strip.split("\n")
      assert_equal(2, lines.size)
      assert_match(
        %r{#depth:4  #<BasicObject:.*> is used as a parameter obj of Object#bar at .*/foo\.rb:7},
        lines.first
      )
      assert_match(
        %r{#depth:3  #<BasicObject:.*> receives \.foo at .*/foo\.rb:3},
        lines.last
      )
    end
  end
end