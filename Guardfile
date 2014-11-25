#
# GeoRuby Guardfile
#
ignore(/\/.#.+/)

# notification :off

guard :rubocop, all_on_start: false, keep_failed: false, notification: false, cli: ['--format', 'emacs'] do
  watch(/^lib\/(.+)\.rb$/)
end

guard :rspec, cmd: 'bundle exec rspec', notification: true, title: 'GeoRuby' do
  watch(/^spec\/.+_spec\.rb$/)
  watch(/^lib\/(.+)\.rb$/)     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { 'spec' }
end
