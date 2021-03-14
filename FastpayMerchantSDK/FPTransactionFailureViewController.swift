//
//  FPTransactionFailureViewController.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 15/2/21.
//

import UIKit

class FPTransactionFailureViewController: BaseViewController {
    
    private lazy var failureIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setImageFromBundle(FPTransactionFailureViewController.self, imageName: "trxFailureIcon")
        
        return imageView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .hexStringToUIColor(hex: "#636696")
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = K.UI.appFont(ofSize: 18, style: .medium)
        label.text = something_went_wrong_text[currentLanguage?.identifier ?? ""]
        
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.hexStringToUIColor(hex: "#2892D7"), for: .normal)
        button.titleLabel?.font = K.UI.appFont(ofSize: 12, style: .bold)
        button.setTitle("       \(retry_text[currentLanguage?.identifier ?? ""] ?? "")      ", for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.hexStringToUIColor(hex: "#2892D7").cgColor
        button.layer.cornerRadius = 16
        
        button.addTarget(self, action: #selector(retryTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var mainContainerView: UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.clipsToBounds = true
        
        uiview.addSubview(failureIconImageView)
        NSLayoutConstraint.activate([
            failureIconImageView.centerXAnchor.constraint(equalTo: uiview.centerXAnchor),
            failureIconImageView.centerYAnchor.constraint(equalTo: uiview.centerYAnchor)
        ])
        
        uiview.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: uiview.leadingAnchor, constant: 28),
            messageLabel.topAnchor.constraint(equalTo: failureIconImageView.bottomAnchor, constant: 32),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: uiview.trailingAnchor, constant: -28),
            messageLabel.centerXAnchor.constraint(equalTo: uiview.centerXAnchor),
        ])
        
        uiview.addSubview(retryButton)
        NSLayoutConstraint.activate([
            retryButton.leadingAnchor.constraint(greaterThanOrEqualTo: uiview.leadingAnchor, constant: 28),
            retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 12),
            retryButton.trailingAnchor.constraint(lessThanOrEqualTo: uiview.trailingAnchor, constant: -28),
            retryButton.bottomAnchor.constraint(equalTo: uiview.bottomAnchor, constant: -20),
            retryButton.centerXAnchor.constraint(equalTo: uiview.centerXAnchor)
        ])
        
        return uiview
    }()
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(mainContainerView)
        NSLayoutConstraint.activate([
            mainContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mainContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        return scrollView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(mainScrollView)
        NSLayoutConstraint.activate([
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    
    @objc private func retryTapped(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
