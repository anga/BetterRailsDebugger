describe "Ruby Parser" do
  context "Ruby::Parser" do
    context "#analize" do
      let(:parser) {BetterRailsDebugger::Parser::Ruby::Parser.new file_path, {}}
      let(:file_path) {File.join(File.dirname(__FILE__), 'ruby_examples', 'simple.rb')}

      it "should set @node_tree" do
         expect {
           parser.analise
         }.to change{
           parser.instance_variable_get :@node_tree
         }
      end
    end
  end
end