require 'xcodeproj'
require 'fileutils'

module Pod
  class ConfigureCustom
    attr_reader :configurator

    def self.perform(options)
      new(options).perform
    end

    def initialize(options)
      @configurator = options.fetch(:configurator)
    end

    def perform
      clean_files
      rename_files
      replace_variables_in_files
      run_pod_install
      farewell_message
      reinitialize_git_repo
    end

    def clean_files
      FileUtils.mv("./templates/#{configurator.template_name}", './', force: true)

      Dir.glob('*', File::FNM_DOTMATCH).each do |file|
        next if ['.', '..', configurator.template_name].include?(file)
        FileUtils.rm_rf(file)
      end

      FileUtils.cp_r("#{configurator.template_name}/.", '.')
      FileUtils.rm_rf(configurator.template_name)
    end

    def rename_files
      File.rename('POD_NAME', configurator.pod_name)
      File.rename('POD_NAME.xcodeproj', "#{configurator.pod_name}.xcodeproj")
      File.rename('POD_NAME.podspec', "#{configurator.pod_name}.podspec")
    end

    def replace_variables_in_files
      string_replacements = {
        'TODAYS_DATE' => Time.now.strftime("%m/%d/%Y"),
        'POD_NAME' => configurator.pod_name,
        'PROJECT_CREATOR' => configurator.user_name,
        'PROJECT_OWNER' => configurator.organization_name
      }

      Dir.glob('**/**', File::FNM_DOTMATCH).each do |name|
        next if Dir.exists?(name)
        text = File.read(name)
        for find, replace in string_replacements
          text = text.gsub(find, replace)
        end

        File.open(name, "w") { |file| file.puts text }
      end
    end

    def run_pod_install
      puts "\nRunning " + "pod install".magenta + " on your new library."
      puts ""

      system "pod install"
    end

    def reinitialize_git_repo
      `git init`
      `git add -A`
      `git commit -m "Initial commit"`
    end

    def farewell_message
      puts ""

      puts " Ace! you're ready to go!"
      puts " We will start you off by opening your project in Xcode"
      system "open #{configurator.pod_name}.xcworkspace"
      sleep 5
    end
  end
end
