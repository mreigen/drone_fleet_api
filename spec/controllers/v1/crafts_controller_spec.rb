require "spec_helper"

RSpec.describe V1::CraftsController, type: :controller do
  before(:example) do
    allow(V1::BasicActions).to receive(:get_klass) { Craft }
  end

  let(:craft_1) { Craft.new }
  let(:craft_2) { Craft.new }
  let(:all_crafts) {[ craft_1, craft_2]}

  describe "GET index" do
    it "renders success with all crafts" do
      expect(Craft).to receive(:all) { all_crafts }
      expect(controller).to receive(:render_success).with(result: all_crafts).and_call_original

      get :index
    end
  end

  describe "GET show" do
    it "returns the correct craft" do
      expect(Craft).to receive(:find_by_guid) { craft_1 }
      expect(controller).to receive(:render_success).with(result: craft_1).and_call_original

      get :show, id: 123
    end

    it "returns the craft along with NO sub_set" do
      expect(Craft).to receive(:find_by_guid) { craft_1 }
      expect(controller).to receive(:render_success).with(result: craft_1).and_call_original

      get :show, id: 123
    end
  end

  describe "DELETE destroy" do
    it "deletes the craft" do
      expect(Craft).to receive(:find_by_guid).with("123") { craft_1 }
      expect(craft_1).to receive(:delete) { true }
      expect(controller).to receive(:render_success).with(result: "The Craft with id: 123 has been deleted").and_call_original

      delete :destroy, id: 123
    end
    context "when it can't delete the craft" do
      it "returns error" do
        expect(Craft).to receive(:find_by_guid).with("123") { craft_1 }
        expect(craft_1).to receive(:delete) { false }
        expect(controller).to receive(:render_error).with("Failed to delete a Craft with 123", :bad_request).and_call_original

        delete :destroy, id: 123
      end
    end
    context "when it can't find the craft" do
      it "returns error" do
        expect(Craft).to receive(:find_by_guid).with("123") { nil }
        expect(craft_1).to_not receive(:delete)
        expect(controller).to receive(:render_error).with("Can't find a Craft with id: 123", :bad_request).and_call_original

        delete :destroy, id: 123
      end
    end
  end

  describe "PUT update" do
    it "updates the craft" do
      expect(Craft).to receive(:find_by_guid).with("123") { craft_1 }
      expect(controller).to receive(:klass_params).and_call_original
      expect(craft_1).to receive(:update_attributes).and_call_original
      expect(controller).to receive(:render_success).with(result: craft_1).and_call_original

      put :update, id: 123, type: "blah"

      expect(craft_1.type).to eq "blah"
    end
    context "when it can't update the craft" do
      it "returns error" do
        expect(Craft).to receive(:find_by_guid).with("123") { craft_1 }
        expect(controller).to receive(:klass_params) { { blah: anything } }
        expect(craft_1).to receive(:update_attributes) { false }
        expect(controller).to receive(:render_error).with("Couldn't update the Craft with id: 123", :bad_request).and_call_original

        put :update, id: 123
      end
    end
    context "when it can't find the craft" do
      it "returns error" do
        expect(Craft).to receive(:find_by_guid).with("123") { nil }
        expect(craft_1).to_not receive(:update_attributes)
        expect(controller).to receive(:render_error).with("Can't find a Craft with id: 123", :bad_request).and_call_original

        put :update, id: 123
      end
    end
  end
end