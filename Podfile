platform :ios, '8.0'

use_frameworks!

target :StudyplusSDK do
    pod 'KeychainAccess', '3.0.2'
end

target :Demo do
    pod 'KeychainAccess', '3.0.2'
end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end
