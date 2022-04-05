# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Zeno' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Zeno
  # Add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'
  
  # For Analytics without IDFA collection capability, use this pod instead
  # pod ‘Firebase/AnalyticsWithoutAdIdSupport’
  
  # Add the pods for any other Firebase products you want to use in your app
  # For example, to use Firebase Authentication and Cloud Firestore
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Crashlytics'

  pod "BSImagePicker", "~> 3.1"
  pod 'NVActivityIndicatorView'
  pod 'Toast-Swift'
  pod 'lottie-ios'
  pod 'PopupDialog', '~> 1.1'
  pod 'SJSegmentedScrollView'
  pod "SwiftyCam"
  pod 'IQKeyboardManagerSwift'
  pod 'FTPopOverMenu_Swift', '~> 0.1.4'
  pod 'AssetsPickerViewController', '~> 2.0'
  pod 'GrowingTextView', '0.7.2'
  pod 'Plot3d'
  pod 'ImageViewer.swift', '~> 3.0'
  pod 'Planet'
  pod 'MaterialComponents/TextFields'
  pod 'FSCalendar'
  pod 'MBRadioCheckboxButton'
  pod 'JJFloatingActionButton'
  pod 'SwiftCSVExport', :git => 'https://github.com/vigneshuvi/SwiftCSVExport.git', :tag => '2.6.0'
  pod 'libxlsxwriter'
  
  pod 'MDFInternationalization'
  pod 'MXSegmentedPager'
  
  pod 'NewPopMenu', '~> 2.0'

  post_install do |installer|
  installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
  end
  end
  end
  
end
