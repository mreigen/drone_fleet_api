require "spec_helper"

RSpec.describe V1::ProjectsController, type: :controller do
  before(:example) do
    allow(V1::BasicActions).to receive(:get_klass) { Project }
  end

  let(:project_1) { Project.new }
  let(:project_2) { Project.new }
  let(:all_projects) {[ project_1, project_2]}
  let(:crafts) { [double("many_crafts")] }

  describe "GET index" do
    it "renders success with all projects" do
      expect(Project).to receive(:all) { all_projects }
      expect(controller).to receive(:render_success).with(result: all_projects).and_call_original

      get :index
    end
  end

  describe "GET show" do
    it "returns the correct project" do
      expect(Project).to receive(:find_by_guid) { project_1 }
      expect(project_1).to receive(:children)
      expect(controller).to receive(:render_success).with(result: project_1, crafts: nil).and_call_original

      get :show, id: 123
    end

    it "returns the project along with sub_set" do
      expect(Project).to receive(:find_by_guid) { project_1 }
      expect(project_1).to receive(:children) { crafts }
      expect(controller).to receive(:render_success).with(result: project_1, crafts: crafts).and_call_original

      get :show, id: 123
    end
  end

  describe "DELETE destroy" do
    it "deletes the project" do
      expect(Project).to receive(:find_by_guid).with("123") { project_1 }
      expect(project_1).to receive(:delete) { true }
      expect(controller).to receive(:render_success).with(result: "The Project with id: 123 has been deleted").and_call_original

      delete :destroy, id: 123
    end
    context "when it can't delete the project" do
      it "returns error" do
        expect(Project).to receive(:find_by_guid).with("123") { project_1 }
        expect(project_1).to receive(:delete) { false }
        expect(controller).to receive(:render_error).with("Failed to delete a Project with 123", :bad_request).and_call_original

        delete :destroy, id: 123
      end
    end
    context "when it can't find the project" do
      it "returns error" do
        expect(Project).to receive(:find_by_guid).with("123") { nil }
        expect(project_1).to_not receive(:delete)
        expect(controller).to receive(:render_error).with("Can't find a Project with id: 123", :bad_request).and_call_original

        delete :destroy, id: 123
      end
    end
  end

  describe "PUT update" do
    it "updates the project" do
      expect(Project).to receive(:find_by_guid).with("123") { project_1 }
      expect(controller).to receive(:klass_params).and_call_original
      expect(project_1).to receive(:update_attributes).and_call_original
      expect(controller).to receive(:render_success).with(result: project_1).and_call_original

      put :update, id: 123, type: "blah"

      expect(project_1.type).to eq "blah"
    end
    context "when it can't update the project" do
      it "returns error" do
        expect(Project).to receive(:find_by_guid).with("123") { project_1 }
        expect(controller).to receive(:klass_params) { { blah: anything } }
        expect(project_1).to receive(:update_attributes) { false }
        expect(controller).to receive(:render_error).with("Couldn't update the Project with id: 123", :bad_request).and_call_original

        put :update, id: 123
      end
    end
    context "when it can't find the project" do
      it "returns error" do
        expect(Project).to receive(:find_by_guid).with("123") { nil }
        expect(project_1).to_not receive(:update_attributes)
        expect(controller).to receive(:render_error).with("Can't find a Project with id: 123", :bad_request).and_call_original

        put :update, id: 123
      end
    end
  end
end