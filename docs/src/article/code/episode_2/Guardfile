# frozen_string_literal: true

# Add files and commands to this file, like the example:
#   watch(%r{file/path}) { `command(s)` }
#
guard :shell do
  watch(/(.*).rb/) { |_m| `rake rubocop:auto_correct` }
  watch(%r{lib/(.*).rb}) { |_m| `rake test` }
end

guard :minitest do
  # with Minitest::Unit
  watch(%r{test\/*.rb})
end
