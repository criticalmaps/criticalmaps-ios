source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.3'

project 'CriticalMaps.xcodeproj'

target 'CriticalMaps' do
	pod 'NSString-Hashes'
	pod 'SDWebImage'
	pod 'Appirater'
end

target 'CriticalMapsTests' do
    pod 'NSString-Hashes'
end

post_install do |pi|
    pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
        end
    end
end
