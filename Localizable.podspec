#
# Be sure to run `pod lib lint Localizable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Localizable"
  s.version          = "0.1.0"
  s.summary          = "Localizable.io SDK, manage your Localizable strings online"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
Localizable.io is a SaaS for you to manage your localizable strings without the need
to submit your app to the AppStore on every change
                       DESC

  s.homepage         = "https://github.com/Localizable/Localizable"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Ivan Bruel" => "ivan.bruel@gmail.com" }
  s.source           = { :git => "https://github.com/Localizable/Localizable.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ivanbruel'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.requires_arc = true
  #s.preserve_paths = "run"

  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files  = "Pod/*.swift"
  end

  s.subspec "RxSwift" do |ss|
    ss.source_files = "Source/RxSwift/*.swift"
    ss.dependency "RxSwift", "~> 2.1"
  end
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
