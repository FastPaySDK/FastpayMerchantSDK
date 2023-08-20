//
//  Util.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 10/2/21.
//

import Foundation
import UIKit
import SystemConfiguration


class Util{
    
    private init(){}
    
    static func heightConforming16By9Ratio(forWidth width: CGFloat) -> CGFloat{
        return width * (9/16)
    }
    
    static func widthConforming16By9Ratio(forHeight height: CGFloat) -> CGFloat{
        return height * (16/9)
    }
    
    
    static func getFormattedDateString(inputDateString: String, inputDateFormat: String, outputDateFormat: String) -> String?{
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = inputDateFormat//"yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.dateFormat = outputDateFormat//"EEEE, MMM dd hh:mm a"
        
        if let date = dateFormatterInput.date(from: inputDateString) {
            return (dateFormatterOutput.string(from: date))
        } else {
            return nil
        }
    }
    
    static func showDialogOnKeyWindow(title: String, message: String, style: UIAlertController.Style = .alert, onOkTap: (()->())?){
        /*let alert = UIAlertController(title: title , message: message, preferredStyle: style)
        alert.addAction(UIAlertAction(title: "app_common_ok"~, style: .default, handler: { action in
            if let onOkayTap = onOkTap{
                onOkayTap()
            }
        }))
        
        alert.view.tintColor = K.UI.PrimaryTintColor
        
        if let mainNav = UserSettings.shared.mainNav{
            mainNav.present(alert, animated: true, completion: nil)
        }else{
            if let presentedViewController = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController{
                presentedViewController.present(alert, animated: true, completion: nil)
            }else{
                UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(alert, animated: true, completion: nil)
            }
        }*/
    }
    
    
    static func showDialog(title: String, message: String, onOkTap: (()->())?){
        /*let alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            if let onOkayTap = onOkTap{
                onOkayTap()
            }
        }))
        
        alert.view.tintColor = K.UI.PrimaryTintColor
        UserSettings.shared.mainNav?.present(alert, animated: true, completion: nil)*/
    }
    
    class func getDateGiveDayMonthYear(dateString: String)->(year: String, month: String,day: String){
        
        var year   = ""
        var month  = ""
        var day    = ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else {
            return (year,month,day)
        }
        
        formatter.dateFormat = "yyyy"
        year = formatter.string(from: date)
        formatter.dateFormat = "MM"
        month = formatter.string(from: date)
        formatter.dateFormat = "dd"
        day = formatter.string(from: date)
        //print(year, month, day) // 2018 12 24
        
        return (year,month,day)
        
    }
    
    class func getDateAndTimeFromDate(dateString: String)->(date: String, time: String){
        
        var dateStr  = ""
        var timeStr  = ""
        
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd MMMM yyyy HH:mm a"
        guard let date = formatter.date(from: dateString) else {
            return (dateStr,timeStr)
        }
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        formatter.dateFormat = "dd MMMM yyyy"
        dateStr = formatter.string(from: date)
        formatter.dateFormat = "HH:mm a"
        timeStr = formatter.string(from: date)
        
        
        return (dateStr,timeStr)
        
    }
    
    static func beautifyMobileNumber(_ number: String) -> String{
        
        var number = number
        
        if number.hasPrefix(K.Misc.CountryCode){
            number = number.replacingOccurrences(of: K.Misc.CountryCode, with: "")
        }
        
        if number.count != 10{
            return number
        }
        
        return String(format: "%@ %@ %@", String(number[number.startIndex..<number.index(number.startIndex, offsetBy: 3)]),
                      String(number[number.index(number.startIndex, offsetBy: 3)..<number.index(number.startIndex, offsetBy: 6)]),
                      String(number[number.index(number.startIndex, offsetBy: 6)..<number.index(number.startIndex, offsetBy: 10)]))
    }
    
    static func compresseImage(_ originalImage: UIImage) -> Data?{
        
        let desiredSize = K.Misc.desiredImageSizeInBytes
        let originalSize = originalImage.jpegData(compressionQuality: 1.0)?.count ?? 0
        
        //print("original size: \(originalSize)")
        
        //        let bcf = ByteCountFormatter()
        //        bcf.allowedUnits = [.useMB]
        //        bcf.countStyle = .file
        //        let string = bcf.string(fromByteCount: Int64(originalSize))
        //        print("original size in MB: \(string)")
        
        if originalSize <= desiredSize{
            return originalImage.jpegData(compressionQuality: 1.0)
        }
        
        let compressionQuality = ((100/originalSize) * desiredSize)/100
        
        let compressedData = originalImage.jpegData(compressionQuality: CGFloat(compressionQuality))
        
        //print("compressed size: \(compressedData?.count ?? 0)")
        
        return compressedData
        
    }
    
    
    static func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        
        if rootVC?.presentedViewController != nil {
            if (rootVC?.presentedViewController is UINavigationController) {
                let navigationController = rootVC?.presentedViewController as? UINavigationController
                return navigationController?.viewControllers.last
            }
            return getVisibleViewController(rootVC?.presentedViewController)
        }
        return nil
    }
    
    static func formattedAmountString(amountString: String?) -> String?{
        
        if let amount = amountString, let amountInt = Int(amount){
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.locale = Locale(identifier: "en_US")
            numberFormatter.groupingSeparator = ","
            numberFormatter.decimalSeparator = "."
            
            return numberFormatter.string(from: NSNumber(value: amountInt))
        }
        
        return nil
    }
    
    static func playWithAmount(textField: UITextField, string: String){
        
        if let selectedRange = textField.selectedTextRange {

            let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
            var typedText = textField.text ?? ""
            typedText.insert(contentsOf: string, at: typedText.index(typedText.startIndex, offsetBy: cursorPosition))

            //print("\(cursorPosition)")
            
            if let formattedAmount = Util.formattedAmountString(amountString: typedText.filter("0123456789.".contains)){
                
                textField.text = formattedAmount + " IQD"
                if let selectedRange = textField.selectedTextRange {
                    if let newPosition = textField.position(from: selectedRange.start, offset: -" IQD".count) {
                        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
                    }
                }
            }
            
        }
    }
    
    static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                
                SCNetworkReachabilityCreateWithAddress(nil, $0)
                
            }
            
        }) else {
            
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}


@objc extension UIImageView{
    func setImageFromBundle(_ callerClass: AnyClass, imageName: String){
        self.image = UIImage(named: imageName, in: Bundle(for: callerClass), compatibleWith: nil)
    }
}

@objc extension UIButton{
    func setImageFromBundle(_ callerClass: AnyClass, imageName: String, for state: UIControl.State){
        self.setImage(UIImage(named: imageName, in: Bundle(for: callerClass), compatibleWith: nil), for: state)
    }
}

@objc extension UIImage{
    static func imageFromBundle(_ callerClass: AnyClass, imageName: String) -> UIImage? {
        return UIImage(named: imageName, in: Bundle(for: callerClass), compatibleWith: nil)
    }
}

@objc public enum FPCurrency: Int{
    case IQD = 0
    
    func code() -> String{
        switch self{
        case .IQD:
            return "IQD"
        }
    }
    
    init(code: String){
        switch code {
        case "IQD":
            self = .IQD
        default:
            self = .IQD
        }
    }
}

@objc public enum FPEnvironment: Int{
    case Sandbox
    case Production
    case Development
}

@objc public enum FPLanguage: Int{
    
    case English
    case Arabic
    case Kurdish
    
    init(index: Int){
        switch index {
        case 0:
            self = .English
        case 1:
            self = .Arabic
        case 2:
            self = .Kurdish
        default:
            self = .Kurdish
        }
    }
    
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
    
    var identifier: String{
        switch self {
        case .English:
            return "en"
        case .Arabic:
            return "ar"
        case .Kurdish:
            return "ku"
        }
    }
    
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
}


private let imageCache = NSCache<NSString, UIImage>()
extension UIImageView{
    
    func setImageFromURl(imageUrl: String, cacheEnabled: Bool){
        
        self.image = nil
        if(cacheEnabled){
            if let cachedImage = imageCache.object(forKey: NSString(string: imageUrl)) {
                self.image = cachedImage
                return
            }
        }
        
        if let url = URL(string: imageUrl) {
            self.backgroundColor = .init(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 0.6)
            //            self.backgroundColor = SSLComUIHandler.sharedInstance.colorStore.primary_color
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    //print("ERROR LOADING IMAGES FROM URL: \(error?.localizedDescription ?? "unknown error")")
                    DispatchQueue.main.async {
                        //                        self.backgroundColor = nil
                        self.image = nil
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            if(cacheEnabled){
                                imageCache.setObject(downloadedImage, forKey: NSString(string: imageUrl))
                            }
                            self.backgroundColor = nil
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
        
    }
}


extension String{
    
    func isValidString() -> Bool{
        if (self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
            return false
        }else{
            return true
        }
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}


extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}


extension UIColor {
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIView {
    
    // Workaround for the UIStackView bug where setting hidden to true with animation
    // mulptiple times requires setting hidden to false multiple times to show the view.
    //https://stackoverflow.com/a/41665706/6030980
    public func workaround_nonRepeatingSetHidden(hidden: Bool) {
        if self.isHidden != hidden {
            self.isHidden = hidden
        }
    }
}

extension UIButton{
    
    func disable(){
        self.isEnabled = false
        self.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.2, blue: 0.368627451, alpha: 1)
        self.setTitleColor(.white, for: .normal)
    }
    
    func enable(){
        self.isEnabled = true
        self.backgroundColor = K.UI.PrimaryTintColor
        self.setTitleColor(.white, for: .normal)
    }
    
    func roundedRightTopButton(){
        let maskPath1 = (FPLanguageHandler.shared.currentLanguage == .English) ? UIBezierPath(roundedRect: bounds,
                                                                                                   byRoundingCorners: [.topRight],
                                                                                                   cornerRadii: CGSize(width: 10, height: 10)) : UIBezierPath(roundedRect: bounds,
                                                                                                                                                              byRoundingCorners: [.topLeft],
                                                                                                                                                              cornerRadii: CGSize(width: 10, height: 10))
        
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func roundedLeftTopButton(){
        let maskPath1 = (FPLanguageHandler.shared.currentLanguage == .English) ? UIBezierPath(roundedRect: bounds,
                                                                                                   byRoundingCorners: [.topLeft],
                                                                                                   cornerRadii: CGSize(width: 10, height: 10)) : UIBezierPath(roundedRect: bounds,
                                                                                                                                                              byRoundingCorners: [.topRight],
                                                                                                                                                              cornerRadii: CGSize(width: 10, height: 10))
        
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func roundedTop2CornerButton(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    
}

extension UITextField{
    
    func text() -> String{
        return self.text ?? ""
    }
    
    func addLeftView(_ imageView: UIImageView, for mode: UITextField.ViewMode){
        
        imageView.sizeToFit()
        let leftView = UIView(frame: imageView.bounds)
        leftView.backgroundColor = .clear
        leftView.frame.size.width += 10
        leftView.addSubview(imageView)
        imageView.center = leftView.center
        
        self.leftView = leftView
        self.leftViewMode = .always
        
    }
    
    func addRightView(_ imageView: UIImageView, for mode: UITextField.ViewMode){
        
        imageView.sizeToFit()
        let rightView = UIView(frame: imageView.bounds)
        rightView.backgroundColor = .clear
        rightView.frame.size.width += 10
        rightView.addSubview(imageView)
        imageView.center = rightView.center
        
        self.rightView = rightView
        self.rightViewMode = .always
        
    }
    
    func addLeftView(_ button: UIButton, for mode: UITextField.ViewMode){
        
        button.sizeToFit()
        let leftView = UIView(frame: button.bounds)
        leftView.backgroundColor = .clear
        leftView.frame.size.width += 10
        leftView.addSubview(button)
        button.center = leftView.center
        
        self.leftView = leftView
        self.leftViewMode = .always
        
    }
    
    func addRightView(_ button: UIButton, for mode: UITextField.ViewMode){
        
        button.sizeToFit()
        let rightView = UIView(frame: button.bounds)
        rightView.backgroundColor = .clear
        rightView.frame.size.width += 10
        rightView.addSubview(button)
        button.center = rightView.center
        
        self.rightView = rightView
        self.rightViewMode = .always
        
    }
    
    func addLeftView(_ label: UILabel, for mode: UITextField.ViewMode){
        
        label.sizeToFit()
        let leftView = UIView(frame: label.bounds)
        leftView.backgroundColor = .clear
        leftView.frame.size.width += 10
        leftView.addSubview(label)
        label.center = leftView.center
        
        self.leftView = leftView
        self.leftViewMode = .always
        
    }
    
    func addRightView(_ label: UILabel, for mode: UITextField.ViewMode){
        
        label.sizeToFit()
        let rightView = UIView(frame: label.bounds)
        rightView.backgroundColor = .clear
        rightView.frame.size.width += 10
        rightView.addSubview(label)
        label.center = rightView.center
        
        self.rightView = rightView
        self.rightViewMode = .always
        
    }
    
}



extension UITextField {
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        if FPLanguageHandler.shared.currentLanguage != .English {
//            self.semanticContentAttribute = .forceRightToLeft
//            if self.textAlignment != .center{
//                self.textAlignment = .right
//            }
//        }else{
//            self.semanticContentAttribute = .forceLeftToRight
//            if self.textAlignment != .center{
//                self.textAlignment = .left
//            }
//        }
//    }
}

protocol OTPTextFieldDelegate{
    func textFieldDidDelete(_ textField: OTPTextField)
}


class OTPTextField: UITextField{
    
    var otpDelegate: OTPTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        otpDelegate?.textFieldDidDelete(self)
    }
}


protocol FormattedAmountTextFieldDelegate{
    func textFieldDidDelete(_ textField: FormattedAmountTextField)
}

class FormattedAmountTextField: UITextField{
    
    var amountTFDelegate: FormattedAmountTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        amountTFDelegate?.textFieldDidDelete(self)
    }
}

extension CGRect {
    /// Returns a `Bool` indicating whether the rectangle has any value that is `NaN`.
    func isNaN()  -> Bool {
        return origin.x.isNaN || origin.y.isNaN || width.isNaN || height.isNaN
    }
}



extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}

extension Array where Element: NSCopying {
    func copy() -> [Element] {
        return self.map { $0.copy() as! Element }
    }
}



extension UIImage {
    
    func paintOver(with color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let renderedImage = renderer.image { _ in
            color.set()
            self.withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderedImage
    }
}

extension UIView {

    //https://stackoverflow.com/questions/30696307/how-to-convert-a-uiview-to-an-image
    //https://www.hackingwithswift.com/example-code/media/how-to-render-a-uiview-to-a-uiimage
    
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                //layer.render(in: rendererContext.cgContext)
                self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}

@IBDesignable class FPImageView: UIImageView {
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI Setup
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView() {
        
        if FPLanguageHandler.shared.currentLanguage == .English{
            
        }else if FPLanguageHandler.shared.currentLanguage == .Arabic{
            self.image = arabicImage
        }else if FPLanguageHandler.shared.currentLanguage == .Kurdish{
            self.image = kurdishImage
        }
    }
    
    @IBInspectable var arabicImage: UIImage? = nil{
        didSet{
            if FPLanguageHandler.shared.currentLanguage == .Arabic{
                self.image = arabicImage
            }
        }
    }
    
    @IBInspectable var kurdishImage: UIImage? = nil{
        didSet{
            if FPLanguageHandler.shared.currentLanguage == .Kurdish{
                self.image = kurdishImage
            }
        }
    }
}
