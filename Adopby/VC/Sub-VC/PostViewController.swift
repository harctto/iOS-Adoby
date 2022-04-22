//
//  PostViewController.swift
//  Adopby
//
//  Created by Hatto on 7/4/2565 BE.
//

import UIKit
import DropDown
import Alamofire

class PostViewController: UIViewController {
    
    @IBOutlet weak var tfPetName: UITextField!
    @IBOutlet weak var tfPetColor: UITextField!
    
    @IBOutlet weak var btnPetAgeM: UIButton!
    @IBOutlet weak var btnPetAgeY: UIButton!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfDescription: UITextField!
    @IBOutlet weak var sgDogCat: UISegmentedControl!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var ddBtnSex: UIButton!
    @IBOutlet weak var ddBtnType: UIButton!
    var keepUserUID:String = ""
    let ddAgeY = DropDown()
    let ddAgeM = DropDown()
    let ddSex = DropDown()
    let ddType = DropDown()
    var isDismissed: (() -> Void)?
    
    func setupUI() {
        view.backgroundColor = UIColor.init(rgb: 0xFEF8E7)
        tfPetName.layer.cornerRadius = 20
        tfPetColor.layer.cornerRadius = 20
        btnPetAgeY.layer.cornerRadius = 20
        btnPetAgeM.layer.cornerRadius = 20
        tfAddress.layer.cornerRadius = 20
        tfDescription.layer.cornerRadius = 20
        btnPost.layer.cornerRadius = 20
        btnDismiss.layer.cornerRadius = 20
        ddBtnSex.layer.cornerRadius = 20
        ddBtnType.layer.cornerRadius = 20
        btnPost.startAnimatingPressActions()
        btnDismiss.startAnimatingPressActions()
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
            ddType.dataSource = dogType
            ddBtnType.isUserInteractionEnabled = true
            ddBtnType.setTitle("พันธุ์", for: .normal)
        case 1:
            ddType.dataSource = catType
            ddBtnType.isUserInteractionEnabled = true
            ddBtnType.setTitle("พันธุ์", for: .normal)
        default:
            ddBtnType.setTitle("กรุณาเลือกสุนัข หรือ แมว", for: .normal)
        }
    }

    
    @IBAction func handleTapDdSex(_ sender: Any) {
        ddSex.show()
    }
    
    @IBAction func handleTapDdType(_ sender: Any) {
        ddType.show()
    }
    
    @IBAction func handleTapDdAgeY(_ sender: Any) {
        ddAgeY.show()
    }
    
    @IBAction func handleTapDdAgeM(_ sender: Any) {
        ddAgeM.show()
    }
    
    func appearranceDropDown() {
        DropDown.appearance().setupCornerRadius(20)
        DropDown.appearance().textFont = UIFont(name: "Prompt-Regular", size: 16)!
        DropDown.appearance().backgroundColor = UIColor.init(rgb: 0xFBE6A2)
        DropDown.appearance().textColor = UIColor.init(rgb: 0x7E6514)
        DropDown.appearance().selectedTextColor = UIColor.init(rgb: 0xFBE6A2)
        DropDown.appearance().selectionBackgroundColor = UIColor.init(rgb: 0x7E6514)
    }
    
    func adjustDropdown( dd: DropDown, view: UIButton ) {
        dd.anchorView = view
        dd.direction = .bottom
        dd.dismissMode = .automatic
        dd.selectionAction = { index, title in
            view.setTitle(title, for: .normal)
        }
    }
    
    func setupDropdown() {
        //
        ddSex.dataSource = sex
        ddAgeY.dataSource = ageY
        ddAgeM.dataSource = ageM
        //
        adjustDropdown(dd: ddAgeY, view: btnPetAgeY)
        adjustDropdown(dd: ddAgeM, view: btnPetAgeM)
        adjustDropdown(dd: ddSex, view: ddBtnSex)
        adjustDropdown(dd: ddType, view: ddBtnType)
    }
    
    @IBAction func btnPost(_ sender: Any) {
        let url = "https://adoby.glitch.me/petposts/\(keepUserUID)"
        let _headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let params : [String:String] = [
            "pet_name":"\(tfPetName.text!)",
            "pet_type":"\(ddBtnType.currentTitle ?? "")",
            "pet_color":"\(tfPetColor.text!)",
            "pet_sex":"\(ddBtnSex.currentTitle ?? "")",
            "pet_age":"\(btnPetAgeY.currentTitle ?? "") ปี \(btnPetAgeM.currentTitle ?? "") ด",
            "pet_address":"\(tfAddress.text!)",
            "description":"\(tfDescription.text!)",
            "img_url":""
        ]
        let encoder = URLEncodedFormParameterEncoder(destination: .httpBody)
        
        if (
            self.tfPetName.text != "" &&
            self.ddBtnType.currentTitle ?? "" != "" &&
            self.ddBtnSex.currentTitle ?? "" != "" &&
            self.btnPetAgeY.currentTitle ?? "" != "" &&
            self.btnPetAgeM.currentTitle ?? "" != "" &&
            self.tfAddress.text != "" &&
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
        appearranceDropDown()
        setupUI()
        setupDropdown()
        hideKB()
        // Do any additional setup after loading the view.
    }
    
}
