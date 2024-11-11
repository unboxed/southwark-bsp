class ApplicationController < ActionController::Base
  before_action :redirect_to_canonical_url, unless: :canonical_domain?

  private

  def canonical_domain
    ENV.fetch("APPLICATION_HOST") { request.host_with_port }
  end

  def canonical_domain?
    canonical_domain == request.host_with_port
  end

  def canonical_url
    "#{request.protocol}#{canonical_domain}#{request.fullpath}"
  end

  def redirect_to_canonical_url
    redirect_to canonical_url
  end
end
