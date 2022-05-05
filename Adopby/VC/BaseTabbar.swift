//
//  BaseTabbar.swift
//  Adopby
//
//  Created by Hatto on 18/3/2565 BE.
//

import UIKit
import CometChatPro

class BaseTabbar: UITabBarController, UITabBarControllerDelegate {
    
    public var userData:[String] = []
    let authKey = "5dcab8f18ef25a578d00667cdbede748b0c85d6d"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadView()
        view.backgroundColor = .init(rgb: 0xFEF8E7)
        
        //updateStatusCometChat
        CometChat.login(UID: userData[0], apiKey: authKey, onSuccess: { (user) in
            print("Login successfull: " + user.stringValue())
            CometChat.updateCurrentUserDetails(user: user, onSuccess: { user in
                print("Updated user object",user)
            }, onError: { error in
                print("Update user failed with error: \(String(describing: error?.errorDescription))")
            })
        }) { (error) in
            print("Login failed with error" + error.errorDescription)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.delegate = self
    }

}
