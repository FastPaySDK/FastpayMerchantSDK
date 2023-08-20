//
//  StaticTexts.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 16/2/21.
//

import Foundation

#if !Static_Texts

private let English = FPLanguage.English.identifier
private let Arabic = FPLanguage.Arabic.identifier
private let Kurdish = FPLanguage.Kurdish.identifier


//MARK: Translation Starts From Here

let order_id_text = [English: "Order ID:", Arabic: "Order ID:", Kurdish: "Order ID:"]
let pay_via_text = [English: "Pay via", Arabic: "Pay via", Kurdish: "Pay via"]
let mobile_number_text = [English: "Mobile Number", Arabic: "Mobile Number", Kurdish: "Mobile Number"]
let password_text = [English: "Password", Arabic: "Password", Kurdish: "Password"]
let i_accept_text = [English: "I accept the", Arabic: "I accept the", Kurdish: "I accept the"]
let toc_text = [English: "Terms & Condition", Arabic: "Terms & Condition", Kurdish: "Terms & Condition"]
let procceed_to_text = [English: "PROCEED TO PAY", Arabic: "PROCEED TO PAY", Kurdish: "PROCEED TO PAY"]
let or_text = [English: "Or", Arabic: "Or", Kurdish: "Or"]
let generate_qr_text = [English: "Generate QR", Arabic: "Generate QR", Kurdish: "Generate QR"]
let back_text = [English: "Back", Arabic: "Back", Kurdish: "Back"]
let qr_message_text = [English: "Use another mobile or let your friends & family help", Arabic: "Use another mobile or let your friends & family help", Kurdish: "Use another mobile or let your friends & family help"]
let use_login_cred_text = [English: "Use Login Credential", Arabic: "Use Login Credential", Kurdish: "Use Login Credential"]
let something_went_wrong_text = [English: "Something went wrong", Arabic: "Something went wrong", Kurdish: "Something went wrong"]
let retry_text = [English: "Retry", Arabic: "Retry", Kurdish: "Retry"]
let payment_successful_text = [English: "Payment Successful", Arabic: "Payment Successful", Kurdish: "Payment Successful"]
let payment_successful_message_text = [English: "Please wait while we take you back", Arabic: "Please wait while we take you back", Kurdish: "Please wait while we take you back"]
let ok_text = [English: "OK", Arabic: "OK", Kurdish: "OK"]
let no_internet_message_text = [English: "Internet connection appears to be offline", Arabic: "Internet connection appears to be offline", Kurdish: "Internet connection appears to be offline"]
let default_error_message = [English: "Error Occured", Arabic: "Error Occured", Kurdish: "Error Occured"]
let default_success_message = [English: "Successfully done", Arabic: "Successfully done", Kurdish: "Successfully done"]
let initiliazing_text = [English: "Initiating", Arabic: "Initiating", Kurdish: "Initiating"]

#endif
