#
# Be sure to run `pod lib lint FastpayMerchantSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "FastpayMerchantSDK"
  s.version          = "1.0.0"
  s.summary          = "FastpayMerchantSDK enables you to integrate Fastpay payment into your application"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  

  s.description      = <<-DESC
  FastpayMerchantSDK enables you to integrate Fastpay payment into your application
                       DESC

  s.homepage         = "https://github.com/anamulht-fsi/FrameworkDistributionTest"
  #s.screenshots      = [ "https://raw.githubusercontent.com/jonkykong/SideMenu/master/etc/SlideOut.gif", "https://raw.githubusercontent.com/jonkykong/SideMenu/master/etc/SlideIn.gif", "https://raw.githubusercontent.com/jonkykong/SideMenu/master/etc/Dissolve.gif", "https://raw.githubusercontent.com/jonkykong/SideMenu/master/etc/InOut.gif" ]
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "jonkykong" => "anamul@newroztech.com" }
  s.source           = { :git => "https://github.com/anamulht-fsi/FrameworkDistributionTest.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'Pod/Classes/**/*'
  # s.resource_bundles = {
  #    'SideMenu' => ['Pod/Assets/*.png']
  #  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
