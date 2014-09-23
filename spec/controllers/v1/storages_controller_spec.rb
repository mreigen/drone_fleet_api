require "spec_helper"

RSpec.describe V1::StoragesController, type: :controller do
  let(:storage_1) { Storage.new(access_key: "some_key", access_password: "some_password", customer_id: 234) }

  describe "GET index" do
    # Examples are refactored inside common_actions_controller_spec.rb
  end

  describe "GET show" do
    # Examples are refactored inside common_actions_controller_spec.rb
  end

  describe "DELETE destroy" do
    # Examples are refactored inside common_actions_controller_spec.rb
  end

  describe "PUT update" do

    # The other examples are in the shared common_actions_controller_spec.rb

    it "updates the storage" do
      expect(Storage).to receive(:find_by_guid).with("123") { storage_1 }
      expect(controller).to receive(:klass_params).and_call_original
      expect(storage_1).to receive(:update_attributes).and_call_original
      expect(controller).to receive(:render_success).with(result: storage_1).and_call_original

      put :update, id: 123, access_key: "new_key"

      expect(storage_1.access_key).to eq("new_key")
    end
  end
end