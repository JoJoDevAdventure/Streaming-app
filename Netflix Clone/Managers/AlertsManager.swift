//
//  AlertsManager.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 13/04/2022.
//

import Foundation
import UIKit

class AlertsManager {
    
    static let shared = AlertsManager()
    
    func verificationAlert(with viewController : UIViewController, sure to : String, completion : @escaping (Bool) -> Void ){
        let alertController = UIAlertController(title: "Verification", message: "Are you sure \(to)" , preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }
        let confirm = UIAlertAction(title: "Confirm", style: .destructive) { _ in
            completion(true)
        }
        alertController.addAction(cancel)
        alertController.addAction(confirm)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func errorAlert(with viewController: UIViewController, error : String) {
        let alertController = UIAlertController(title: "", message: "\(error)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK.", style: .default, handler: nil)
        alertController.addAction(ok)
        viewController.present(alertController, animated: true)
    }
}
