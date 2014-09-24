require "spec_helper"

# ================================================================================
# The sharable tests are refactored and locate inside common_actions_controller_spec.rb.
# The tests below are for the custom actions of this controller.
# ================================================================================

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

  describe "POST add_craft" do
    let(:project)  { Project.new(type: "test project") }
    let(:craft)   { Craft.new(type: "test") }
    before do
      allow(Project).to receive(:find_by_guid) { project }
      allow(Craft).to  receive(:find_by_guid) { craft }
    end

    def post_add_craft(craft_id, project_id)
      post :add_craft, craft_id: craft_id, project_id: project_id
    end

    context "when there is no craft id provided" do
      let(:craft_id)  { "" }
      let(:project_id) { "123" }
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Either craft_id or project_id is blank").and_call_original
        post_add_craft(craft_id, project_id)
      end
    end
    context "when there is no project id provided" do
      let(:craft_id)  { "abc" }
      let(:project_id) { "" }
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Either craft_id or project_id is blank").and_call_original
        post_add_craft(craft_id, project_id)
      end
    end
    context "when there is no craft found" do
      let(:craft_id)  { "abc" }
      let(:project_id) { "123" }
      before do
        allow(Craft).to receive(:find_by_guid).with("abc")  { nil }
      end
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Can't find craft with craft_id: abc").and_call_original
        post_add_craft(craft_id, project_id)
      end
    end
    context "when there is no project found" do
      let(:craft_id)  { "abc" }
      let(:project_id) { "123" }
      before do
        allow(Project).to receive(:find_by_guid).with("123") { nil }
      end
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Can't find project with project_id: 123").and_call_original
        post_add_craft(craft_id, project_id)
      end
    end
    context "when both craft and project exist" do
      let(:craft_id)  { "abc" }
      let(:project_id) { "123" }
      before do
        allow(Project).to receive(:find_by_guid).with("123") { project }
        allow(Craft).to receive(:find_by_guid).with("abc") { craft }
      end
      context "when can't save record" do
        it "renders error" do
          allow(craft).to receive(:save) { false }
          expect(controller).to receive(:render_error)
            .with("Can't add craft_id abc to project_id 123").and_call_original
          post_add_craft(craft_id, project_id)
        end
      end
      it "adds craft to project" do
        post_add_craft(craft_id, project_id)

        expect(craft.project).to eq project
        expect(project.crafts).to include craft
      end
      it "renders success" do
        expect(controller).to receive(:render_success)
          .with(result: {project: project, crafts: project.crafts}).and_call_original
        post_add_craft(craft_id, project_id)
      end
    end
  end # add_craft

  describe "DELETE remove_craft" do
    let(:project)  { Project.new(type: "test project") }
    let(:craft)   { Craft.new(type: "test") }
    before do
      allow(Project).to receive(:find_by_guid) { project }
      allow(Craft).to  receive(:find_by_guid) { craft }
    end

    def delete_remove_craft(craft_id, project_id)
      delete :remove_craft, craft_id: craft_id, project_id: project_id
    end

    context "when there is no craft id provided" do
      let(:craft_id)  { "" }
      let(:project_id) { "123" }
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Either craft_id or project_id is blank").and_call_original
        delete_remove_craft(craft_id, project_id)
      end
    end
    context "when there is no project id provided" do
      let(:craft_id)  { "abc" }
      let(:project_id) { "" }
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Either craft_id or project_id is blank").and_call_original
        delete_remove_craft(craft_id, project_id)
      end
    end
    context "when there is no craft found" do
      let(:craft_id)  { "abc" }
      let(:project_id) { "123" }
      before do
        allow(Craft).to receive(:find_by_guid).with("abc")  { nil }
      end
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Can't find craft with craft_id: abc").and_call_original
        delete_remove_craft(craft_id, project_id)
      end
    end
    context "when there is no project found" do
      let(:craft_id)  { "abc" }
      let(:project_id) { "123" }
      before do
        allow(Project).to receive(:find_by_guid).with("123") { nil }
      end
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Can't find project with project_id: 123").and_call_original
        delete_remove_craft(craft_id, project_id)
      end
    end
    context "when both craft and project exist" do
      let(:craft_id)  { "abc" }
      let(:project_id) { "123" }
      before do
        allow(Project).to receive(:find_by_guid).with("123") { project }
        allow(Craft).to receive(:find_by_guid).with("abc") { craft }
      end
      context "when can't save record" do
        it "renders error" do
          allow(project).to receive(:save) { false }
          expect(controller).to receive(:render_error)
            .with("Can't remove craft_id abc from project_id 123").and_call_original
          delete_remove_craft(craft_id, project_id)
        end
      end
      it "adds craft to project" do
        delete_remove_craft(craft_id, project_id)

        expect(craft.project).to_not eq project
        expect(project.crafts).to_not include craft
      end
      it "renders success" do
        expect(controller).to receive(:render_success)
          .with(result: {project: project, crafts: project.crafts}).and_call_original
        delete_remove_craft(craft_id, project_id)
      end
    end
  end # remove_craft

  describe "POST add_flight" do
    let(:project)  { Project.new(type: "test project") }
    let(:flight)   { Flight.new(project_id: "test_project_id", craft_id: "test_craft_id") }
    before do
      allow(Project).to receive(:find_by_guid) { project }
      allow(Flight).to  receive(:find_by_guid) { flight }
    end

    def post_add_flight(flight_id, project_id)
      post :add_flight, flight_id: flight_id, project_id: project_id
    end

    context "when there is no flight id provided" do
      let(:flight_id)  { "" }
      let(:project_id) { "123" }
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Either flight_id or project_id is blank").and_call_original
        post_add_flight(flight_id, project_id)
      end
    end
    context "when there is no project id provided" do
      let(:flight_id)  { "abc" }
      let(:project_id) { "" }
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Either flight_id or project_id is blank").and_call_original
        post_add_flight(flight_id, project_id)
      end
    end
    context "when there is no flight found" do
      let(:flight_id)  { "abc" }
      let(:project_id) { "123" }
      before do
        allow(Flight).to receive(:find_by_guid).with("abc")  { nil }
      end
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Can't find flight with flight_id: abc").and_call_original
        post_add_flight(flight_id, project_id)
      end
    end
    context "when there is no project found" do
      let(:flight_id)  { "abc" }
      let(:project_id) { "123" }
      before do
        allow(Project).to receive(:find_by_guid).with("123") { nil }
      end
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Can't find project with project_id: 123").and_call_original
        post_add_flight(flight_id, project_id)
      end
    end
    context "when both flight and project exist" do
      let(:flight_id)  { "abc" }
      let(:project_id) { "123" }
      before do
        allow(Project).to receive(:find_by_guid).with("123") { project }
        allow(Flight).to receive(:find_by_guid).with("abc") { flight }
      end
      context "when can't save record" do
        it "renders error" do
          allow(flight).to receive(:save) { false }
          expect(controller).to receive(:render_error)
            .with("Can't add flight_id abc to project_id 123").and_call_original
          post_add_flight(flight_id, project_id)
        end
      end
      it "adds flight to project" do
        post_add_flight(flight_id, project_id)

        expect(flight.project).to eq project
        expect(project.flights).to include flight
      end
      it "renders success" do
        expect(controller).to receive(:render_success)
          .with(result: {project: project, flights: project.flights}).and_call_original
        post_add_flight(flight_id, project_id)
      end
    end
  end # add_flight

  describe "DELETE remove_flight" do
    let(:project)  { Project.new(type: "test project") }
    let(:flight)   { Flight.new(project_id: "test_project_id", craft_id: "test_craft_id") }
    before do
      allow(Project).to receive(:find_by_guid) { project }
      allow(Flight).to  receive(:find_by_guid) { flight }
    end

    def delete_remove_flight(flight_id, project_id)
      delete :remove_flight, flight_id: flight_id, project_id: project_id
    end

    context "when there is no flight id provided" do
      let(:flight_id)  { "" }
      let(:project_id) { "123" }
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Either flight_id or project_id is blank").and_call_original
        delete_remove_flight(flight_id, project_id)
      end
    end
    context "when there is no project id provided" do
      let(:flight_id)  { "abc" }
      let(:project_id) { "" }
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Either flight_id or project_id is blank").and_call_original
        delete_remove_flight(flight_id, project_id)
      end
    end
    context "when there is no flight found" do
      let(:flight_id)  { "abc" }
      let(:project_id) { "123" }
      before do
        allow(Flight).to receive(:find_by_guid).with("abc")  { nil }
      end
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Can't find flight with flight_id: abc").and_call_original
        delete_remove_flight(flight_id, project_id)
      end
    end
    context "when there is no project found" do
      let(:flight_id)  { "abc" }
      let(:project_id) { "123" }
      before do
        allow(Project).to receive(:find_by_guid).with("123") { nil }
      end
      it "renders error" do
        expect(controller).to receive(:render_error)
          .with("Can't find project with project_id: 123").and_call_original
        delete_remove_flight(flight_id, project_id)
      end
    end
    context "when both flight and project exist" do
      let(:flight_id)  { "abc" }
      let(:project_id) { "123" }
      before do
        allow(Project).to receive(:find_by_guid).with("123") { project }
        allow(Flight).to receive(:find_by_guid).with("abc") { flight }
      end
      context "when can't save record" do
        it "renders error" do
          allow(project).to receive(:save) { false }
          expect(controller).to receive(:render_error)
            .with("Can't remove flight_id abc from project_id 123").and_call_original
          delete_remove_flight(flight_id, project_id)
        end
      end
      it "adds flight to project" do
        delete_remove_flight(flight_id, project_id)

        expect(flight.project).to_not eq project
        expect(project.flights).to_not include flight
      end
      it "renders success" do
        expect(controller).to receive(:render_success)
          .with(result: {project: project, flights: project.flights}).and_call_original
        delete_remove_flight(flight_id, project_id)
      end
    end
  end # remove_flight

end