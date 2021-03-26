Then('the page contains {string}') do |content|
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

Given('I choose {string}') do |option|
  choose option
end

Given('I check {string}') do |option|
  check option
end

Then('print the page') do
  log page.html
end
