//
//  LanguageHandler.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 11/2/21.
//

import Foundation
import UIKit

protocol FPLanguageDelegate {
    func languageDidChange(to language: FPLanguage)
}

//enum Language{
//    
//    case English
//    case Arabic
//    case Kurdish
//    
//    init(index: Int){
//        switch index {
//        case 0:
//            self = .English
//        case 1:
//            self = .Arabic
//        case 2:
//            self = .Kurdish
//        default:
//            self = .Kurdish
//        }
//    }
//    
//    var index: Int{
//        switch self {
//        case .English:
//            return 0
//        case .Arabic:
//            return 1
//        case .Kurdish:
//            return 2
//        }
//    }
//    
//    var identifier: String{
//        switch self {
//        case .English:
//            return "en"
//        case .Arabic:
//            return "ar"
//        case .Kurdish:
//            return "ku"
//        }
//    }
//    
//    var localeIdentifier: String{
//        switch self {
//        case .English:
//            return "en"
//        case .Arabic:
//            return "ar_IQ"
//        case .Kurdish:
//            return "ckb_IQ"
//        }
//    }
//}

class FPLanguageHandler {
    
    static let shared = FPLanguageHandler()
    private init(){}
    
    var delegate: FPLanguageDelegate?
    
    var currentLanguage: FPLanguage!{
        didSet{
            if currentLanguage == .English{
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            }else if (currentLanguage == .Arabic || currentLanguage == .Kurdish){
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        }
    }
    
    func configureForCurrentLanguage(_ completion: (()->())?){
        
        self.setSemanticForCurrentLanguage()
    }
    
    func setSemanticForCurrentLanguage(){
        
        
    }
    
}
