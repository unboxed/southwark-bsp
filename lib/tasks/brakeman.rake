# frozen_string_literal: true

desc "Run brakeman checks"
task brakeman: :environment do
  exit 1 unless system "brakeman --no-pager"
end
