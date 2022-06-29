//
//  Alert.swift
//  LocalAuthTest
//
//  Created by Leo Ho on 2022/6/29.
//

import UIKit

class Alert {
    
    class func showAlertWith(title: String?, message: String?, confirmTitle: String, cancelTitle: String, vc: UIViewController, confirm: (() -> Void)?, cancel: (() -> Void)?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { action in
                confirm?()
            }
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { action in
                cancel?()
            }
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func showAlertWith(title: String?, message: String?, confirmTitle: String, cancelTitle: String, vc: UIViewController, textFieldSet: @escaping ((UITextField) -> Void), confirm: ((UITextField) -> Void)?, cancel: (() -> Void)?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addTextField { textField in
                textFieldSet(textField)
            }
            let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { (action) -> Void in
                let textfield = (alertController.textFields?.first)! as UITextField
                confirm?(textfield)
            }
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { action in
                cancel?()
            }
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func showAlertWith(title: String?, message: String?, confirmTitle: String, cancelTitle: String, vc: UIViewController, textFieldSet: @escaping ((UITextField) -> Void), textFieldSet2: @escaping ((UITextField) -> Void) , confirm: ((UITextField, UITextField) -> Void)?, cancel: (() -> Void)?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addTextField { textField in
                textFieldSet(textField)
            }
            alertController.addTextField { textField2 in
                textFieldSet2(textField2)
            }
            let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { (action) -> Void in
                let textfield = (alertController.textFields?.first)! as UITextField
                let textfield2 = (alertController.textFields?.last)! as UITextField
                confirm?(textfield, textfield2)
            }
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { action in
                cancel?()
            }
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    
}
