//
//  BaseViewController.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 11/2/21.
//

import UIKit

class BaseViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    private(set) var scrollViewToOverride: UIScrollView?
    private(set) var containerViewToOverride: UIView?
    private(set) var containerViewTopSpaceConstraintToOverride: NSLayoutConstraint?
    private var activeFieldFrame: CGRect?
    private var containerViewOriginalFrame: CGRect!
    private var containerViewTopSpaceConstraintOriginalConstant: CGFloat!
    private(set) var shouldConfigureReturnKeyBasedOnTag: Bool = true
    private(set) var shouldAddToolbarToTextFieldWithSpecialKeyboardType: Bool = true
    private(set) var textFieldToolBarDoneButtonTitle: String = "Done"
    private(set) var textFieldToolBarNextButtonTitle: String = "Next"
    
    let currentLanguage = FPLanguageHandler.shared.currentLanguage
    let dataHandler = FPDataHandler.shared
    let webserviceHandler = FPWebServiceHandler.shared
    
    @objc weak public var delegate: FastPayDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.tintColor = K.UI.PrimaryTintColor
        
        registerForKeyboardNotifications()
        registerRequestTimeoutNotification()
        registerForBackgroundNotifications()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.setTranslatableStaticTexts()
        self.checkIsRequestTimeOut()
    }
    
    private func checkIsRequestTimeOut() {
        if GTimer.sharedTimer.isRequestTimeOut{
            self.dismiss(animated: true, completion: { self.delegate?.fastPayProcessStatus(with: .CANCEL)})
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //self.presentedViewController?.dismiss(animated: true, completion: nil)
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        containerViewOriginalFrame = containerViewToOverride?.frame
        containerViewTopSpaceConstraintOriginalConstant = containerViewTopSpaceConstraintToOverride?.constant
    }
    
    func setTranslatableStaticTexts(){
        
    }
    
    private func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func registerForBackgroundNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    var appDidEnterBackgroundDate:Date?
    @objc func applicationDidEnterBackground(_ notification: NotificationCenter) {
        appDidEnterBackgroundDate = Date()
    }

    @objc func applicationWillEnterForeground(_ notification: NotificationCenter) {
        guard let previousDate = appDidEnterBackgroundDate else { return }
        let calendar = Calendar.current
        let difference = calendar.dateComponents([.second], from: previousDate, to: Date())
        let seconds = difference.second!
        debugPrint("TotalSecondSpended is - \(seconds)")
        GTimer.sharedTimer.reduceSecond(seconds)
    }
    
    
    @objc private func onKeyboardAppear(_ notification: NSNotification) {
        
        if let info = notification.userInfo, let activeFieldFrame = activeFieldFrame {
            
            let rect: CGRect = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let keyboardSize = rect.size
            
            // WITH SCROLLVIEW
            if let scrollView = scrollViewToOverride {
                
                pushUpFor(scrollView: scrollView, activeFieldFrame: activeFieldFrame, keyboardSize: keyboardSize)
                
                //WITH OUT SCROLLVIEW
            }else{
                
                //WITH AUTOLAYOUT CONSTRAINT
                if let containerViewTopSpaceConstraint = containerViewTopSpaceConstraintToOverride{
                    
                    pushUpFor(containerViewTopSpaceConstraint: containerViewTopSpaceConstraint, activeFieldFrame: activeFieldFrame, keyboardSize: keyboardSize)
                    
                    //WITHOUT AUTOLAYOUT CONSTRAINT, FRAME BASED
                }else{
                    
                    if let containerView = containerViewToOverride {
                        
                        pushUpFor(containerView: containerView, activeFieldFrame: activeFieldFrame, keyboardSize: keyboardSize)
                    }
                }
            }
        }
    }
    
    @objc private func onKeyboardDisappear(_ notification: NSNotification) {
        
        // WITH SCROLLVIEW
        if let scrollView = scrollViewToOverride{
            
            scrollView.contentInset = .zero
            scrollView.scrollIndicatorInsets = .zero
            
            //WITHOUT SCROLLVIEW
        }else{
            
            //WITH AUTOLAYOUT CONSTRAINT
            if let containerViewTopSpaceConstraint = containerViewTopSpaceConstraintToOverride{
                
                if containerViewTopSpaceConstraint.constant != containerViewTopSpaceConstraintOriginalConstant{
                    
                    UIView.animate(withDuration: TimeInterval(0.5)) {
                        containerViewTopSpaceConstraint.constant = self.containerViewTopSpaceConstraintOriginalConstant
                    }
                    view.setNeedsUpdateConstraints()
                }
                
                //WITHOUT AUTOLAYOUT CONSTRAINT, FRAME BASED
            }else{
                
                if let containerView = containerViewToOverride{
                    
                    if containerView.frame.origin.y != containerViewOriginalFrame.origin.y{
                        
                        UIView.animate(withDuration: TimeInterval(0.5)) {
                            containerView.frame.origin.y = self.containerViewOriginalFrame.origin.y
                        }
                        view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    private func pushUpFor(scrollView: UIScrollView, activeFieldFrame: CGRect, keyboardSize: CGSize){
        
        var aRect = self.view.bounds;
        aRect.size.height -= keyboardSize.height;
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        
        if !aRect.contains(activeFieldFrame.origin) {
            scrollView.scrollRectToVisible(activeFieldFrame, animated: true)
        }
    }
    
    private func pushUpFor(containerViewTopSpaceConstraint: NSLayoutConstraint, activeFieldFrame: CGRect, keyboardSize: CGSize){
        
        var aRect = self.view.bounds;
        aRect.size.height -= keyboardSize.height;
        
        if !aRect.contains(activeFieldFrame.origin){
            
            if containerViewTopSpaceConstraint.constant == containerViewTopSpaceConstraintOriginalConstant{
                
                UIView.animate(withDuration: TimeInterval(0.5)) {
                    containerViewTopSpaceConstraint.constant -= keyboardSize.height
                }
                view.setNeedsUpdateConstraints()
            }
        }
    }
    
    private func pushUpFor(containerView: UIView, activeFieldFrame: CGRect, keyboardSize: CGSize){
        
        var aRect = containerView.bounds;
        aRect.size.height -= keyboardSize.height
        
        //if rect.intersects(activeFieldFrame){
        if !aRect.contains(activeFieldFrame.origin){
            
            if containerView.frame.origin.y == containerViewOriginalFrame.origin.y {
                
                UIView.animate(withDuration: TimeInterval(0.5)) {
                    containerView.frame.origin.y -= keyboardSize.height
                }
                view.layoutIfNeeded()
            }
        }
    }
    
    
    private func determineReturnKeyTypeForResponder(withTag tag: Int) -> UIReturnKeyType {
        
        let nextTag = tag + 1
        let nextResponder = view.viewWithTag(nextTag)
        
        if nextResponder != nil {
            return .next
        } else {
            return .done
        }
    }
    
    private func addBasicActionToReturnKeyOfTextField(withTag tag: Int) -> Bool{
        
        let nextTag = tag + 1
        let nextResponder = view.viewWithTag(nextTag)
        
        if nextResponder != nil {
            
            nextResponder?.becomeFirstResponder()
            return true
        } else {
            
            view.endEditing(true)
            return false
        }
    }
    
    private func addToolBar(toTextField textField: UITextField){
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = #colorLiteral(red: 0.168627451, green: 0.2, blue: 0.368627451, alpha: 1)
        
        let doneButton = UIBarButtonItem(title: (determineReturnKeyTypeForResponder(withTag: textField.tag) == .next) ? textFieldToolBarNextButtonTitle : textFieldToolBarDoneButtonTitle, style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneOrNextPressed(_:)))
        doneButton.tag = textField.tag
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
    }
    
    @objc private func doneOrNextPressed(_ button: UIBarButtonItem){
        
        _ = addBasicActionToReturnKeyOfTextField(withTag: button.tag)
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        activeFieldFrame = textField.frame
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapDetected(_:))))
        
        if shouldConfigureReturnKeyBasedOnTag && textField.returnKeyType == .default {
            textField.returnKeyType = determineReturnKeyTypeForResponder(withTag: textField.tag)
        }
        
        var shouldHaveToolBar: Bool
        if #available(iOS 10.0, *) {
            shouldHaveToolBar = shouldAddToolbarToTextFieldWithSpecialKeyboardType && (textField.keyboardType == .numberPad || textField.keyboardType == .phonePad || textField.keyboardType == .decimalPad || textField.keyboardType == .asciiCapableNumberPad) || (textField.inputView is UIPickerView)
        } else {
            shouldHaveToolBar = shouldAddToolbarToTextFieldWithSpecialKeyboardType && (textField.keyboardType == .numberPad || textField.keyboardType == .phonePad || textField.keyboardType == .decimalPad) || (textField.inputView is UIPickerView)
        }
        
        if shouldHaveToolBar {
            addToolBar(toTextField: textField)
        }else{
            textField.inputAccessoryView = nil
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //checkInputs()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        activeFieldFrame = textView.frame
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapDetected(_:))))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if shouldConfigureReturnKeyBasedOnTag{
            
            return addBasicActionToReturnKeyOfTextField(withTag: textField.tag)
        }
        
        return true
    }
    
    
    
    @objc private func tapDetected(_ tapRecognizer: UITapGestureRecognizer?) {
        
        view.endEditing(true)
        if let tapRecognizer = tapRecognizer {
            view.removeGestureRecognizer(tapRecognizer)
        }
    }
    
    
    
    
    @objc func checkInputs(){
        
    }
    
    func showLoader(){
        Loader.shared.startAnimation()
    }
    
    func hideLoader(){
        Loader.shared.stopAnimation()
    }
    
    func showDialog(title: String?, message: String, defaultActionButtonTitle: String = ok_text[FPLanguageHandler.shared.currentLanguage.identifier] ?? "OK", onDefaultActionButtonTap defaultButtonAction: (()->())?){
        let alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: defaultActionButtonTitle, style: .default, handler: { action in
            if let defaultButtonAction = defaultButtonAction{
                defaultButtonAction()
            }
        }))
        
        alert.view.tintColor = view.tintColor
        self.present(alert, animated: true, completion: nil)
    }
    
    func formatMobileNumberEscapingSpecialChar(_ mobileNumber: String?) -> String {
        var mobileNumber = mobileNumber
        //mobileNumber = mobileNumber?.replacingOccurrences(of: "(", with: "")
        //mobileNumber = mobileNumber?.replacingOccurrences(of: ")", with: "")
        mobileNumber = mobileNumber?.replacingOccurrences(of: " ", with: "")
        //mobileNumber = mobileNumber?.replacingOccurrences(of: "-", with: "")
        //mobileNumber = mobileNumber?.replacingOccurrences(of: "+", with: "")
        
        return mobileNumber ?? ""
                
//        let length = mobileNumber?.count ?? 0
//        if length > 10 {
//            mobileNumber = (mobileNumber as NSString?)?.substring(from: length - 10)
//            //print("\(mobileNumber ?? "")")
//        }
//
//        return mobileNumber ?? ""
    }
    
    func getMobileNoLengthEscapingSpecialChar(_ mobileNumber: String?) -> Int {
        var mobileNumber = mobileNumber
        mobileNumber = mobileNumber?.replacingOccurrences(of: "(", with: "")
        mobileNumber = mobileNumber?.replacingOccurrences(of: ")", with: "")
        mobileNumber = mobileNumber?.replacingOccurrences(of: " ", with: "")
        mobileNumber = mobileNumber?.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber?.replacingOccurrences(of: "+", with: "")
        
        let length = mobileNumber?.count ?? 0
        
        return length
    }
    
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: GTimer.timerName, object: nil)
    }
    
    //MARK: - Request Timeout Notification
    private func registerRequestTimeoutNotification() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(requestTimeOut),
                         name: GTimer.timerName, object: nil)
    }

    @objc private func requestTimeOut() {
        self.dismiss(animated: true, completion: {self.delegate?.fastPayProcessStatus(with: .CANCEL)})
    }
    
}

