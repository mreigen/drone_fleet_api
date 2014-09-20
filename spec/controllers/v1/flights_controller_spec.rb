require "spec_helper"

RSpec.describe V1::FlightsController, type: :controller do
  before(:example) do
    allow(V1::BasicActions).to receive(:get_klass) { Flight }
  end

  let(:flight_1) { Flight.new(project_id: 456, craft_id: 678) }
  let(:flight_2) { Flight.new(project_id: 456, craft_id: 678) }
  let(:all_flights) {[ flight_1, flight_2]}

  describe "GET index" do
    it "renders success with all flights" do
      expect(Flight).to receive(:all) { all_flights }
      expect(controller).to receive(:render_success).with(result: all_flights).and_call_original

      get :index
    end
  end

  describe "GET show" do
    it "returns the correct flight" do
      expect(Flight).to receive(:find_by_guid) { flight_1 }
      expect(controller).to receive(:render_success).with(result: flight_1).and_call_original

      get :show, id: 123
    end

    it "returns the flight along with NO sub_set" do
      expect(Flight).to receive(:find_by_guid) { flight_1 }
      expect(controller).to receive(:render_success).with(result: flight_1).and_call_original

      get :show, id: 123
    end
  end

  describe "DELETE destroy" do
    it "deletes the flight" do
      expect(Flight).to receive(:find_by_guid).with("123") { flight_1 }
      expect(flight_1).to receive(:delete) { true }
      expect(controller).to receive(:render_success).with(result: "The Flight with id: 123 has been deleted").and_call_original

      delete :destroy, id: 123
    end
    context "when it can't delete the flight" do
      it "returns error" do
        expect(Flight).to receive(:find_by_guid).with("123") { flight_1 }
        expect(flight_1).to receive(:delete) { false }
        expect(controller).to receive(:render_error).with("Failed to delete a Flight with 123", :bad_request).and_call_original

        delete :destroy, id: 123
      end
    end
    context "when it can't find the flight" do
      it "returns error" do
        expect(Flight).to receive(:find_by_guid).with("123") { nil }
        expect(flight_1).to_not receive(:delete)
        expect(controller).to receive(:render_error).with("Can't find a Flight with id: 123", :bad_request).and_call_original

        delete :destroy, id: 123
      end
    end
  end

  describe "PUT update" do
    it "updates the flight" do
      expect(Flight).to receive(:find_by_guid).with("123") { flight_1 }
      expect(controller).to receive(:klass_params).and_call_original
      expect(flight_1).to receive(:update_attributes).and_call_original
      expect(controller).to receive(:render_success).with(result: flight_1).and_call_original

      put :update, id: 123, avg_speed: 789.01

      expect(flight_1.avg_speed).to eq(789.01)
    end
    context "when it can't update the flight" do
      it "returns error" do
        expect(Flight).to receive(:find_by_guid).with("123") { flight_1 }
        expect(controller).to receive(:klass_params) { { blah: anything } }
        expect(flight_1).to receive(:update_attributes) { false }
        expect(controller).to receive(:render_error).with("Couldn't update the Flight with id: 123", :bad_request).and_call_original

        put :update, id: 123
      end
    end
    context "when it can't find the flight" do
      it "returns error" do
        expect(Flight).to receive(:find_by_guid).with("123") { nil }
        expect(flight_1).to_not receive(:update_attributes)
        expect(controller).to receive(:render_error).with("Can't find a Flight with id: 123", :bad_request).and_call_original

        put :update, id: 123
      end
    end
  end
end