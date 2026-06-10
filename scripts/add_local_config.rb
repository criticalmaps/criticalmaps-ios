#!/usr/bin/env ruby
# One-shot project setup for the local mock-server dev environment.
# Adds: iOS/AppConfiguration.swift to the app target, a "Debug Local" build
# configuration (duplicated from Debug) wired to Config/Debug-Local.xcconfig,
# and a shared "Critical Maps (Local)" scheme that runs under Debug Local.
#
# Idempotent: re-running will not create duplicates.

require 'xcodeproj'
require 'fileutils'

PROJECT_PATH = File.expand_path('../CriticalMaps.xcodeproj', __dir__)
APP_TARGET_NAME = 'Critical Maps'
NEW_CONFIG = 'Debug Local'
SOURCE_CONFIG = 'Debug'

project = Xcodeproj::Project.open(PROJECT_PATH)
app_target = project.targets.find { |t| t.name == APP_TARGET_NAME }
raise "App target not found" unless app_target

# --- 1. Reference the xcconfig files in a "Config" group ---------------------
config_group = project.main_group['Config'] ||
               project.main_group.new_group('Config', 'Config')
xcconfig_ref = config_group.files.find { |f| f.path == 'Debug-Local.xcconfig' } ||
               config_group.new_reference('Debug-Local.xcconfig')
unless config_group.files.any? { |f| f.path == 'Shared.xcconfig' }
  config_group.new_reference('Shared.xcconfig')
end

# --- 2. Add iOS/AppConfiguration.swift to the app target ---------------------
ios_group = project.main_group['iOS']
raise "iOS group not found" unless ios_group
unless ios_group.files.any? { |f| f.display_name == 'AppConfiguration.swift' }
  file_ref = ios_group.new_reference('AppConfiguration.swift')
  app_target.add_file_references([file_ref])
end

# --- 3. Duplicate Debug -> "Debug Local" (project + app target) --------------
def duplicate_config(proj, configurable, source_name, new_name, xcconfig_ref = nil)
  list = configurable.build_configuration_list
  return if list[new_name]
  source = list[source_name]
  raise "Missing source config #{source_name}" unless source
  new_config = proj.new(Xcodeproj::Project::Object::XCBuildConfiguration)
  new_config.name = new_name
  new_config.build_settings = Marshal.load(Marshal.dump(source.build_settings))
  new_config.base_configuration_reference = xcconfig_ref if xcconfig_ref
  list.build_configurations << new_config
end

duplicate_config(project, project, SOURCE_CONFIG, NEW_CONFIG)          # project level
duplicate_config(project, app_target, SOURCE_CONFIG, NEW_CONFIG, xcconfig_ref) # app target

project.save

# --- 4. Create the "Critical Maps (Local)" shared scheme --------------------
# Load from a COPY, not the production scheme: the xcodeproj gem mutates the
# file it was initialized from, so loading the original would corrupt it.
schemes_dir = File.join(PROJECT_PATH, 'xcshareddata', 'xcschemes')
source_scheme_path = File.join(schemes_dir, 'Critical Maps.xcscheme')
new_scheme_path = File.join(schemes_dir, 'Critical Maps (Local).xcscheme')
FileUtils.cp(source_scheme_path, new_scheme_path) unless File.exist?(new_scheme_path)
scheme = Xcodeproj::XCScheme.new(new_scheme_path)
# Run the app against the local server; keep test/archive on their defaults.
scheme.launch_action.build_configuration = NEW_CONFIG
scheme.profile_action.build_configuration = NEW_CONFIG
scheme.analyze_action.build_configuration = NEW_CONFIG
scheme.save_as(PROJECT_PATH, 'Critical Maps (Local)', true)

puts "Done: added '#{NEW_CONFIG}' config + 'Critical Maps (Local)' scheme."
