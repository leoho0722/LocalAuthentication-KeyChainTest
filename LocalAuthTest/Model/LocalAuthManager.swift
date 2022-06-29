//
//  LocalAuthManager.swift
//  LocalAuthTest
//
//  Created by Leo Ho on 2022/6/28.
//

import Foundation
import LocalAuthentication

class LocalAuthManager {
    
    class func evaluateUserWithBiometricsOrPasscode(reason: String,
                                                    policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics,
                                                    success: @escaping () -> Void,
                                                    failure: @escaping (Error?) -> Void) {
        let context = LAContext()
        
        context.localizedCancelTitle = "Cancel"
                        
        guard context.canEvaluatePolicy(policy, error: nil) else {
            failure(nil)
            return
        }
        
        context.evaluatePolicy(policy, localizedReason: reason) { results, error in
            DispatchQueue.main.async {
                if results {
                    success()
                } else {
                    failure(error)
                }
            }
        }
    }
    
}
