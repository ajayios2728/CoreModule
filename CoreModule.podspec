    Pod::Spec.new do |s|
      s.name             = 'CoreModule'
      s.version          = '1.0.0'
      s.summary          = 'A short description of CoreModule.'
      s.description      = <<-DESC
                           A longer description of CoreModule, providing more details about its functionality and purpose.
                           DESC
      s.homepage         = 'https://github.com/ajayios2728/CoreModule'
      s.license          = { :type => 'MIT', :file => 'LICENSE' }
      s.author           = { 'Ajay' => 'ajay.ios2728@gmail.com' }
      s.source           = { :git => 'https://github.com/ajayios2728/CoreModule.git', :tag => s.version.to_s }
      s.ios.deployment_target = '12.0' # Or your desired minimum iOS version
      s.source_files     = 'CoreModule/Classes/**/*' # Adjust to your framework's source file structure
      s.swift_versions   = ['5.0'] # Specify Swift versions if applicable
      # s.dependency 'Alamofire', '~> 5.4' # Add any external dependencies here
    end