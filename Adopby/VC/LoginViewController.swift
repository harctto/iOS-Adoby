//
//  ViewController.swift
//  Adopby
//
//  Created by Hatto on 16/3/2565 BE.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    // MARK: - Variable
    @IBOutlet weak var containSignin: UIView!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnSignin: UIButton!
    var keepUserData:[String] = []
    
    // MARK: - Function
    @IBAction func btnLogin(_ sender: Any) {
        guard let url = URL(string: "https://adoby.glitch.me/auth/login") else { return }
        let _headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let params : [String:String] = [
            "username":"\(tfUsername.text!)",
            "password":"\(tfPassword.text!)"
        ]
        let encoder = URLEncodedFormParameterEncoder(destination: .httpBody)
        AF.request(
            url,
            method: .post,
            parameters: params,
            encoder: encoder,
            headers: _headers
        ).responseDecodable(of: Users.self) { response in
            if response.value?.uid != nil {
                self.keepUserData = [
                    response.value!.uid ?? "",
                    response.value!.username ?? "",
                    response.value!.firstname ?? "",
                    response.value!.surname ?? "",
                    response.value!.address ?? "",
                    response.value!.userTel ?? ""
                ]
                self.performSegue(withIdentifier: "application", sender: nil)
            } else {
                let alert = UIAlertController(
                    title: "มีบางอย่างผิดพลาด",
                    message: "กรุณาตรวจสอบชื่อผู้ใช้ หรือ รหัสผ่านอีกครั้ง",
                    preferredStyle: UIAlertController.Style.alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.init(rgb: 0xFEF8E7)
        containSignin.backgroundColor = UIColor.init(rgb: 0xF7D154)
        containSignin.layer.cornerRadius = 20
        containSignin.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tfUsername.backgroundColor = UIColor.init(rgb: 0xFBE6A2)
        tfUsername.textColor = UIColor.init(rgb: 0x7E6514)
        tfUsername.layer.cornerRadius = 20
        tfPassword.backgroundColor = UIColor.init(rgb: 0xFBE6A2)
        tfPassword.textColor = UIColor.init(rgb: 0x7E6514)
        tfPassword.layer.cornerRadius = 20
        btnSignin.layer.cornerRadius = 20
        btnSignin.startAnimatingPressActions()
    }
    
    // MARK: - Override
    override func viewDidLoad() {
        setupUI()
        hideKB()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    // MARK: - Pass Value to BaseTabbar
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "application" {
            let sender = segue.destination as! BaseTabbar
            sender.userData = keepUserData
        }
    }
}
