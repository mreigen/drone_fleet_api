require "spec_helper"

# ================================================================================
# The sharable tests are refactored and locate inside common_actions_controller_spec.rb.
# The tests below are for the custom actions of this controller.
# ================================================================================

RSpec.describe V1::CraftsController, type: :controller do
  let(:craft_1) { Craft.new }

  describe "GET index" do
    # Examples are refactored inside common_actions_controller_spec.rb
  end

  describe "GET show" do

    # The other examples are in the shared common_actions_controller_spec.rb

    it "returns the craft along with NO sub_set" do
      expect(Craft).to receive(:find_by_guid) { craft_1 }
      expect(controller).to receive(:render_success).with(result: craft_1).and_call_original

      get :show, id: 123
    end
  end

  describe "DELETE destroy" do
    # Examples are refactored inside common_actions_controller_spec.rb
  end

  describe "PUT update" do

    # The other examples are in the shared common_actions_controller_spec.rb

    it "updates the craft" do
      expect(Craft).to receive(:find_by_guid).with("123") { craft_1 }
      expect(controller).to receive(:klass_params).and_call_original
      expect(craft_1).to receive(:update_attributes).and_call_original
      expect(controller).to receive(:render_success).with(result: craft_1).and_call_original

      put :update, id: 123, type: "blah"

      expect(craft_1.type).to eq "blah"
    end
  end
end