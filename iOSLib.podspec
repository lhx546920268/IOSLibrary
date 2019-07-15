#
#  Be sure to run `pod spec lint iOSLib.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "iOSLib"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of iOSLib."

  spec.description  = <<-DESC
                        这是一个描述
                   DESC

  spec.homepage     = "http://EXAMPLE/iOSLib"
  spec.license      = "MIT"

  spec.author             = "luohaixiong"

  spec.platform     = :ios, "9.0"

spec.source = { :git => "https://github.com/lhx546920268/IOSLibrary.git", :tag => "v#{spec.version}" }
  spec.source_files  = "IOSLibrary/**/*.{h,m}"

end
