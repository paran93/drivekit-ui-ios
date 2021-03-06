Pod::Spec.new do |s|
  s.name             = 'DriveKitPermissionsUtilsUI'
  s.version          = '1.5'
  s.summary          = 'DriveKit Permissions Utils UI Framework'

  s.description      = 'DriveKit Permissions Utils features: Management of permissions (access to Location or Activity data for instance) to guarantee that a trip can be recorded in the best conditions.'

  s.homepage         = 'https://docs.drivequant.com'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'DriveQuantPublic' => 'jeremy.bayle@drivequant.com' }
  s.swift_version    = '5.0'
  s.source           = { :git => 'https://github.com/DriveQuantPublic/drivekit-ui-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'DriveKitPermissionsUtilsUI/**/*.swift'
  s.resource = ['DriveKitPermissionsUtilsUI/PermissionsUtils.xcassets', 'DriveKitPermissionsUtilsUI/Localizable/*', 'DriveKitPermissionsUtilsUI/**/*.xib']

  s.dependency 'DriveKitCommonUI', s.version.to_s
  s.dependency 'DriveKitCore'

  s.info_plist = {
    'CFBundleIdentifier' => 'com.drivequant.drivekit-permissions-utils-ui'
  }
end
