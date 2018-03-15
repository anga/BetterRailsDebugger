describe "Ruby::Extension" do
  context "configurations" do
    it "expect to raise exeption" do
      expect {
        eval %{
        class MyExtension < ::BetterRailsDebugger::Parser::Ruby::Extension
          position 'invalid'
        end
        }
      }.to raise_exception(ArgumentError)
    end

    it "expect to not raise exeption" do
      expect {
        eval %{
        class MyExtension < ::BetterRailsDebugger::Parser::Ruby::Extension
          position 100
        end
        }
      }.to_not raise_exception(ArgumentError)
    end

    it "expect to not raise exeption" do
      expect {
        eval %{
        class MyExtension < ::BetterRailsDebugger::Parser::Ruby::Extension
          position 10.0
        end
        }
      }.to_not raise_exception(ArgumentError)
    end
  end
end