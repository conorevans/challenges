require_relative './spec_helper'
require './level_node'

RSpec.describe BinarySearch::Tree do
  before :all do
    bst = described_class.new(value: 4)
    bst.populate(values: [2, 6, 3, 1, 5, 7])
    bst.connect_level_nodes
    @bst_as_hash = bst.to_h

    @expected_values = { '2' => 6, '1' => 3, '3' => 5, '5' => 7 }
  end

  (1..7).each do |node_value|
    it "correctly sets level node for node #{node_value}" do
      expect(@bst_as_hash[node_value.to_s].level&.value).to eq(@expected_values[node_value.to_s])
    end
  end
end
