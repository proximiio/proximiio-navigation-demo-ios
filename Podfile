source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/proximiio/proximiio-specs.git'
platform :ios, '13.0'

use_frameworks!
inhibit_all_warnings!

target 'Demo' do
  #pod 'ProximiioMapbox', '5.1.11'

  #pod 'ProximiioMapbox'
  pod 'ProximiioProcessor'

  pod 'ProximiioMapbox', :git => 'https://github.com/proximiio/proximiio-mapbox-ios-pod.git', :branch => 'maplibre'
  #pod 'ProximiioProcessor', :git => 'https://github.com/proximiio/ProximiioProcessorPod.git', :tag => '0.1.16'

#  pod 'Proximiio', :path => '~/Repositories/Proximiio/proximiio-ios-sdk/'
#  pod 'ProximiioMapbox', :path => '~/Repositories/Proximiio/proximiio-mapbox-ios/'
  #pod 'ProximiioProcessor', :path => '~/Repositories/Proximiio/ProximiioProcessor/'

  pod 'Alamofire'
  pod 'Eureka'
  pod 'Hex', '~> 6.1.0'
  pod 'SnapKit', '~> 5.0.0'
  pod 'Closures', '~> 0.6'
  pod 'IQKeyboardManagerSwift', '~> 6.4.1'
  pod 'CheckboxButton', :git => 'https://github.com/matteocrippa/CheckboxButton.git'
  pod 'LicensePlist', '~> 2.5.8'
  pod 'TapticEngine', :git => 'https://github.com/matteocrippa/TapticEngine.git'

  pod 'Kingfisher'
  pod 'DKCarouselView', :git => 'https://github.com/matteocrippa/DKCarouselView.git'
  pod 'DropDown'
  pod 'ActionPicker'
  pod 'PopupDialog', '~> 1.1'
  pod 'AlignedCollectionViewFlowLayout', :git => 'https://github.com/matteocrippa/AlignedCollectionViewFlowLayout.git'
  pod 'SwiftLint'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] =  `uname -m`
          config.build_settings['SWIFT_VERSION'] = '5.3'
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
          config.build_settings['ENABLE_BITCODE'] = 'NO'
          config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
          config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        end
    end
end
