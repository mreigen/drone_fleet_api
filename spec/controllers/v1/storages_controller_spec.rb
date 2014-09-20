require "spec_helper"

RSpec.describe V1::StoragesController, type: :controller do
  before(:example) do
    allow(V1::BasicActions).to receive(:get_klass) { Storage }
  end

  let(:storage_1) { Storage.new(access_key: "some_key", access_password: "some_password", customer_id: 234) }
  let(:storage_2) { Storage.new(access_key: "some_key", access_password: "some_password", customer_id: 234) }
  let(:all_storages) {[ storage_1, storage_2]}

  describe "GET index" do
    it "renders success with all storages" do
      expect(Storage).to receive(:all) { all_storages }
      expect(controller).to receive(:render_success).with(result: all_storages).and_call_original

      get :index
    end
  end

  describe "GET show" do
    it "returns the correct storage" do
      expect(Storage).to receive(:find_by_guid) { storage_1 }
      expect(controller).to receive(:render_success).with(result: storage_1).and_call_original

      get :show, id: 123
    end
  end

  describe "DELETE destroy" do
    it "deletes the storage" do
      expect(Storage).to receive(:find_by_guid).with("123") { storage_1 }
      expect(storage_1).to receive(:delete) { true }
      expect(controller).to receive(:render_success).with(result: "The Storage with id: 123 has been deleted").and_call_original

      delete :destroy, id: 123
    end
    context "when it can't delete the storage" do
      it "returns error" do
        expect(Storage).to receive(:find_by_guid).with("123") { storage_1 }
        expect(storage_1).to receive(:delete) { false }
        expect(controller).to receive(:render_error).with("Failed to delete a Storage with 123", :bad_request).and_call_original

        delete :destroy, id: 123
      end
    end
    context "when it can't find the storage" do
      it "returns error" do
        expect(Storage).to receive(:find_by_guid).with("123") { nil }
        expect(storage_1).to_not receive(:delete)
        expect(controller).to receive(:render_error).with("Can't find a Storage with id: 123", :bad_request).and_call_original

        delete :destroy, id: 123
      end
    end
  end

  describe "PUT update" do
    it "updates the storage" do
      expect(Storage).to receive(:find_by_guid).with("123") { storage_1 }
      expect(controller).to receive(:klass_params).and_call_original
      expect(storage_1).to receive(:update_attributes).and_call_original
      expect(controller).to receive(:render_success).with(result: storage_1).and_call_original

      put :update, id: 123, access_key: "new_key"

      expect(storage_1.access_key).to eq("new_key")
    end
    context "when it can't update the storage" do
      it "returns error" do
        expect(Storage).to receive(:find_by_guid).with("123") { storage_1 }
        expect(controller).to receive(:klass_params) { { blah: anything } }
        expect(storage_1).to receive(:update_attributes) { false }
        expect(controller).to receive(:render_error).with("Couldn't update the Storage with id: 123", :bad_request).and_call_original

        put :update, id: 123
      end
    end
    context "when it can't find the storage" do
      it "returns error" do
        expect(Storage).to receive(:find_by_guid).with("123") { nil }
        expect(storage_1).to_not receive(:update_attributes)
        expect(controller).to receive(:render_error).with("Can't find a Storage with id: 123", :bad_request).and_call_original

        put :update, id: 123
      end
    end
  end
end