class CsvFileValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    allowed_number_of_files = options.fetch(:allowed_number_of_files) { 1 }
    accepted_mime_types = options.fetch(:accepted_mime_types) { ["text/csv"] }
    minimal_content_length = options.fetch(:content_length, over: 1).fetch(:over)

    if value.is_a?(Array) && (value.length > allowed_number_of_files)
      record.errors[attribute] << "You can only select up to 1 file at the same time."
    end

    unless value.present?
      record.errors[:base] << "Select a CSV file."
    end

    unless value.present? && accepted_mime_types.include?(value.content_type)
      record.errors[:base] << "The selected file must be a CSV."
    end

    unless value.present? && value.size > minimal_content_length
      record.errors[:base] << "The selected file appears to be empty."
    end
  end
end
