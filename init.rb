require 'redmine'
require 'dispatcher'
require_dependency 'require_closing_note_patch'

Redmine::Plugin.register :redmine_require_closing_note do
  name 'Redmine Require Closing Note plugin'
  author 'Adam Walters'
  description 'Plugin to add validation on Issue which prevents closing of an issue without providing a note'
  version '0.0.1'
  
  requires_redmine :version_or_higher => '0.8.0'
end

# This was required for plugin to be included in development environment
Dispatcher.to_prepare do
  Issue.send(:include, RequireClosingNotePatch)
end