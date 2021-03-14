//
//  Constant.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 11/2/21.
//

import Foundation
import UIKit

struct K {
    private init(){}
    
    static let IS_DEV_BUILD = false
    static let IS_SERVER_COMMUNICATION_ENCRYPTED = false
    
    struct NotificationKey {
        private init(){}
        
        static let FPMenuOpen = "fpMenuToggleNotificationKey"
        static let transactionCompletedNotification = "FPTransactionCompleted"
    }
    
    enum BaseURL{
        
        case FastPay
        
        var Sandbox: String {
            switch self {
            case .FastPay:
                //return "https://revamp-merchant.fast-pay.cash/api/v1/"
                //return "https://dev-apigw-merchant.fast-pay.cash/api/v1/"
                return "https://staging-apigw-merchant.fast-pay.cash/api/v1/"
            }
        }
        var Production: String {
            switch self {
            case .FastPay:
                return "https://apigw-merchant.fast-pay.cash/api/v1/"
            }
        }
    }
    
    
    struct UserDefaultsKey {
        private init(){}
        
        static let APITokenKey = "api_tokn_key"
        static let UserMobileNo = "user_mobile_number_key"
        static let UserPassword = "alskdf34343faw124324"
        static let ActiveLanguageIndex = "ActiveLanguageIndexKey_key"
        static let FCMToken = "FCMTokenKey"
        static let IntroductionScreenShowFlag = "isPreviousGoForSplash"
        static let BiometricAuthTypeId = "biometricAuthTypeKeyId"
    }
    
    struct UI {
        private init(){}
        
        enum FontStyle {
            case regular
            case medium
            case bold
            case semiBold
            case light
        }
        
        static func appFont(ofSize size: CGFloat, style: FontStyle) -> UIFont{
            
            switch style {
            case .bold: return UIFont.systemFont(ofSize: size, weight: .bold)
            case .light: return UIFont.systemFont(ofSize: size, weight: .light)
            case .regular: return UIFont.systemFont(ofSize: size, weight: .regular)
            case .medium: return UIFont.systemFont(ofSize: size, weight: .medium)
            case .semiBold: return UIFont.systemFont(ofSize: size, weight: .semibold)
            }
        }
        
        static let TabBarMinimumHeight: CGFloat = 80.0
        static let TabBarMinimumHeightIpad: CGFloat = 100.0
        static let StatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        static let MainScreenBounds = UIScreen.main.bounds
        
        static var BottomSafeAreaInsetForNewerIphones: CGFloat {
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                let bottomPadding = window?.safeAreaInsets.bottom
                
                return bottomPadding ?? 0.0
            }else{
                return 0.0
            }
        }
        
        static let PrimaryTintColor = #colorLiteral(red: 0.9882352941, green: 0.1568627451, blue: 0.3803921569, alpha: 1)
        static let AppBackgroundColor = #colorLiteral(red: 0.07219018787, green: 0.07348110527, blue: 0.1315894723, alpha: 1)
        static let DisabledButtonBackgroundColor = #colorLiteral(red: 0.168627451, green: 0.2, blue: 0.368627451, alpha: 1)
        static let AppGreenColor = #colorLiteral(red: 0.01176470588, green: 0.9215686275, blue: 0.6392156863, alpha: 1)
        static let PlacehoderColor = #colorLiteral(red: 0.168627451, green: 0.2, blue: 0.368627451, alpha: 0.3)
    }
    
    struct Messages {
        static let DefaultErrorMessage = default_error_message[FPLanguageHandler.shared.currentLanguage.identifier] ?? "⚠️"
        static let DefaultSuccessMessage = default_success_message[FPLanguageHandler.shared.currentLanguage.identifier] ?? "⚠️"
    }
    
    struct Misc {
        static let baseCountryId = 103
        static let MobileNoLength = 10
        static let CountryCode = "+964"
        static let desiredImageSizeInBytes = 1000*1000
        static let otpLength = 6
    }
}
