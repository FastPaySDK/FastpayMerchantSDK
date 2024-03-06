//
//  SplashViewController.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 23/2/21.
//

import UIKit

class SplashViewController: BaseViewController {
    
    private lazy var fpLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setImageFromBundle(FPAuthViewController.self, imageName: "logoFPSplash-en")
        
        return imageView
    }()
    
    private lazy var initializingTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .hexStringToUIColor(hex: "#000000")
        label.font = K.UI.appFont(ofSize: 14, style: .medium)
        label.textAlignment = .natural
        label.text = initiliazing_text[currentLanguage?.identifier ?? ""]
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .hexStringToUIColor(hex: "#ECF2F5")
        
        view.addSubview(initializingTextLabel)
        NSLayoutConstraint.activate([
            initializingTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            initializingTextLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        ])
        
        view.addSubview(fpLogoImageView)
        NSLayoutConstraint.activate([
            fpLogoImageView.bottomAnchor.constraint(equalTo: initializingTextLabel.topAnchor, constant: -25),
            fpLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        self.startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { (timer) in
            if self.initializingTextLabel.text == initiliazing_text[self.currentLanguage?.identifier ?? ""] ?? "" {
                self.initializingTextLabel.text = "\(initiliazing_text[self.currentLanguage?.identifier ?? ""] ?? "" )."
            }else if self.initializingTextLabel.text == "\(initiliazing_text[self.currentLanguage?.identifier ?? ""] ?? "" )." {
                self.initializingTextLabel.text = "\(initiliazing_text[self.currentLanguage?.identifier ?? ""] ?? "" ).."
            }else if self.initializingTextLabel.text == "\(initiliazing_text[self.currentLanguage?.identifier ?? ""] ?? "" ).." {
                self.initializingTextLabel.text = "\(initiliazing_text[self.currentLanguage?.identifier ?? ""] ?? "" )..."
            }else if self.initializingTextLabel.text == "\(initiliazing_text[self.currentLanguage?.identifier ?? ""] ?? "" )..." {
                self.initializingTextLabel.text = "\(initiliazing_text[self.currentLanguage?.identifier ?? ""] ?? "" )."
            }
        }
    }
    
    private func startTimer() {
        //Timer set at 240 seconds/4 minutes
        GTimer.sharedTimer.startTimer(timeOut: 240)
        GTimer.sharedTimer.isRequestTimeOut = false
    }
}
