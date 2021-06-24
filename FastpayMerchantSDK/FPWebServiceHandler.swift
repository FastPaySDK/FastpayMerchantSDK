//
//  FPWebServiceHandler.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 15/2/21.
//

import Foundation

class FPWebServiceHandler{
    
    static let shared = FPWebServiceHandler()
    private init(){}
    
    var currentEnvironment: FPEnvironment!
    
    lazy var baseUrl: String = {
        switch currentEnvironment{
        case .Sandbox:
            return "https://staging-apigw-merchant.fast-pay.cash/api/v1/"
        case .Production:
            return "https://apigw-merchant.fast-pay.cash/api/v1/"
        default:
            return ""
        }
    }()
    
    enum RequestMethod: String{
        case get = "GET"
        case post = "POST"
    }
    
    private func makeRequest(endPoint: String, method: RequestMethod, parameters: [String: Any?]?, onCompletion: @escaping (Data) -> Void, onFailure: @escaping (Error?) -> Void, shouldShowLoader: Bool, onConnectionFailure: (() -> ())? = nil){
        
        if Util.isConnectedToNetwork(){
            
            var apiUrl = baseUrl + endPoint
            
            if let parameters = parameters, method == .get{
                apiUrl += "?\(parameters.percentEscaped())"
            }
            
            guard let url = URL(string: apiUrl) else{
                onFailure(nil)
                return
            }
            
            var urlRequest = URLRequest(url: url)
            
            if let parameters = parameters, method == .post{
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
                    urlRequest.httpBody = jsonData
                }catch{
                    onFailure(error)
                }
            }
            
            urlRequest.httpMethod = method.rawValue
            
            let session = URLSession.shared
            
            if shouldShowLoader{
                DispatchQueue.main.async {
                    Loader.shared.startAnimation()
                }
            }
            
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.addValue(FPLanguageHandler.shared.currentLanguage.identifier, forHTTPHeaderField: "Accept-Language")
            
            session.dataTask(with: urlRequest) { (data, response, error) in
                
                if shouldShowLoader{
                    DispatchQueue.main.async {
                        Loader.shared.stopAnimation()
                    }
                }
                
                guard (response as? HTTPURLResponse)?.statusCode != 401 else{
                    DispatchQueue.main.async {
                        self.handleNotAunthenticated()
                        Loader.shared.stopAnimation()
                    }
                    return
                }
                
                guard error == nil else{
                    onFailure(error)
                    return
                }
                
                guard let data = data else{
                    onFailure(nil)
                    return
                }
                
                //print("\n\(apiUrl) with parameters: \(parameters) response: \(String.init(data: data, encoding: .utf8)!)\n")
                onCompletion(data)
                
            }.resume()
            
        }else{
            if let onConnectionFailure = onConnectionFailure{
                onConnectionFailure()
            }else{
                handleNoNetwork()
            }
        }
    }
    
    func initiate(storeId: String, storePassword: String, amount: Int, orderId: String, currency: FPCurrency, shouldShowLoader: Bool, onSuccess: @escaping (_ response: InitiationResponseModel) -> Void, onFailure: @escaping (Error?) -> Void, onConnectionFailure: (() -> ())? = nil){
        
        makeRequest(endPoint: "public/sdk/payment/initiation", method: .post, parameters: ["storeId": storeId, "storePassword": storePassword, "billAmount": amount, "orderId": orderId, "currency": currency.code()], onCompletion: { (data) in
            
            do{
                let response = try JSONDecoder().decode(InitiationResponseModel.self, from: data)
                DispatchQueue.main.async {
                    onSuccess(response)
                }
            }catch {
                DispatchQueue.main.async {
                    onFailure(error)
                }
            }
            
            
        }, onFailure: { (error) in
            onFailure(error)
        }, shouldShowLoader: shouldShowLoader, onConnectionFailure: {
            onConnectionFailure?()
        })
    }
    
    func pay(mobileNumber: String, password: String, orderId: String, token: String, shouldShowLoader: Bool, onSuccess: @escaping (_ response: PayWithCredentialsResponseModel) -> Void, onFailure: @escaping (Error?) -> Void, onConnectionFailure: (() -> ())? = nil){
        
        makeRequest(endPoint: "public/sdk/payment/pay", method: .post, parameters: ["orderId": orderId, "token": token, "mobileNumber": mobileNumber, "password": password], onCompletion: { (data) in
            
            do{
                let response = try JSONDecoder().decode(PayWithCredentialsResponseModel.self, from: data)
                DispatchQueue.main.async {
                    onSuccess(response)
                }
            }catch {
                DispatchQueue.main.async {
                    onFailure(error)
                }
            }
            
            
        }, onFailure: { (error) in
            onFailure(error)
        }, shouldShowLoader: shouldShowLoader, onConnectionFailure: {
            onConnectionFailure?()
        })
    }
    
    func validate(orderId: String, storeId: String, storePassword: String, shouldShowLoader: Bool, onSuccess: @escaping(_ response: ValidatePaymentResponseModel) -> Void, onFailure: @escaping (Error?) -> Void, onConnectionFailure: (() -> ())? = nil){
        
        makeRequest(endPoint: "public/sdk/payment/validate", method: .post, parameters: ["orderId": orderId, "storeId": storeId, "storePassword": storePassword], onCompletion: { (data) in
            
            do{
                let response = try JSONDecoder().decode(ValidatePaymentResponseModel.self, from: data)
                DispatchQueue.main.async {
                    onSuccess(response)
                }
            }catch {
                DispatchQueue.main.async {
                    onFailure(error)
                }
            }
            
            
        }, onFailure: { (error) in
            onFailure(error)
        }, shouldShowLoader: shouldShowLoader, onConnectionFailure: {
            onConnectionFailure?()
        })
    }
    
    private func handleNoNetwork(){
        
    }
    
    private func handleNotAunthenticated(){
        
    }
}

private extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}

private extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
