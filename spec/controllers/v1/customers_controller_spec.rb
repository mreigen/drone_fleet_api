require "spec_helper"

RSpec.describe V1::CustomersController, type: :controller do
  before(:example) do
    allow(V1::BasicActions).to receive(:get_klass) { Customer }
  end

  let(:customer_1) { Customer.new }
  let(:customer_2) { Customer.new }
  let(:all_customers) {[ customer_1, customer_2]}
  let(:projects) { [double("many_projects")] }

  describe "GET index" do
    it "renders success with all customers" do
      expect(Customer).to receive(:all) { all_customers }
      expect(controller).to receive(:render_success).with(result: all_customers).and_call_original

      get :index
    end
  end

  describe "GET show" do
    it "returns the correct customer" do
      expect(Customer).to receive(:find_by_guid) { customer_1 }
      expect(customer_1).to receive(:children)
      expect(controller).to receive(:render_success).with(result: customer_1, projects: nil).and_call_original

      get :show, id: 123
    end

    it "returns the customer along with sub_set" do
      expect(Customer).to receive(:find_by_guid) { customer_1 }
      expect(customer_1).to receive(:children) { projects }
      expect(controller).to receive(:render_success).with(result: customer_1, projects: projects).and_call_original

      get :show, id: 123
    end
  end

  describe "DELETE destroy" do
    it "deletes the customer" do
      expect(Customer).to receive(:find_by_guid).with("123") { customer_1 }
      expect(customer_1).to receive(:delete) { true }
      expect(controller).to receive(:render_success).with(result: "The Customer with id: 123 has been deleted").and_call_original

      delete :destroy, id: 123
    end
    context "when it can't delete the customer" do
      it "returns error" do
        expect(Customer).to receive(:find_by_guid).with("123") { customer_1 }
        expect(customer_1).to receive(:delete) { false }
        expect(controller).to receive(:render_error).with("Failed to delete a Customer with 123", :bad_request).and_call_original

        delete :destroy, id: 123
      end
    end
    context "when it can't find the customer" do
      it "returns error" do
        expect(Customer).to receive(:find_by_guid).with("123") { nil }
        expect(customer_1).to_not receive(:delete)
        expect(controller).to receive(:render_error).with("Can't find a Customer with id: 123", :bad_request).and_call_original

        delete :destroy, id: 123
      end
    end
  end

  describe "PUT update" do
    it "updates the customer" do
      expect(Customer).to receive(:find_by_guid).with("123") { customer_1 }
      expect(controller).to receive(:klass_params).and_call_original
      expect(customer_1).to receive(:update_attributes).and_call_original
      expect(controller).to receive(:render_success).with(result: customer_1).and_call_original

      put :update, id: 123, name: "blah"

      expect(customer_1.name).to eq "blah"
    end
    context "when it can't update the customer" do
      it "returns error" do
        expect(Customer).to receive(:find_by_guid).with("123") { customer_1 }
        expect(controller).to receive(:klass_params) { { blah: anything } }
        expect(customer_1).to receive(:update_attributes) { false }
        expect(controller).to receive(:render_error).with("Couldn't update the Customer with id: 123", :bad_request).and_call_original

        put :update, id: 123
      end
    end
    context "when it can't find the customer" do
      it "returns error" do
        expect(Customer).to receive(:find_by_guid).with("123") { nil }
        expect(customer_1).to_not receive(:update_attributes)
        expect(controller).to receive(:render_error).with("Can't find a Customer with id: 123", :bad_request).and_call_original

        put :update, id: 123
      end
    end
  end
end