require "spec_helper"

RSpec.describe V1::ProjectsController, type: :controller do
  let(:project_1) { Project.new }
  let(:crafts) { [double("many_crafts")] }

  describe "GET index" do
    # Examples are refactored inside common_actions_controller_spec.rb
  end

  describe "DELETE destroy" do
    # Examples are refactored inside common_actions_controller_spec.rb
  end

  describe "GET show" do

    # The other examples are in the shared common_actions_controller_spec.rb

    it "returns the project along with sub_set" do
      expect(Project).to receive(:find_by_guid) { project_1 }
      expect(project_1).to receive(:children) { crafts }
      expect(controller).to receive(:render_success).with(result: project_1, crafts: crafts).and_call_original

      get :show, id: 123
    end
  end

  describe "PUT update" do

    # The other examples are in the shared common_actions_controller_spec.rb

    it "updates the project" do
      expect(Project).to receive(:find_by_guid).with("123") { project_1 }
      expect(controller).to receive(:klass_params).and_call_original
      expect(project_1).to receive(:update_attributes).and_call_original
      expect(controller).to receive(:render_success).with(result: project_1).and_call_original

      put :update, id: 123, type: "blah"

      expect(project_1.type).to eq "blah"
    end
  end
end