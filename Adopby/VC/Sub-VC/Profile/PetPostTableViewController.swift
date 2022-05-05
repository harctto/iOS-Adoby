//
//  PetPostTableViewController.swift
//  Adopby
//
//  Created by Hatto on 5/5/2565 BE.
//

import UIKit
import Alamofire

class PetPostTableViewController: UITableViewController {
    
    var countforrow:Int = 1
    var currentUsername:Users!
    var keepData:[PetPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
        tableView.backgroundColor = .init(rgb: 0xFEF8E7)
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 0x7E6514),
            NSAttributedString.Key.font: UIFont(name: "Prompt-Medium", size: 24)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        UINavigationBar.appearance().backgroundColor = .init(rgb: 0xF7D154)
        view.backgroundColor = .init(rgb: 0xF7D154)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.fetchDataForCellRow()
        }
        let backButton: UIBarButtonItem = UIBarButtonItem(
            title: "<",
            style: .plain,
            target: self,
            action: #selector(back)
        )
        
        self.navigationItem.leftBarButtonItem = backButton;
        super.viewWillAppear(animated);
        LoadingStart()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.tableView.reloadData()
            print(self.countforrow)
            self.LoadingStop()
        }
    }
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countforrow
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        if indexPath.row == 0 {
            height = 0
        } else {
            height = 177
        }
        return height
    }
    
    func fetchDataForCellRow() {
        guard let url = URL(string: "https://adoby.glitch.me/petposts") else { return }
        AF.request(url,method: .get)
            .responseDecodable(of: [PetPost].self)
        { response in
            for i:PetPost in response.value! {
                if self.currentUsername.uid == i.uid {
                    self.countforrow += 1
                }
                else {
                    //
                }
            }
        }
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "HomeTableViewCell",
                                  bundle: nil)
        tableView.register(textFieldCell,
                           forCellReuseIdentifier: "HomeTableViewCell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell {
            let url = "https://adoby.glitch.me/petposts"
            //decorate
            cell.layer.cornerRadius = 20
            cell.clipsToBounds = true
            if indexPath.row == 0 {
                cell.isHidden = true
            } else {
                cell.isHidden = false
            }
            if indexPath.row % 2 == 0 {
                cell.bgView.backgroundColor = .white
            }
            else {
                cell.bgView.backgroundColor = UIColor.init(rgb: 0xFBE6A2)
            }
            AF.request(url,method: .get)
                .responseDecodable(of: [PetPost].self)
            { response in
                self.keepData = response.value!
                if self.currentUsername.uid == self.keepData[safe: indexPath.row]?.uid {
                    print(indexPath.row)
                    if self.keepData.indices.contains(0) {
                        if self.keepData[safe: indexPath.row]?.petName == "" {
                            if self.keepData[safe: indexPath.row]?.petColor.contains("สี") == true {
                                cell.lbPetName.text = self.keepData[safe: indexPath.row]?.petColor
                            } else {
                                cell.lbPetName.text = "สี\(self.keepData[safe: indexPath.row]?.petColor ?? "")"
                            }
                        } else {
                            cell.lbPetName.text = "ชื่อ: \(self.keepData[safe: indexPath.row]?.petName ?? "")"
                        }
                        if self.keepData[safe: indexPath.row]?.petType == "------ไม่ทราบ------" {
                            cell.lbPetType.text = "พันธุ์: ไม่ทราบ"
                        } else {
                            cell.lbPetType.text = "พันธุ์: \(self.keepData[safe: indexPath.row]?.petType ?? "")"
                        }
                        let colorCellSelected = UIView()
                        colorCellSelected.backgroundColor  = UIColor.red.withAlphaComponent(0)
                        cell.selectedBackgroundView = colorCellSelected
                        cell.lbPetAge.text = "\(self.keepData[safe: indexPath.row]?.petAge ?? "")"
                        cell.lbPetDescription.text = self.keepData[safe: indexPath.row]?.petpostDescription
                        cell.lbPetAddress.text = "เขต: \(self.keepData[safe: indexPath.row]?.petAddress ?? "")"
                        cell.imgPet.loadFrom(URLAddress: self.keepData[safe: indexPath.row]?.imgURL ?? "")
                        if self.keepData[safe: indexPath.row]?.status == "กำลังหาบ้าน" {
                            cell.lbStatus.backgroundColor = .init(rgb: 0x749D40)
                            if dogType.contains(self.keepData[safe: indexPath.row]?.petType ?? "") {
                                cell.lbStatus.text = "🐶 กำลังหาบ้าน"
                            } else if catType.contains(self.keepData[safe: indexPath.row]?.petType ?? "") {
                                cell.lbStatus.text = "🐱 กำลังหาบ้าน"
                            }
                        } else if self.keepData[safe: indexPath.row]?.status == "มีบ้านแล้ว"{
                            cell.lbStatus.backgroundColor = .init(rgb: 0xCB4224)
                            cell.lbStatus.text = "🏠 มีบ้านแล้ว"
                        } else if self.keepData[safe: indexPath.row]?.status == "จองแล้ว"{
                            cell.lbStatus.backgroundColor = .init(rgb: 0xF7D154)
                            cell.lbStatus.textColor = .init(rgb: 0x7E6514)
                            cell.lbStatus.text = "📌 จองแล้ว"
                        } else {
                            cell.lbStatus.backgroundColor = .white
                            cell.lbStatus.text = ""
                        }
                    }
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
