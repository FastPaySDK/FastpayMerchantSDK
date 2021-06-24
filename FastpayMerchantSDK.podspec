Pod::Spec.new do |s|
  s.name             = 'FastpayMerchantSDK'
  s.version          = '2.0.2'
  s.summary          = 'SDK for interfacing with Fastpay payment processing APIs.'

  s.description      = <<-DESC
Fastpay is quickest, most convenient, and safest mobile wallet for keeping money safe, Shopping, Mobile recharge, Internet recharge, Money transfers and Bill payments. Use FastPay for a cashless, hassle-free experience while shopping, dining, travelling and a lot more.By using Fastpay Merchant SDK you an include FastPay as a payment option for your business. Please follow the integration document to add this SDK into your application.
                       DESC

  s.homepage         = 'https://github.com/FastPaySDK/FastPayiOSSDK'
  s.license          = { :type => 'Apache v2', :file => 'LICENSE' }
  #s.license = 'Apache v2'
  s.author           = { 'Fastpay' => 'services@fast-pay.cash' }
  s.source           = { :git => 'https://github.com/FastPaySDK/FastPayiOSSDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = "5.0"
  s.source_files = 'FastpayMerchantSDK/*'
  s.exclude_files = 'FastpayMerchantSDK/*.plist'

end