Then('I should see {string}') do |content|
  expect(page).to have_content(content)
end

Then('debugger') do
  binding.pry
end

Given('I press {string}') do |label|
  page.click_on label
end

Given('I fill in {string} with {string}') do |label, value|
  fill_in label, with: value
end
