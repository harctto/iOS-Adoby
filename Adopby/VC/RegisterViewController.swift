//
//  RegisterViewController.swift
//  Adopby
//
//  Created by Hatto on 20/3/2565 BE.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var containerTop: UIView!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var tfFirstname: UITextField!
    @IBOutlet weak var tfSurname: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        let url = "https://adoby.glitch.me/auth/register"
        let _headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let params : [String:String] = [
            "username":"\(tfUsername.text!)",
            "password":"\(tfPassword.text!)",
            "firstname":"\(tfFirstname.text!)",
            "surname":"\(tfSurname.text!)",
            "address":"\(tfAddress.text!)",
            "user_tel":"\(tfPhoneNumber.text!)"
        ]
        let encoder = URLEncodedFormParameterEncoder(destination: .httpBody)
        AF.request(
            url,
            method: .post,
            parameters: params,
            encoder: encoder,
            headers: _headers
        ).responseDecodable(of: Users.self) { response in
            if (
                self.tfUsername.text != "" &&
                self.tfPassword.text != "" &&
                self.tfConfirmPassword.text != "" &&
                self.tfFirstname.text != "" &&
                self.tfSurname.text != "" &&
                self.tfAddress.text != "" &&
                self.tfPhoneNumber.text != ""
            )
            {
                switch (self.tfPassword.text == self.tfConfirmPassword.text) {
                case true:
                    switch(response.result) {
                    case .success:
                        let alert = UIAlertController(
                            title: "ลงทะเบียนสำเร็จ",
                            message: "คุณสามารถกลับไปหน้าแรกเพื่อเข้าใช้แอปพลิเคชั่นได้",
                            preferredStyle: UIAlertController.Style.alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        break
                    case .failure:
                        let alert = UIAlertController(
                            title: "มีบางอย่างผิดพลาด",
                            message: "กรุณาตรวจสอบชื่อผู้ใช้ หรือ รหัสผ่านอีกครั้ง",
                            preferredStyle: UIAlertController.Style.alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        break
                    }
                case false:
                    let alert = UIAlertController(
                        title: "รหัสผ่านไม่ตรงกัน",
                        message: "กรุณาตรวจสอบรหัสผ่านอีกครั้ง",
                        preferredStyle: UIAlertController.Style.alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    break
                }
            }
            else {
                let alert = UIAlertController(
                    title: "โปรดใส่ข้อมูลให้ครบถ้วน",
                    message: "กรุณาใส่ข้อมูลให้ครบถ้วน",
                    preferredStyle: UIAlertController.Style.alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.init(rgb: 0xF7D154)
        containerTop.layer.cornerRadius = 20
        containerTop.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tfUsername.layer.cornerRadius = 20
        tfPassword.layer.cornerRadius = 20
        tfConfirmPassword.layer.cornerRadius = 20
        tfFirstname.layer.cornerRadius = 20
        tfSurname.layer.cornerRadius = 20
        tfAddress.layer.cornerRadius = 20
        tfPhoneNumber.layer.cornerRadius = 20
        btnSubmit.layer.cornerRadius = 20
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfUsername {
            textField.resignFirstResponder()
            tfPassword.becomeFirstResponder()
        }
        else if textField == tfPassword {
            textField.resignFirstResponder()
            tfConfirmPassword.becomeFirstResponder()
        }
        else if textField == tfConfirmPassword {
            textField.resignFirstResponder()
            tfFirstname.becomeFirstResponder()
        }
        else if textField == tfFirstname {
            textField.resignFirstResponder()
            tfSurname.becomeFirstResponder()
        }
        else if textField == tfSurname {
            textField.resignFirstResponder()
            tfAddress.becomeFirstResponder()
        }
        else if textField == tfAddress {
            textField.resignFirstResponder()
            tfPhoneNumber.becomeFirstResponder()
        }
        else if textField == tfPhoneNumber {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func viewDidLoad() {
        setupUI()
        hideKB()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
}
