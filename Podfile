# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Crew' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Crew
  
  pod 'Alamofire', '~> 5.2'
  pod 'ObjectMapper'
  pod 'SnapKit'
  pod 'SDWebImage'
  pod "TTRangeSlider"
  pod 'SwiftRangeSlider'
  pod 'Cosmos'
  pod 'ImageViewer.swift'
  pod 'OTPFieldView'
  pod 'SignaturePad'
  pod 'FSCalendar'
  pod 'DatePickerDialog'
  pod 'NotificationBannerSwift', '~> 3.0.0'
  pod 'SkyFloatingLabelTextField'
  pod 'IQKeyboardManagerSwift'
  pod 'CCBottomRefreshControl'
  
  # AWS frameworks
  pod 'AWSS3'
  pod 'AWSCognito'
  pod 'AWSCore'
  
  #Firebase frameworks
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  
end
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
  
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
  
  xcode_base_version = `xcodebuild -version | grep 'Xcode' | awk '{print $2}' | cut -d . -f 1`

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # For xcode 15+ only
      if config.base_configuration_reference && Integer(xcode_base_version) >= 15
        xcconfig_path = config.base_configuration_reference.real_path
        xcconfig = File.read(xcconfig_path)
        xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
        File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
      end
    end
  end
end
