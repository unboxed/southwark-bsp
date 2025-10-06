module Admin
  class BulkImportsController < AdminController
    def new
      @upload_form = BulkUploadForm.new
    end

    def create
      @upload_form = BulkUploadForm.new bulk_upload_params

      if @upload_form.submit
        redirect_to admin_root_path
      else
        render :new
      end
    end

    private

      def bulk_upload_params
        params.expect(bulk_import: [:file])
      end
  end
end
