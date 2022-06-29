//
//  MainViewController.swift
//  LocalAuthTest
//
//  Created by Leo Ho on 2022/6/28.
//

import UIKit
import LocalAuthentication

class MainViewController: UIViewController {

    @IBOutlet weak var localAuthenticationButton: UIButton!
    @IBOutlet weak var saveKeyChainButton: UIButton!
    @IBOutlet weak var getKeyChainButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func localAuthenticationBtnClicked(_ sender: UIButton) {
        LocalAuthManager.evaluateUserWithBiometricsOrPasscode(reason: "Local Authentication Test") {
            print("Success")
        } failure: { error in
            if let error = error {
                print("Failed, Error: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func saveKeyChainBtnClicked(_ sender: UIButton) {
        Alert.showAlertWith(title: "輸入要儲存的帳號密碼", message: nil, confirmTitle: "儲存", cancelTitle: "取消", vc: self) { accountTextField in
            accountTextField.placeholder = "請輸入要儲存到 KeyChain 的帳號"
            accountTextField.keyboardType = .emailAddress
        } textFieldSet2: { passwordTextField in
            passwordTextField.placeholder = "請輸入要儲存到 KeyChain 的密碼"
            passwordTextField.keyboardType = .asciiCapable
        } confirm: { accTextField, pwdTextField in
            do {
                guard let passwordToData = pwdTextField.text?.data(using: .utf8) else { return }
                try KeyChainManager.saveToKeyChain(service: "leoho.com", account: accTextField.text!, password: passwordToData)
            } catch {
                print("KeyChain Save Error: \(error.localizedDescription)")
            }
        } cancel: {
            print("關閉 Alert")
        }
    }
    
    @IBAction func getKeyChainBtnClicked(_ sender: UIButton) {
        Alert.showAlertWith(title: "輸入要取得的帳號密碼", message: nil, confirmTitle: "確認", cancelTitle: "取消", vc: self) { accountTextField in
            accountTextField.keyboardType = .emailAddress
            accountTextField.placeholder = "請輸入要從 KeyChain 取得密碼的帳號"
        } confirm: { textField in
            guard let results = KeyChainManager.getFromKeyChain(service: "leoho.com", account: textField.text!) else {
                print("Failed to read Password From KeyChain")
                return
            }
            let password = String(decoding: results, as: UTF8.self)
            print("KeyChain Get Password: \(password)")
            Alert.showAlertWith(title: "查詢結果", message: "查詢帳號：\(textField.text!)\n查詢密碼：\(password)", confirmTitle: "確認", cancelTitle: "取消", vc: self, confirm: nil, cancel: nil)
        } cancel: {
            print("關閉 Alert")
        }
    }

}
