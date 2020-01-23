# frozen_string_literal: true

# Add files and commands to this file, like the example:
#   watch(%r{file/path}) { `command(s)` }
#
guard :shell do
  watch(/(.*).rb/) { |_m| `rake rubocop:auto_correct` }
  watch(/(.*).rb/) { |_m| `rake test` }
end
