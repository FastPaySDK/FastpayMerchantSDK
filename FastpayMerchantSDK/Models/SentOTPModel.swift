//
//  SentOTPModel.swift
//  FastPaySdk
//
//  Created by Ainul Kazi on 10/8/23.
//

import Foundation


class SentOTPModel : Codable {
    let code: Int?
    let message: String?
    let errors: [String]?
    
    init(code: Int?, messages: String?, errors: [String]?) {
        self.code = code
        self.message = messages
        self.errors = errors
    }
}
