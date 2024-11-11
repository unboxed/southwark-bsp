class ApplicationMailer < Mail::Notify::Mailer
  default from: 'buildingsafety@southwark.gov.uk'
  layout 'mailer'
end
