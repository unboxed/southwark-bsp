require "mail"

class EmailValidator < ActiveModel::EachValidator
  HOST  = "(?i-mx:xn-|[a-z0-9])(?i-mx:[-a-z0-9]*)"
  TLD   = "(?i-mx:[a-z]{2,63}|xn--(?i-mx:[a-z0-9]+-)*[a-z0-9]+)"
  LOCAL = "(?i-mx:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~\-]+)"

  EMAIL_REGEX = /\A#{LOCAL}(?:\.#{LOCAL})*@(?:#{HOST}\.)+#{TLD}\z/

  def validate_each(record, attribute, value)
    if value =~ EMAIL_REGEX
      email = parsed_email(value)
    else
      record.errors.add attribute, :invalid
    end
  rescue Mail::Field::ParseError
    record.errors.add attribute, :invalid
  end

  def parsed_email(email)
    Mail::Address.new(email)
  end
end
