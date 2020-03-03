Pod::Spec.new do |s|
  s.name             = 'DriveKitCommonUI'
  s.version          = '1.3.0'
  s.summary          = 'DriveKit Common UI Framework'

  s.description      = 'Common features of all DriveKit UI modules'

  s.homepage         = 'https://docs.drivequant.com'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'DriveQuantPublic' => 'jeremy.bayle@drivequant.com' }
  s.swift_version    = '5.0'
  s.source           = { :git => 'https://github.com/DriveQuantPublic/drivekit-ui-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'DriveKitCommonUI/**/*.swift'
  s.resource = ['DriveKitCommonUI/Graphical/DKImages.xcassets', 'DriveKitCommonUI/Localizable/*']

  s.dependency 'UICircularProgressRing'

  s.info_plist = {
    'CFBundleIdentifier' => 'com.drivequant.drivekit-common-ui'
  }
end