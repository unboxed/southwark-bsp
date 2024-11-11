module Admin
  class Mailer < Devise::Mailer
    def devise_mail(record, action, opts = {})
      initialize_from_record(record)
      view_mail(template_id, headers_for(action, opts))
    end

    private

    def template_id
      ENV.fetch("NOTIFY_DEVISE_TEMPLATE_ID")
    end
  end
end
