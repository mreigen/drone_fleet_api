require "spec_helper"

RSpec.describe V1::CustomersController, type: :controller do
  let(:customer_1) { Customer.new }
  let(:projects) { [double("many_projects")] }

  describe "GET index" do
    # Examples are refactored inside common_actions_controller_spec.rb
  end

  describe "DELETE destroy" do
    # Examples are refactored inside common_actions_controller_spec.rb
  end

  describe "GET show" do

    # The other examples are in the shared common_actions_controller_spec.rb

    it "returns the customer along with sub_set" do
      expect(Customer).to receive(:find_by_guid) { customer_1 }
      expect(customer_1).to receive(:children) { projects }
      expect(controller).to receive(:render_success).with(result: customer_1, projects: projects).and_call_original

      get :show, id: 123
    end
  end

  describe "PUT update" do

    # The other examples are in the shared common_actions_controller_spec.rb

    it "updates the Customer" do
      expect(Customer).to receive(:find_by_guid).with("123") { customer_1 }
      expect(controller).to receive(:klass_params).and_call_original
      expect(customer_1).to receive(:update_attributes).and_call_original
      expect(controller).to receive(:render_success).with(result: customer_1).and_call_original

      put :update, id: 123, name: "blah"
      expect(customer_1.name).to eq "blah"
    end
  end
end