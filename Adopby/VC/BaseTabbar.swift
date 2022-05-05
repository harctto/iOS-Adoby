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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadView()
        view.backgroundColor = .init(rgb: 0xFEF8E7)
        self.selectedIndex = 2
        //updateStatusCometChat
        let currentUser = User(uid: userData[0], name: userData[1])
        CometChat.updateCurrentUserDetails(user: currentUser, onSuccess: { user in
            print("Updated user object",user)
        }, onError: { error in
            print("Update user failed with error: \(String(describing: error?.errorDescription))")
        })
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.delegate = self
    }

}
