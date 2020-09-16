class BulkUploadForm
  include ActiveModel::Model

  attr_accessor :file

  validates :file, csv_file: {
    allowed_number_of_files: 1,
    accepted_mime_types: ["text/csv"],
    content_length: { over: 1 }
  }

  def self.model_name
    ActiveModel::Name.new(self, nil, "BulkImport")
  end

  def submit
    return false unless valid?

    import_records_from_file
  end

  private

    def import_records_from_file
      Building.upsert_all building_data, unique_by: :uprn
    end

    def csv_data
      BuildingRecordList.build_from_uploaded_file file
    end

    def building_data
      csv_data.building_data
    end
end
