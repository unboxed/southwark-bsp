guard 'rails' do
  watch('Gemfile.lock')
  watch(%r{^(config|lib)/.*})
end

# This group allows to skip running RuboCop when RSpec or Capybara failed.
group :bsp_tests, halt_on_fail: true do
  guard :rspec, cmd: "bin/rspec --order defined --fail-fast" do
    require "guard/rspec/dsl"
    dsl = Guard::RSpec::Dsl.new(self)

    # Feel free to open issues for suggestions and improvements

    # RSpec files
    rspec = dsl.rspec
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    # Ruby files
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)

    # Rails files
    rails = dsl.rails(view_extensions: %w(erb haml slim))
    dsl.watch_spec_files_for(rails.app_files)
    dsl.watch_spec_files_for(rails.views)

    watch(rails.controllers) do |m|
      [
        rspec.spec.call("routing/#{m[1]}_routing"),
        rspec.spec.call("controllers/#{m[1]}_controller"),
        rspec.spec.call("acceptance/#{m[1]}")
      ]
    end

    # Rails config changes
    watch(rails.spec_helper)     { rspec.spec_dir }
    watch(rails.routes)          { "#{rspec.spec_dir}/routing" }
    watch(rails.app_controller)  { "#{rspec.spec_dir}/controllers" }

    # Capybara features specs
    watch(rails.view_dirs)     { |m| rspec.spec.call("features/#{m[1]}") }
    watch(rails.layouts)       { |m| rspec.spec.call("features/#{m[1]}") }

    # Turnip features and steps
    watch(%r{^spec/acceptance/(.+)\.feature$})
    watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$}) do |m|
      Dir[File.join("**/#{m[1]}.feature")][0] || "spec/acceptance"
    end

    watch(%r{^app/(models/concerns/.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }

    watch("app/models/concerns/delta_csv_mapper.rb") do
      "spec/exporters/delta_exporter_spec.rb"
    end
  end

  cucumber_options = {
    # Below are examples overriding defaults

    cmd: 'bin/cucumber',
    cmd_additional_args: '--profile rerun --fail-fast',

    # all_after_pass: false,
    # all_on_start: false,
    # keep_failed: false,
    # feature_sets: ['features/frontend', 'features/experimental'],

    # run_all: { cmd_additional_args: '--profile guard_all' },
    # focus_on: { 'wip' }, # @wip
    notification: false
  }

  guard "cucumber", cucumber_options do
    require "guard/rspec/dsl"
    dsl = Guard::RSpec::Dsl.new(self)

    # Rails files
    rails = dsl.rails(view_extensions: %w(erb haml slim))

    watch(rails.views) { "features" }

    watch(%r{^features/.+\.feature$})
    watch(%r{^features/support/.+$}) { "features" }

    watch(%r{^features/step_definitions/(.+)_steps\.rb$}) do |m|
      Dir[File.join("**/#{m[1]}.feature")][0] || "features"
    end
  end

  guard :rubocop do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
  end
end
