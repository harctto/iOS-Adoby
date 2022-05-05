//
//  ViewController.swift
//  Adopby
//
//  Created by Hatto on 16/3/2565 BE.
//

import UIKit
import Alamofire
import CometChatPro

class LoginViewController: UIViewController {
    // MARK: - Variable
    @IBOutlet weak var containSignin: UIView!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnSignin: UIButton!
    var keepUserData:[String] = []
    var currentUser : User = User(uid: "", name: "")
    
    // MARK: - Function
    @IBAction func btnLogin(_ sender: Any) {
        guard let url = URL(string: "https://adoby.glitch.me/auth/login") else { return }
        let _headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let params : [String:String] = [
            "username":"\(tfUsername.text!)",
            "password":"\(tfPassword.text!)"
        ]
        let encoder = URLEncodedFormParameterEncoder(destination: .httpBody)
        self.LoadingStart()
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
                switch (response.result) {
                case .success:
                    self.LoadingStop()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.performSegue(withIdentifier: "application", sender: nil)
                    }
                    //
                    //add to chat
                    //
                    self.currentUser = User(uid: self.keepUserData[0], name: self.keepUserData[1])
                    let authKey = "5dcab8f18ef25a578d00667cdbede748b0c85d6d" // Replace with your Auth Key.
                    CometChat.createUser(user: self.currentUser, apiKey: authKey, onSuccess: { (User) in
                          print("User created successfully. \(User.stringValue())")
                      }) { (error) in
                         print("The error is \(String(describing: error?.description))")
                    }
                    //
                    //end add to chat
                    //
                case .failure:
                    self.LoadingStop()
                    let alert = UIAlertController(
                        title: "มีบางอย่างผิดพลาด",
                        message: "กรุณาตรวจสอบชื่อผู้ใช้ หรือ รหัสผ่านอีกครั้ง",
                        preferredStyle: UIAlertController.Style.alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            } else {
                self.LoadingStop()
                let alert = UIAlertController(
                    title: "มีบางอย่างผิดพลาด",
                    message: "กรุณากรอกข้อมูลให้ครบถ้วน",
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
        currentUser = User(uid: "", name: "")
        keepUserData = []
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentUser = User(uid: "", name: "")
        keepUserData = []
    }

    
    // MARK: - Pass Value to BaseTabbar
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "application" {
            let sender = segue.destination as! BaseTabbar
            sender.userData = keepUserData
        }
    }
}
