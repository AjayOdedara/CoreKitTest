#
#  Be sure to run `pod spec lint CoreServicesKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|



  s.name         = "CoreKit"
  s.version      = “1.0.0”
  s.summary      = "CoreServicesKit Web Service Provider”
  s.description  = “CoreServicesKit service that provide Apps to run Web Service and get data with desired models”

  s.homepage     = "http://google.com”
  s.author       = “Dev Team"
  s.license      = "MIT"
  s.platform     = :ios, “10.0”
  s.source       = { :path => 'https://github.com/AjayOdedara/CoreKitTest' }

  s.source_files  = “CoreKit”, "CoreKit/**/*.{h,m,swift}”
  echo "2.3" > .swift-version


  end
