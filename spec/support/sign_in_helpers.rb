module SignInHelpers
  def sign_in_as_admin
    user = create :user
    visit "/admin"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Sign in"
  end
end
