Pod::Spec.new do |s|
  s.name             = 'POD_NAME'
  s.version          = '0.1.0'
  s.summary          = 'A short description of POD_NAME.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/PROJECT_CREATOR/POD_NAME'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PROJECT_CREATOR' => 'PROJECT_OWNER' }
  s.source           = { :git => 'https://github.com/PROJECT_CREATOR/POD_NAME.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'POD_NAME/Classes/**/*.{swift}'
end
