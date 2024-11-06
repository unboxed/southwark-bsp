module ErrorsHelper
  def form_group(options, &block)
    classes = %w[govuk-form-group]
    classes.push(options.delete(:class)) if options.key?(:class)

    object, field = options.delete(:for)
    classes.push "govuk-form-group--error" if object && object.errors[field].any?

    options[:class] = classes.join(" ")
    tag.div(capture(&block), **options)
  end

  def error_message_for(object, field, options = {})
    return unless (errors = object && object.errors[field].presence)

    defaults = {
      id: "#{field.to_s.dasherize}-error",
      class: "govuk-error-message"
    }

    tag.span(**defaults, **options) do
      concat(t(:prefix_html, scope: :errors))
      concat(errors.first)
    end
  end

  def error_summary(object, options = {})
    return unless object.errors.any?

    defaults = {
      class: "govuk-list govuk-error-summary__list"
    }

    summary = tag.ul(**defaults, **options) do
      object.errors.each do |error|
        id = error.attribute.to_s.dasherize
        link = link_to(error.full_message, "##{id}-error")

        concat(tag.li(link))
      end
    end

    t(:summary_html, scope: :errors, summary: summary)
  end
end
