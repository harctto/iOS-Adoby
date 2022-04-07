//
//  PostViewController.swift
//  Adopby
//
//  Created by Hatto on 7/4/2565 BE.
//

import UIKit
import iOSDropDown
import Alamofire

class PostViewController: UIViewController {
    
    @IBOutlet weak var tfPetName: UITextField!
    @IBOutlet weak var tfPetColor: UITextField!
    @IBOutlet weak var tfPetAge: UITextField!
    @IBOutlet weak var ddSex: DropDown!
    @IBOutlet weak var ddType: DropDown!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfDescription: UITextField!
    @IBOutlet weak var sgDogCat: UISegmentedControl!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnDismiss: UIButton!
    var keepUserUID:String = ""
    var isDismissed: (() -> Void)?
    
    func setupUI() {
        view.backgroundColor = UIColor.init(rgb: 0xFEF8E7)
        tfPetName.layer.cornerRadius = 20
        tfPetColor.layer.cornerRadius = 20
        tfPetAge.layer.cornerRadius = 20
        ddSex.layer.cornerRadius = 20
        ddType.layer.cornerRadius = 20
        tfAddress.layer.cornerRadius = 20
        tfDescription.layer.cornerRadius = 20
        btnPost.layer.cornerRadius = 20
        btnDismiss.layer.cornerRadius = 20
        sgDogCat.frame.size.height = 85
        sgDogCat.contentMode = .scaleAspectFit
        let dogImage = image(
            with: (UIImage(named: "dog.png")),
            scaledTo: CGSize(width: 40, height: 40)
        )
        let catImage = image(
            with: UIImage(named: "cat.png"),
            scaledTo: CGSize(width: 40, height: 40)
        )
        sgDogCat.setImage(dogImage, forSegmentAt: 0)
        sgDogCat.setImage(catImage, forSegmentAt: 1)
    }
    
    @IBAction func setupDogCat(_ sender: Any) {
        switch sgDogCat.selectedSegmentIndex {
        case 0:
            ddType.optionArray = dogType
        case 1:
            ddType.optionArray = catType
        default:
            break
        }
    }
    
    func setupDropdown() {
        ddSex.optionArray = ["เพศผู้","เพศเมีย"]
        ddSex.arrowSize = 12
        ddSex.arrowColor = UIColor.init(rgb: 0x7E6514)
        ddSex.selectedRowColor = UIColor.init(rgb: 0xFBE6A2)
        ddSex.rowBackgroundColor = UIColor.init(rgb: 0xFEF8E7)
        ddSex.didSelect{(selectedText, index, id) in
            self.ddSex.text = selectedText
        }
        //
        ddType.isSearchEnable = true
        ddType.arrowSize = 12
        ddType.arrowColor = UIColor.init(rgb: 0x7E6514)
        ddType.selectedRowColor = UIColor.init(rgb: 0xFBE6A2)
        ddType.rowBackgroundColor = UIColor.init(rgb: 0xFEF8E7)
        ddType.didSelect{(selectedText, index, id) in
            self.ddType.text = selectedText
        }
    }
    @IBAction func btnPost(_ sender: Any) {
        let url = "https://adoby.glitch.me/petposts/\(keepUserUID)"
        let _headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let params : [String:String] = [
            "pet_name":"\(tfPetName.text!)",
            "pet_type":"\(ddType.text!)",
            "pet_color":"\(tfPetColor.text!)",
            "pet_sex":"\(ddSex.text!)",
            "pet_age":"\(tfPetAge.text!)",
            "description":"\(tfDescription.text!)",
            "img_url":""
        ]
        let encoder = URLEncodedFormParameterEncoder(destination: .httpBody)
        
        if (
            self.tfPetName.text != "" &&
            self.ddType.text != "" &&
            self.ddSex.text != "" &&
            self.tfPetAge.text != "" &&
            self.tfDescription.text != "" &&
            self.tfPetColor.text != ""
        ) {
            AF.request(
                url,
                method: .post,
                parameters: params,
                encoder: encoder,
                headers: _headers
            ).responseDecodable(of: [PetShop].self) { response in
                let alert = UIAlertController(
                    title: "ลงทะเบียนสำเร็จ",
                    message: "",
                    preferredStyle: UIAlertController.Style.alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                    self.dismiss(animated: true, completion: {
                        self.isDismissed?()
                    })
                }))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(
                title: "มีบางอย่างผิดพลาด",
                message: "กรุณากรอกข้อมูลให้ครบถ้วน",
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.isDismissed?()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDropdown()
        // Do any additional setup after loading the view.
    }
    
}
