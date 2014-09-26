require "spec_helper"

%w{customer project craft flight storage}.each do |subject_name|
  klass_name        = subject_name.classify
  model_klass       = klass_name.constantize
  controller_klass  = "V1::#{klass_name}sController".constantize

  RSpec.describe controller_klass, type: :controller do
    let(:model_object_1) { model_klass.new }
    let(:model_object_2) { model_klass.new }
    let(:all_model_objects) {[ model_object_1, model_object_2]}
    let(:projects) { [double("many_projects")] }

    describe "GET index" do
      it "renders success with all #{klass_name}s" do
        expect(model_klass).to receive(:all) { all_model_objects }
        expect(controller).to receive(:render_success).with(result: all_model_objects).and_call_original

        get :index
      end
    end

    describe "GET show" do
      context "when it can't find a #{klass_name} with id" do
        it "returns error" do
          expect(model_klass).to receive(:find_by_guid).with("123") { nil }
          expect(controller).to receive(:render_error).with("Can't find #{model_klass} with id: 123").and_call_original

          get :show, id: 123
        end
      end
      it "returns the correct #{klass_name}" do
        expect(model_klass).to receive(:find_by_guid) { model_object_1 }
        expect(controller).to receive(:render_success)
          .with(hash_including(result: model_object_1)).and_call_original

        get :show, id: 123
      end

      # This example will be implemented in the corresponding controller spec
      # because each controller#show has its own sub_set list
      #
      # it "returns the #{klass_name} along with sub_set" do
      # end
    end

    describe "DELETE destroy" do
      it "deletes the #{klass_name}" do
        expect(model_klass).to receive(:find_by_guid).with("123") { model_object_1 }
        expect(model_object_1).to receive(:delete) { true }
        expect(controller).to receive(:render_success).with(result: "The #{model_klass} with id: 123 has been deleted").and_call_original

        delete :destroy, id: 123
      end
      context "when it can't delete the #{klass_name}" do
        it "returns error" do
          expect(model_klass).to receive(:find_by_guid).with("123") { model_object_1 }
          expect(model_object_1).to receive(:delete) { false }
          expect(controller).to receive(:render_error).with("Failed to delete a #{model_klass} with 123", :bad_request).and_call_original

          delete :destroy, id: 123
        end
      end
      context "when it can't find the #{klass_name}" do
        it "returns error" do
          expect(model_klass).to receive(:find_by_guid).with("123") { nil }
          expect(model_object_1).to_not receive(:delete)
          expect(controller).to receive(:render_error).with("Can't find a #{model_klass} with id: 123", :bad_request).and_call_original

          delete :destroy, id: 123
        end
      end
    end

    describe "PUT update" do

      # Implemented in each of the controller#update spec
      # because each model has a different set of "updateable" attributes
      #
      # it "updates the #{klass_name}" do
      # end

      context "when it can't update the #{klass_name}" do
        it "returns error" do
          expect(model_klass).to receive(:find_by_guid).with("123") { model_object_1 }
          expect(controller).to receive(:klass_params) { { blah: anything } }
          expect(model_object_1).to receive(:update_attributes) { false }
          expect(controller).to receive(:render_error).with("Couldn't update the #{model_klass} with id: 123", :bad_request).and_call_original

          put :update, id: 123
        end
      end
      context "when it can't find the #{klass_name}" do
        it "returns error" do
          expect(model_klass).to receive(:find_by_guid).with("123") { nil }
          expect(model_object_1).to_not receive(:update_attributes)
          expect(controller).to receive(:render_error).with("Can't find a #{model_klass} with id: 123", :bad_request).and_call_original

          put :update, id: 123
        end
      end
    end
  end

end