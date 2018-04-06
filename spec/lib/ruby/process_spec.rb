require 'pp'
describe "Builder" do
  let(:builder) {::Parser::Builders::Default.new}
  let(:parser) {::Parser::Ruby25.new builder}
  let(:processor) {::BetterRailsDebugger::Parser::Ruby::Processor.new}
  before do
    processor.cleanup_subscriptions
  end

  it "test" do
    code = %{
    # begin_class (class, superclass, body)
    module Test::MyModule
      class Fafa::Foo < Something:Else::String

        # begin_sclass
        class << self
        end
        # end_esclass

        # begin_def
        def bar(one, two=2, &block)
          puts "Running bar method"
          a = []
          a.each do |x|
            x*2
          end
          array = [1,2,3]
          for i in array
            i + 1
          end
          lambda do
            puts 'test'
          end
        end
        # end_def

        # begin_defs
        def self.my_method
        end
        # end_defs

      end
      # end_class
    end
    }

    source_buffer = ::Parser::Source::Buffer.new('test', 1)
    source_buffer.source =  code
    ast = parser.parse source_buffer
    processor.setup
    processor.process ast

    # TEMPORAL
    # pp processor.information

  end
end