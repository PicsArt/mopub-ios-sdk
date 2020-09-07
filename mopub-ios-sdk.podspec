Pod::Spec.new do |spec|
  spec.name             = 'mopub-ios-sdk'
  spec.module_name      = 'MoPub'
  spec.version          = '5.13.1-pa3'
  spec.license          = { :type => 'New BSD', :file => 'LICENSE' }
  spec.homepage         = 'https://github.com/mopub/mopub-ios-sdk'
  spec.authors          = { 'MoPub' => 'support@mopub.com' }
  spec.summary          = 'The Official MoPub Client SDK allows developers to easily monetize their apps by showing banner, interstitial, and native ads.'
  spec.description      = <<-DESC
                            MoPub is a hosted ad serving solution built specifically for mobile publishers.\n
                            Grow your mobile advertising business with powerful ad management, optimization \n
                            and reporting capabilities, and earn revenue by connecting to the world's largest \n
                            mobile ad exchange. \n\n
                            To learn more or sign up for an account, go to http://www.mopub.com. \n
                          DESC
  spec.social_media_url = 'http://twitter.com/mopub'
  spec.source           = { :git => 'https://github.com/mopub/mopub-ios-sdk.git', :tag => '5.13.1' }
  spec.requires_arc     = true
  spec.ios.deployment_target = '10.0'
  spec.frameworks       = [
                            'AVFoundation',
                            'AVKit',
                            'CoreGraphics',
                            'CoreLocation',
                            'CoreMedia',
                            'CoreTelephony',
                            'Foundation',
                            'MediaPlayer',
                            'QuartzCore',
                            'SystemConfiguration',
                            'UIKit',
                            'SafariServices'
                          ]
  spec.weak_frameworks  = [
                            'AdSupport',
                            'StoreKit',
                            'WebKit'
                          ]
  spec.default_subspecs = 'MoPubSDK'

  spec.subspec 'MoPubSDK' do |sdk|
    sdk.dependency              'mopub-ios-sdk/Core'
    sdk.dependency              'mopub-ios-sdk/NativeAds'
  end

  spec.subspec 'Core' do |core|
    core.source_files         = 'MoPubSDK/**/*.{h,m}'
    core.resource_bundles     = {'MoPubResources' => ['MoPubSDK/Resources/**/*', 'MoPubSDK/**/*.{nib,xib}']}
    core.exclude_files        = ['MoPubSDK/NativeAds', 'MoPubSDK/NativeVideo']
  end

  spec.subspec 'NativeAds' do |native|
    native.dependency             'mopub-ios-sdk/Core'
    native.source_files         = ['MoPubSDK/NativeAds/**/*.{h,m}', 'MoPubSDK/NativeVideo/**/*.{h,m}']
  end
end

