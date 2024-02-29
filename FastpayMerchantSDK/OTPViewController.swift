//
//  OTPViewController.swift
//  FastPayOTP
//
//  Created by Sabbir Nasir on 10/8/23.
//
import Foundation
import UIKit

class OTPViewController: BaseViewController {
    
    var mobileNumber:String
    var password:String
    var message:String
    
    let backButton = UIButton()
    var fastPayImageView = UIImageView()
    
    //for otp field
    let numberOfDigits = 6
    let digitFieldWidth: CGFloat = (UIScreen.main.bounds.width - 90) / 6
    let digitFieldHeight: CGFloat = 60
    let digitFieldSpacing: CGFloat = 10
    let borderColor: UIColor = .red
    let backgroundColor: UIColor = .white
    var digitFields: [UITextField] = []
    
    init(mobileNumber: String, password: String, msg:String, fastPayImageView: UIImageView = UIImageView(), digitFields: [UITextField] = []) {
        self.mobileNumber = mobileNumber
        self.password = password
        self.message = msg
        self.fastPayImageView = fastPayImageView
        self.digitFields = digitFields
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBackButton()
        setImage()
        setupTitle()
        setSubtitle()
        
        //MARK: OTP FIELD
        setupOTPFields()
    }
    
    func setupBackButton() {
//        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.setImageFromBundle(OTPViewController.self, imageName: "backButton", for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.tintColor = .black
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.delegate?.fastPayProcessStatus(with: .CANCEL)
        })
    }
    
    func setImage() {
        fastPayImageView = UIImageView(image: UIImage(named: "fastPayImg"))
        fastPayImageView.contentMode = .scaleAspectFit
        view.addSubview(fastPayImageView)
        
        fastPayImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fastPayImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            fastPayImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            fastPayImageView.widthAnchor.constraint(equalToConstant: 95),
            fastPayImageView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func setupTitle() {
        view.addSubview(lblHeader)
        lblHeader.text = "Confirm Transaction via Email OTP"
        lblHeader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lblHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            lblHeader.topAnchor.constraint(equalTo: fastPayImageView.bottomAnchor, constant: 25)
        ])
        
    }
    
    func setSubtitle(){
        view.addSubview(lblSubtitle)
        lblSubtitle.text = message
        lblSubtitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lblSubtitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            lblSubtitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            lblSubtitle.topAnchor.constraint(equalTo: lblHeader.bottomAnchor, constant: 15)
        ])
    }
    
    
    //MARK: OTP FIELD
    func setupOTPFields() {
        let totalFieldWidth = CGFloat(numberOfDigits) * digitFieldWidth + CGFloat(numberOfDigits - 1) * digitFieldSpacing
        let startX = (view.frame.width - totalFieldWidth) / 2

        
        for index in 0..<numberOfDigits {
            let x = startX + CGFloat(index) * (digitFieldWidth + digitFieldSpacing)
            let digitField = createDigitField(withFrame: CGRect(x: x, y: 0, width: digitFieldWidth, height: digitFieldWidth))
            digitFields.append(digitField)
            view.addSubview(digitField)
            digitField.translatesAutoresizingMaskIntoConstraints = false
            
            if index == 0 {
                NSLayoutConstraint.activate([
                    digitField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    digitField.heightAnchor.constraint(equalToConstant: digitFieldHeight),
                    digitField.widthAnchor.constraint(equalToConstant: digitFieldWidth),
                    digitField.topAnchor.constraint(equalTo: lblSubtitle.bottomAnchor, constant: 60)
                ])
            }else if index == 5{
                NSLayoutConstraint.activate([
                    digitField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    digitField.heightAnchor.constraint(equalToConstant: digitFieldHeight),
                    digitField.widthAnchor.constraint(equalToConstant: digitFieldWidth),
                    digitField.topAnchor.constraint(equalTo: lblSubtitle.bottomAnchor, constant: 60)
                ])
            }else{
                NSLayoutConstraint.activate([
                    digitField.leadingAnchor.constraint(equalTo: digitFields[index - 1].trailingAnchor, constant: 10),
                    digitField.heightAnchor.constraint(equalToConstant: digitFieldHeight),
                    digitField.widthAnchor.constraint(equalToConstant: digitFieldWidth),
                    digitField.topAnchor.constraint(equalTo: lblSubtitle.bottomAnchor, constant: 60)
                    
                ])
            }
 
        }
    }
    
    func createDigitField(withFrame frame: CGRect) -> UITextField {
        let textField = UITextField(frame: frame)
        textField.delegate = self // Set the delegate to 'self'
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.keyboardType = .numberPad
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = borderColor.cgColor
        textField.backgroundColor = backgroundColor
        textField.textColor = UIColor.black
        textField.layer.cornerRadius = 8
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        return textField
    }
    

    @objc func textFieldDidChange(_ textField: UITextField) {
        if let currentIndex = digitFields.firstIndex(of: textField) {
            if let text = textField.text, text.count > 0 {
                
                if text.count == 2 {
                     textField.text?.removeFirst()
                }else if text.count > 2{
                    textField.text = String(text[text.startIndex])
                }
                
                if currentIndex < digitFields.count - 1 {
                    digitFields[currentIndex + 1].becomeFirstResponder()
                } else {
                    textField.resignFirstResponder()
                }
            } else if let text = textField.text, text.isEmpty {
                
                if currentIndex > 0 {
                    digitFields[currentIndex - 1].becomeFirstResponder()
                }
            }
            
            var otp = ""
            for item in digitFields{
                if let digit = item.text?.first{
                    otp += "\(digit)"
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if otp.count == 6{
                    self.executePayment(otp: otp)
                }
            }
        }
    }
    
    
    //MARK: COMPONENTS
    lazy var lblHeader : UILabel = {
        var vw = UILabel()
        vw.translatesAutoresizingMaskIntoConstraints = false
        
        vw.textColor = K.UI.AppYollowColor
        vw.numberOfLines = 1
        vw.font = .systemFont(ofSize: 20)
        return vw
    }()
    
    lazy var lblSubtitle : UILabel = {
        var vw = UILabel()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.textColor = K.UI.AppDarkGreenColor
        vw.font = .systemFont(ofSize: 14)
        vw.numberOfLines = 0
        return vw
    }()
 
}

extension OTPViewController{
    func executePayment(otp:String) {
 
        FPWebServiceHandler.shared.pay(mobileNumber: K.Misc.CountryCode + mobileNumber, password: password, orderId: FPDataHandler.shared.orderId, token: FPDataHandler.shared.initiationData?.token ?? "", shouldShowLoader: true) { (response) in
            
            let failureMsg = response.errors?.joined(separator: "\n") ?? K.Messages.DefaultErrorMessage
            if response.code == 200{
                
                let vc = FPTransactionSuccessViewController()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                
                self.present(vc, animated: true, completion: nil)
                
            }else{
                //self.showDialog(title: nil, message: response.errors?.joined(separator: "\n") ?? K.Messages.DefaultErrorMessage, onDefaultActionButtonTap: nil)
                let vc = FPTransactionFailureViewController()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                vc.msg = failureMsg
                
                self.present(vc, animated: true, completion: nil)
            }
            
        } onFailure: { ( _) in
            //self.showDialog(title: nil, message: K.Messages.DefaultErrorMessage, onDefaultActionButtonTap: nil)
            let vc = FPTransactionFailureViewController()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension OTPViewController {
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count > 1{
            if let pasteString = UIPasteboard.general.string, pasteString.count <= numberOfDigits {
                for (index, char) in pasteString.enumerated() {
                    if index < digitFields.count {
                        digitFields[index].text = String(char)
                    }
                }
            }
        }
        
        return true
    }
}
