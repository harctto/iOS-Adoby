//
//  HomeViewController.swift
//  Adopby
//
//  Created by Hatto on 18/3/2565 BE.
//

import UIKit

class HomeViewController: UIViewController {
    var currentUsername:String = ""
    
    @IBOutlet weak var lbUsername: UILabel!
    
    func setupUI() {
        view.backgroundColor = UIColor.init(rgb: 0xFEF8E7)
    }
    
    override func viewDidLoad() {
        let valueTabbar = tabBarController as! BaseTabbar
        currentUsername = String(describing: valueTabbar.userData[1])
        lbUsername.text = currentUsername
        
        setupUI()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
