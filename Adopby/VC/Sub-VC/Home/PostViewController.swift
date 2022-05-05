//
//  PostViewController.swift
//  Adopby
//
//  Created by Hatto on 7/4/2565 BE.
//

import UIKit
import DropDown
import Alamofire
import FirebaseStorage

class PostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    // MARK: - Variable
    //Outlet
    @IBOutlet weak var tfPetName: UITextField!
    @IBOutlet weak var tfPetColor: UITextField!
    @IBOutlet weak var btnPetAgeM: UIButton!
    @IBOutlet weak var btnPetAgeY: UIButton!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var tfDescription: UITextField!
    @IBOutlet weak var sgDogCat: UISegmentedControl!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var ddBtnSex: UIButton!
    @IBOutlet weak var ddBtnType: UIButton!
    @IBOutlet weak var btnImageAdd: UIButton!
    @IBOutlet weak var imgShow: UIImageView!
    @IBOutlet weak var btnImageDelete: UIButton!
    //variable
    var keepUserUID:String = ""
    let ddAgeY = DropDown()
    let ddAgeM = DropDown()
    let ddSex = DropDown()
    let ddType = DropDown()
    let ddAddress = DropDown()
    var isDismissed: (() -> Void)?
    var storage = Storage.storage().reference()
    var imageUrl:String = ""
    var imageName:String = ""
    // MARK: - setupUI
    func setupUI() {
        view.backgroundColor = UIColor.init(rgb: 0xFEF8E7)
        tfPetName.layer.cornerRadius = 20
        tfPetColor.layer.cornerRadius = 20
        btnPetAgeY.layer.cornerRadius = 20
        btnPetAgeM.layer.cornerRadius = 20
        btnAddress.layer.cornerRadius = 20
        tfDescription.layer.cornerRadius = 20
        btnPost.layer.cornerRadius = 20
        btnDismiss.layer.cornerRadius = 20
        ddBtnSex.layer.cornerRadius = 20
        ddBtnType.layer.cornerRadius = 20
        btnImageAdd.layer.cornerRadius = 20
        btnPost.startAnimatingPressActions()
        btnDismiss.startAnimatingPressActions()
        btnImageAdd.startAnimatingPressActions()
        btnImageDelete.startAnimatingPressActions()
        btnPetAgeM.startAnimatingPressActions()
        btnPetAgeY.startAnimatingPressActions()
        sgDogCat.frame.size.height = 85
        sgDogCat.contentMode = .scaleAspectFit
        imgShow.layer.masksToBounds = true
        imgShow.layer.cornerRadius = 20
        let dogImage = image(
            with: (UIImage(named: "dog-1.png")),
            scaledTo: CGSize(width: 40, height: 40)
        )
        let catImage = image(
            with: UIImage(named: "cat-1.png"),
            scaledTo: CGSize(width: 40, height: 40)
        )
        sgDogCat.setImage(dogImage, forSegmentAt: 0)
        sgDogCat.setImage(catImage, forSegmentAt: 1)
    }
    // MARK: - function
    @IBAction func setupDogCat(_ sender: Any) {
        switch sgDogCat.selectedSegmentIndex {
        case 0:
            ddBtnType.isUserInteractionEnabled = true
            ddType.dataSource = dogType
            ddBtnType.isEnabled = true
            ddBtnType.setTitle("พันธุ์", for: .normal)
        case 1:
            ddBtnType.isUserInteractionEnabled = true
            ddType.dataSource = catType
            ddBtnType.isEnabled = true
            ddBtnType.setTitle("พันธุ์", for: .normal)
        default:
            ddBtnType.setTitle("กรุณาเลือกสุนัข หรือ แมว", for: .normal)
        }
    }

    // MARK: -AddImage
    @IBAction func btnAddImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        if imageUrl != "" {
            btnImageAdd.isEnabled = false
            btnImageAdd.backgroundColor = .gray
        } else {
            btnImageAdd.isEnabled = true
            btnImageAdd.backgroundColor = .init(rgb: 0xA78721)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        imageName = String.uniqueFilename()
        
        storage.child("petposts/\(imageName).png").putData(imageData, metadata: nil, completion: { _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            
            self.storage.child("petposts/\(self.imageName).png").downloadURL(completion: { url, error in
                guard let url = url,error == nil else {
                    return
                }
                let urlString = url.absoluteString
                self.LoadingStart()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.LoadingStop()
                    self.btnImageAdd.isEnabled = false
                    self.btnImageAdd.backgroundColor = .gray
                    self.imgShow.loadFrom(URLAddress: urlString)
                    self.imageUrl = urlString
                }
            })
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -DeleteImage
    @IBAction func btnDeleteImage(_ sender: Any) {
        storage.child("petposts/\(imageName).png").delete()
        self.LoadingStart()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.imgShow.image = UIImage.init(named: "App_Icon_Useable")
            self.imageUrl = ""
            self.btnImageAdd.isEnabled = true
            self.btnImageAdd.backgroundColor = .init(rgb: 0xA78721)
            self.LoadingStop()
        }
    }
    
    // MARK: -HandleTap
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
    @IBAction func handleTapDdAdress(_ sender: Any) {
        ddAddress.show()
    }
    
    // MARK: - dropdownFunction
    
    func setupDropdown() {
        //
        setupDefaultDropdown()
        ddSex.dataSource = sex
        ddAgeY.dataSource = ageY
        ddAgeM.dataSource = ageM
        ddAddress.dataSource = addressBangkok
        //
        adjustDropdown(dd: ddAgeY, view: btnPetAgeY)
        adjustDropdown(dd: ddAgeM, view: btnPetAgeM)
        adjustDropdown(dd: ddSex, view: ddBtnSex)
        adjustDropdown(dd: ddType, view: ddBtnType)
        adjustDropdown(dd: ddAddress, view: btnAddress)
    }
    // MARK: - Post
    @IBAction func btnPost(_ sender: Any) {
        let url = "https://adoby.glitch.me/petposts/\(keepUserUID)"
        let _headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let params : [String:String] = [
            "pet_name":"\(tfPetName.text ?? "")",
            "pet_type":"\(ddBtnType.currentTitle ?? "")",
            "pet_color":"\(tfPetColor.text!)",
            "pet_sex":"\(ddBtnSex.currentTitle ?? "")",
            "pet_age":"\(btnPetAgeY.currentTitle ?? "") ปี \(btnPetAgeM.currentTitle ?? "") ด",
            "pet_address":"\(btnAddress.currentTitle ?? "")",
            "description":"\(tfDescription.text!)",
            "img_url":"\(self.imageUrl)"
        ]
        let encoder = URLEncodedFormParameterEncoder(destination: .httpBody)
        
        if (
            self.ddBtnType.currentTitle ?? "" != "" &&
            self.ddBtnSex.currentTitle ?? "" != "" &&
            self.btnPetAgeY.currentTitle ?? "" != "อายุ (ปี)" &&
            self.btnPetAgeM.currentTitle ?? "" != "อายุ (เดือน)" &&
            self.btnAddress.currentTitle ?? "" != "" &&
            self.tfDescription.text != "" &&
            self.tfPetColor.text != "" &&
            self.imageUrl != ""
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
    // MARK: - dismiss
    @IBAction func btnDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.isDismissed?()
        })
        storage.child("petposts/\(imageName).png").delete()
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDropdown()
        hideKB()
        // Do any additional setup after loading the view.
    }
    
}
