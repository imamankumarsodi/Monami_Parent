# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Monami' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Monami

  target 'MonamiTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MonamiUITests' do
    inherit! :search_paths
    # Pods for testing
  end

pod 'IQKeyboardManagerSwift', '5.0.0'
pod 'DatePickerDialog'
pod 'lottie-ios'
pod 'DropDown'
pod 'DatePickerDialog'
pod 'Alamofire', '~> 4.5.0'
pod 'SwiftyJSON'
pod 'ActionSheetPicker-3.0'
pod 'KYDrawerController'
pod 'SDWebImage/WebP'
pod 'RealmSwift'
pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'
pod 'FBSDKShareKit'
pod 'FBSDKPlacesKit'
pod 'FBSDKMessengerShareKit'
pod 'GoogleSignIn'
pod 'SwiftSiriWaveformView'
pod 'RSKPlaceholderTextView'

end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end
