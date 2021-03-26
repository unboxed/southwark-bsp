Given('I am on the home page') do
  visit root_path
end

Then('the page contains an error about {string}') do |msg|
  within(:css, 'div.govuk-error-summary') do
    expect(page).to have_content msg
  end
end
