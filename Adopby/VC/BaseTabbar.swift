//
//  BaseTabbar.swift
//  Adopby
//
//  Created by Hatto on 18/3/2565 BE.
//

import UIKit

class BaseTabbar: UITabBarController, UITabBarControllerDelegate {
    
    var userData:[String] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.delegate = self
    }

}
