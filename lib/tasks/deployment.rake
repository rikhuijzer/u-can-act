# frozen_string_literal: true

namespace :deployment do
  # Run with
  # be rake "deployment:create_project[project_name]"
  desc 'Create project'
  task :create_project, [:project_name] => [] do |_, args| # doesn't need environment
    @args = args
    puts "Creating project '#{@args[:project_name]}' - started"

    def create_env_local_file
      puts 'creating .env.local file...'
      File.open(File.join(Rails.root, '.env.local'), 'w') do |f|
        f.puts "PROJECT_NAME:      #{@args[:project_name]}"
        f.puts "POSTGRES_DATABASE: #{@args[:project_name]}"
        f.puts "MONGO_DATABASE:    #{@args[:project_name]}"
      end
    end

    def create_project_directory
      puts "creating projects/#{@args[:project_name]} directory..."
      source_dir = File.join(Rails.root, 'projects', 'new')
      target_dir = File.join(Rails.root, 'projects', @args[:project_name])
      FileUtils.copy_entry source_dir, target_dir
    end

    if @args[:project_name].blank?
      puts 'ERROR: syntax: bundle exec rake "deployment:create_project[project_name]"'
      exit(1)
    end

    create_env_local_file
    create_project_directory

    puts "Creating project '#{@args[:project_name]}' - done"
    puts "\nYou should now type:\nbundle exec rake db:setup"
  end
end
