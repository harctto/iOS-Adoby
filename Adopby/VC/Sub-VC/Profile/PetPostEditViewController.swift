//
//  PetPostEditViewController.swift
//  Adopby
//
//  Created by Hatto on 5/5/2565 BE.
//

import UIKit
import DropDown
import Alamofire
import FirebaseStorage

class PetPostEditViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var keepPostData:PetPost!
    @IBOutlet weak var tfPetName: UITextField!
    @IBOutlet weak var tfPetColor: UITextField!
    @IBOutlet weak var btnPetAgeM: UIButton!
    @IBOutlet weak var btnPetAgeY: UIButton!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var tfDescription: UITextField!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var ddBtnSex: UIButton!
    @IBOutlet weak var ddBtnType: UIButton!
    @IBOutlet weak var btnImageAdd: UIButton!
    @IBOutlet weak var imgShow: UIImageView!
    @IBOutlet weak var btnImageDelete: UIButton!
    @IBOutlet weak var ddBtnStatus: UIButton!
    //variable
    let ddAgeY = DropDown()
    let ddAgeM = DropDown()
    let ddSex = DropDown()
    let ddType = DropDown()
    let ddAddress = DropDown()
    let ddStatus = DropDown()
    var isDismissed: (() -> Void)?
    var storage = Storage.storage().reference()
    var imageUrl:String = ""
    var imageName:String = ""
    var keepStatus:String = ""
    
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
        ddBtnStatus.layer.cornerRadius = 20
        btnImageAdd.layer.cornerRadius = 20
        btnPost.startAnimatingPressActions()
        btnDismiss.startAnimatingPressActions()
        btnImageAdd.startAnimatingPressActions()
        btnImageDelete.startAnimatingPressActions()
        btnPetAgeM.startAnimatingPressActions()
        btnPetAgeY.startAnimatingPressActions()
        imgShow.layer.masksToBounds = true
        imgShow.layer.cornerRadius = 20
        //setDefault
        tfPetName.text = keepPostData.petName
        tfPetColor.text = keepPostData.petColor
        ddBtnSex.setTitle(keepPostData.petSex, for: .normal)
        btnAddress.setTitle(keepPostData.petAddress, for: .normal)
        if dogType.contains(keepPostData.petType) {
            ddType.dataSource = dogType
        } else {
            ddType.dataSource = catType
        }
        ddBtnType.setTitle(keepPostData.petType, for: .normal)
        tfDescription.text = keepPostData.petpostDescription
        imgShow.loadFrom(URLAddress: keepPostData.imgURL)
        imageUrl = keepPostData.imgURL
        keepStatus = keepPostData.status
        onChangeStatus()
    }
    
    func onChangeStatus() {
        if keepStatus == "กำลังหาบ้าน" {
            if dogType.contains(keepPostData.petType) {
                ddBtnStatus.setTitle("🐶 กำลังหาบ้าน", for: .normal)
            } else if catType.contains(keepPostData.petType) {
                ddBtnStatus.setTitle("🐱 กำลังหาบ้าน", for: .normal)
            }
            ddBtnStatus.backgroundColor = .init(rgb: 0x749D40)
            ddBtnStatus.setTitleColor(.init(rgb: 0x749D40), for: .normal)
            ddBtnStatus.setTitleColor(.white, for: .normal)
        } else if keepStatus == "มีบ้านแล้ว"{
            ddBtnStatus.backgroundColor = .init(rgb: 0xCB4224)
            ddBtnStatus.setTitleColor(.white, for: .normal)
            ddBtnStatus.setTitle("🏠 มีบ้านแล้ว", for: .normal)
        } else if keepStatus == "จองแล้ว"{
            ddBtnStatus.backgroundColor = .init(rgb: 0xF7D154)
            ddBtnStatus.setTitleColor(.init(rgb: 0x7E6514), for: .normal)
            ddBtnStatus.setTitle("📌 จองแล้ว", for: .normal)
        } else {
            ddBtnStatus.backgroundColor = .white
            ddBtnStatus.setTitle("", for: .normal)
        }
    }
    
    
    // MARK: - imageFunction
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
    @IBAction func handleTapDdStatus(_ sender: Any) {
        ddStatus.show()
    }
    
    // MARK: - dropdownFunction
    
    func setupDropdown() {
        //
        setupDefaultDropdown()
        ddSex.dataSource = sex
        ddAgeY.dataSource = ageY
        ddAgeM.dataSource = ageM
        ddAddress.dataSource = addressBangkok
        ddStatus.dataSource = ["กำลังหาบ้าน","มีบ้านแล้ว","จองแล้ว"]
        //
        adjustDropdown(dd: ddStatus, view: ddBtnStatus)
        adjustDropdown(dd: ddAgeY, view: btnPetAgeY)
        adjustDropdown(dd: ddAgeM, view: btnPetAgeM)
        adjustDropdown(dd: ddSex, view: ddBtnSex)
        adjustDropdown(dd: ddType, view: ddBtnType)
        adjustDropdown(dd: ddAddress, view: btnAddress)
        ddStatus.selectionAction = { [unowned self] (index: Int, item: String) in
            keepStatus = item
            onChangeStatus()
        }
    }
    
    // MARK: - Post
    @IBAction func btnPost(_ sender: Any) {
        let url = "https://adoby.glitch.me/petposts/edit/\(keepPostData.postID)"
        let _headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let params : [String:String] = [
            "pet_name":"\(tfPetName.text ?? "")",
            "pet_type":"\(ddBtnType.currentTitle ?? "")",
            "pet_color":"\(tfPetColor.text!)",
            "pet_sex":"\(ddBtnSex.currentTitle ?? "")",
            "pet_age":"\(btnPetAgeY.currentTitle ?? "") ปี \(btnPetAgeM.currentTitle ?? "") ด",
            "pet_address":"\(btnAddress.currentTitle ?? "")",
            "description":"\(tfDescription.text!)",
            "img_url":"\(self.imageUrl)",
            "status":"\(keepStatus)"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDropdown()
        hideKB()
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
