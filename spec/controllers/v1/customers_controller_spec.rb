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

  describe "POST add_project" do
    let(:customer)  { Customer.new(name: "test customer") }
    let(:project)   { Project.new(type: "test") }
    before do
      allow(Customer).to receive(:find_by_guid) { customer }
      allow(Project).to  receive(:find_by_guid) { project }
    end

    def post_add_project(project_id, customer_id)
      post :add_project, project_id: project_id, customer_id: customer_id
    end

    context "when there is no project id provided" do
      let(:project_id)  { "" }
      let(:customer_id) { "123" }
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Either project_id or customer_id is blank").and_call_original
        post_add_project(project_id, customer_id)
      end
    end
    context "when there is no customer id provided" do
      let(:project_id)  { "abc" }
      let(:customer_id) { "" }
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Either project_id or customer_id is blank").and_call_original
        post_add_project(project_id, customer_id)
      end
    end
    context "when there is no project found" do
      let(:project_id)  { "abc" }
      let(:customer_id) { "123" }
      before do
        allow(Project).to receive(:find_by_guid).with("abc")  { nil }
      end
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Can't find project with project_id: abc").and_call_original
        post_add_project(project_id, customer_id)
      end
    end
    context "when there is no customer found" do
      let(:project_id)  { "abc" }
      let(:customer_id) { "123" }
      before do
        allow(Customer).to receive(:find_by_guid).with("123") { nil }
      end
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Can't find customer with customer_id: 123").and_call_original
        post_add_project(project_id, customer_id)
      end
    end
    context "when both project and customer exist" do
      let(:project_id)  { "abc" }
      let(:customer_id) { "123" }
      before do
        allow(Customer).to receive(:find_by_guid).with("123") { customer }
        allow(Project).to receive(:find_by_guid).with("abc") { project }
      end
      it "adds project to customer" do
        post_add_project(project_id, customer_id)

        expect(project.customer).to eq customer
        expect(customer.projects).to include project
      end
      it "renders success" do
        expect(controller).to receive(:render_success)
          .with(result: {customer: customer, projects: customer.projects}).and_call_original
        post_add_project(project_id, customer_id)
      end
    end
  end # add_project

  describe "DELETE remove_project" do
    let(:customer)  { Customer.new(name: "test customer") }
    let(:project)   { Project.new(type: "test") }
    before do
      allow(Customer).to receive(:find_by_guid) { customer }
      allow(Project).to  receive(:find_by_guid) { project }
    end

    def delete_remove_project(project_id, customer_id)
      delete :remove_project, project_id: project_id, customer_id: customer_id
    end

    context "when there is no project id provided" do
      let(:project_id)  { "" }
      let(:customer_id) { "123" }
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Either project_id or customer_id is blank").and_call_original
        delete_remove_project(project_id, customer_id)
      end
    end
    context "when there is no customer id provided" do
      let(:project_id)  { "abc" }
      let(:customer_id) { "" }
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Either project_id or customer_id is blank").and_call_original
        delete_remove_project(project_id, customer_id)
      end
    end
    context "when there is no project found" do
      let(:project_id)  { "abc" }
      let(:customer_id) { "123" }
      before do
        allow(Project).to receive(:find_by_guid).with("abc")  { nil }
      end
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Can't find project with project_id: abc").and_call_original
        delete_remove_project(project_id, customer_id)
      end
    end
    context "when there is no customer found" do
      let(:project_id)  { "abc" }
      let(:customer_id) { "123" }
      before do
        allow(Customer).to receive(:find_by_guid).with("123") { nil }
      end
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Can't find customer with customer_id: 123").and_call_original
        delete_remove_project(project_id, customer_id)
      end
    end
    context "when both project and customer exist" do
      let(:project_id)  { "abc" }
      let(:customer_id) { "123" }
      before do
        allow(Customer).to receive(:find_by_guid).with("123") { customer }
        allow(Project).to receive(:find_by_guid).with("abc") { project }
      end
      it "adds project to customer" do
        delete_remove_project(project_id, customer_id)

        expect(project.customer).to_not eq customer
        expect(customer.projects).to_not include project
      end
      it "renders success" do
        expect(controller).to receive(:render_success)
          .with(result: {customer: customer, projects: customer.projects}).and_call_original
        delete_remove_project(project_id, customer_id)
      end
    end
  end # remove_project

end