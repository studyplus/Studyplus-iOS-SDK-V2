Pod::Spec.new do |s|
  s.name                  = "StudyplusSDK-V2"
  s.version               = "1.0.9"
  s.summary               = "StudyplusSDK-V2 is Studyplus iOS SDK for Swift"
  s.homepage              = "http://info.studyplus.jp"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.source                = { :git => "https://github.com/studyplus/Studyplus-iOS-SDK-V2.git", :tag => s.version }
  s.source_files          = "StudyplusSDK", "StudyplusSDK/**/*.{swift}"
  s.requires_arc          = true
  s.platform              = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.ios.frameworks        = ['UIKit', 'Foundation']
  s.author                = { "studyplus" => "sutou@studyplus.jp" }
  s.dependency 'KeychainAccess', '3.0.2'
end

