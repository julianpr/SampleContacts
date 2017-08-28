source 'https://github.com/CocoaPods/Specs'

platform :ios, '10.0'

project 'SampleContacts/SampleContacts.xcodeproj'

use_frameworks!

inhibit_all_warnings!

def all_pods
    pod 'Networking', '~> 3'
    pod 'AERecord'
    pod 'AECoreDataUI'
    pod 'Kingfisher', '~> 3.0'
end

target "SampleContacts" do
    all_pods
end


target "SampleContactsTests" do
    all_pods
end

target "SampleContactsUITests" do
    all_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

