module DashboardHelper
  def filtered?
    @buildings.scope != :all # rubocop:disable Rails/HelperInstanceVariable
  end
end
