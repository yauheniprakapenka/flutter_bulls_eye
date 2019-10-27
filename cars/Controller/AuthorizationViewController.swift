//
//  AuthorizationViewController.swift
//  cars
//
//  Created by yauheni prakapenka on 26/10/2019.
//  Copyright © 2019 yauheni prakapenka. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthorizationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var secureCodeTextField: UITextField!
    @IBOutlet weak var leftCarConstraint: NSLayoutConstraint!
    @IBOutlet weak var trafficLightImageView: UIImageView!
    @IBOutlet weak var helloTextStackView: UIStackView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var biometricButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        secureCodeTextField.delegate = self
        
        secureCodeTextField.alpha = 0
        enterButton.alpha = 0
        biometricButton.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        animateCarLeftConstraint()
    }
    
    @IBAction func verifyButtonTapped(_ sender: UIButton) {
        guard let text = secureCodeTextField.text, text == "1111" else  {
            print("Код авторизации НЕ верный")
            secureCodeTextField.shake()
            secureCodeTextField.textColor = .red
            return
        }
        print("Код авторизации верный")
        presentMainVC()
    }
    
    @IBAction func biometricButtonTapped(_ sender: UIButton) {
        authenticationWithTouchID()
    }
    
    // Валидация на 4 символа
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        secureCodeTextField.textColor = .black
        guard let text = secureCodeTextField.text else {
            return true
        }
        
        let newLength = text.count + string.count - range.length
        return newLength < 5
    }
    
    private func animateCarLeftConstraint() {
        UIView.animate(withDuration: 5, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 0.4, options: .curveEaseOut, animations: {
            _ = Timer.scheduledTimer(withTimeInterval: 1.8, repeats: false) { (Timer) in
                self.trafficLightImageView.image = UIImage(named: "Светофор-красный")
                UIView.animate(withDuration: 1.3) {
                    self.secureCodeTextField.alpha = 1
                    self.enterButton.alpha = 1
                }
            }
            
            _ = Timer.scheduledTimer(withTimeInterval: 3.8, repeats: false) { (Timer) in
                UIView.animate(withDuration: 1.3) {
                    self.biometricButton.alpha = 1
                }
            }
            
            self.leftCarConstraint.constant = (UIScreen.main.bounds.width / 2) - 140
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Please use your Passcode"

        var authorizationError: NSError?
        let reason = "Authentication required to access the secure data"

        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authorizationError) {
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, evaluateError in
                if success {
                    print("Авторизация по биометрии успешна")
                    DispatchQueue.main.sync {
                        self.presentMainVC()
                    }
                } else {
                    print("Авторизация по биометрии НЕ успешна")
                    guard let error = evaluateError else { return }
                    print(error)
                }
            }
        } else {
            guard let error = authorizationError else {
                return
            }
            print(error)
        }
    }
    
    private func presentMainVC() {
        
        UIView.animate(withDuration: 4.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
            self.trafficLightImageView.image = UIImage(named: "Светофор-зеленый")
            self.secureCodeTextField.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            self.leftCarConstraint.constant = UIScreen.main.bounds.width + 30
            self.view.layoutIfNeeded()
        }, completion: { (isSuccessful) in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyBoard.instantiateViewController(withIdentifier: "mainViewControllerID")
            self.present(navigationController, animated: true, completion: nil)
        })
    }
    
}
