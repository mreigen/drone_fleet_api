require "spec_helper"

RSpec.describe V1::FlightsController, type: :controller do
  let(:flight_1) { Flight.new(project_id: 456, craft_id: 678) }

  describe "GET index" do
    # Examples are refactored inside common_actions_controller_spec.rb
  end

  describe "DELETE destroy" do
    # Examples are refactored inside common_actions_controller_spec.rb
  end

  describe "GET show" do

    # The other examples are in the shared common_actions_controller_spec.rb

    it "returns the flight along with NO sub_set" do
      expect(Flight).to receive(:find_by_guid) { flight_1 }
      expect(controller).to receive(:render_success).with(result: flight_1).and_call_original

      get :show, id: 123
    end
  end

  describe "PUT update" do

    # The other examples are in the shared common_actions_controller_spec.rb

    it "updates the flight" do
      expect(Flight).to receive(:find_by_guid).with("123") { flight_1 }
      expect(controller).to receive(:klass_params).and_call_original
      expect(flight_1).to receive(:update_attributes).and_call_original
      expect(controller).to receive(:render_success).with(result: flight_1).and_call_original

      put :update, id: 123, avg_speed: 789.01

      expect(flight_1.avg_speed).to eq(789.01)
    end
  end
end