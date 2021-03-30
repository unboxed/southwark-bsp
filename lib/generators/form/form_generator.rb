class FormGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :sections,
           type: :array,
           required: false,
           default: [],
           banner: "[section next_section etc]"

  def create_form_file
    # TODO
  end

  def create_sections
    sections.each do |section|
      @section = section

      template "section.rb", "app/models/#{file_name}/sections/#{section}_form.rb"
      template "view.html.erb", "app/views/#{plural_name}/_#{section}_form.html.erb"
    end
  end
end
