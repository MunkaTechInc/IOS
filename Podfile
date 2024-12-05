# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

target 'Munka' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  use_frameworks!
  pod 'SwiftDefaults'
 #  pod 'SVProgressHUD'
  pod 'IQKeyboardManagerSwift'
  pod 'SDWebImage'
  pod 'GoogleSignIn', '~> 5.0.2'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'FBSDKLoginKit'
  pod 'Alamofire'
# pod 'SKActivityIndicatorView'
  pod 'Toaster'
  pod 'FBSDKCoreKit'
  pod 'BRYXBanner'
  pod 'PasswordTextField'
  pod 'SCLAlertView'
  pod 'BetterSegmentedControl'
  pod 'RSLoadingView'
  pod 'Stripe'
  pod 'Socket.IO-Client-Swift', '~> 13.0.0'
  pod 'JSQMessagesViewController'
  pod 'JTAppleCalendar'
  pod 'Charts'
  
#  pod 'Instructions'#, '~> 2.3.0'
 pod 'GLWalkthrough'
  
#  pod 'PayPal-iOS-SDK'
  
#  pod 'Braintree', '~> 4.35.0'
#  pod 'BraintreeDropIn'
#  pod 'Braintree/PayPal'
  # Pods for Munka
  pod 'MessageKit'
 

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 13.0
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end
