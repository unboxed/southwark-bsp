Given('I am on the home page') do
  visit root_path
end

Then('I should see an error about {string}') do |msg|
  within(:css, 'div.govuk-error-summary') do
    expect(page).to have_content msg
  end
end
