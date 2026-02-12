require 'xcodeproj'

project_path = 'Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

file_name = 'GoogleService-Info.plist'
file_path = 'Runner/GoogleService-Info.plist'

# Find the main group
group = project.main_group.find_subpath(File.join('Runner'), true)
group.set_source_tree('SOURCE_ROOT')

# Check if file is already added
file_ref = group.find_file_by_path(file_path)

if file_ref
  puts "#{file_name} already exists in project."
else
  file_ref = group.new_reference(file_path)
  puts "Added #{file_name} reference."
end

# Add to targets
project.targets.each do |target|
  if target.name == 'Runner'
    if target.resources_build_phase.files_references.include?(file_ref)
      puts "File already in #{target.name} resources build phase."
    else
      target.resources_build_phase.add_file_reference(file_ref)
      puts "Added to #{target.name} target."
    end
  end
end

project.save
puts "Project saved."
