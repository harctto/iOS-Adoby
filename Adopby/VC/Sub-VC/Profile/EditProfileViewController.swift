//
//  EditProfileViewController.swift
//  Adopby
//
//  Created by Hatto on 5/5/2565 BE.
//

import UIKit
import Alamofire
import CometChatPro

class EditProfileViewController: UIViewController {

    //MARK: - Variable
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfFirstname: UITextField!
    @IBOutlet weak var tfSurname: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfTel: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    //var
    var isDismissed: (() -> Void)?
    var keepUser:Users!
    
    //MARK: - setupUI
    func setupUI() {
        viewPopup.layer.cornerRadius = 10
        cornerRadiusSetup(
            tf: [tfUsername,tfFirstname,tfSurname,tfAddress,tfTel],
            btn: [btnSubmit,btnCancel],
            r: 20
        )
        tfUsername.text = keepUser.username
        tfFirstname.text = keepUser.firstname
        tfSurname.text = keepUser.surname
        tfAddress.text = keepUser.address
        tfTel.text = keepUser.userTel
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        guard let url = URL(string: "https://adoby.glitch.me/auth/edit/\(keepUser.uid ?? "")") else { return }
        let _headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let params : [String:String] = [
            "username":"\(tfUsername.text!)",
            "firstname":"\(tfFirstname.text!)",
            "surename":"\(tfSurname.text!)",
            "address":"\(tfAddress.text!)",
            "user_tel":"\(tfTel.text!)"
        ]
        let encoder = URLEncodedFormParameterEncoder(destination: .httpBody)
        AF.request(
            url,
            method: .post,
            parameters: params,
            encoder: encoder,
            headers: _headers
        ).responseDecodable(of: Users.self) { response in
            switch (response.result) {
            case .success:
                //chat
                let currentUser = User(uid: self.keepUser.uid ?? "", name: self.tfUsername.text!)
                CometChat.updateCurrentUserDetails(user: currentUser, onSuccess: { user in
                    print("Updated user object",user)
                }, onError: { error in
                    print("Update user failed with error: \(String(describing: error?.errorDescription))")
                })
                
                //alert
                let alert = UIAlertController(
                    title: "สำเร็จ",
                    message: "แก้ไขข้อมูลส่วนตัวเรียบร้อย",
                    preferredStyle: UIAlertController.Style.alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in 
                    self.dismiss(animated: true, completion: {
                        self.isDismissed?()
                    })
                }))
                self.present(alert, animated: true, completion: nil)
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
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.isDismissed?()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}
