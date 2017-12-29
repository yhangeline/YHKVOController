#
#  Be sure to run `pod spec lint YHKVOController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|



  s.name         = "YHKVOController"
  s.version      = "0.0.1"
  s.summary      = "create by yh"

  s.description  = "一句话使用KVO，使用完无需自己移除KVO"

  s.homepage     = "https://github.com/yhangeline/YHKVOController"

  s.license      = { :type => 'MIT', :file => 'LICENSE' } 


  s.author             = { "恋渊" => "331385243@qq.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/yhangeline/YHKVOController.git",:tag=>s.version.to_s}

  s.source_files  = "YHKVOController/YHKVOController/*.{h,m}"
 




end
