//
//  PetPostTableViewController.swift
//  Adopby
//
//  Created by Hatto on 5/5/2565 BE.
//

import UIKit
import Alamofire

class PetPostTableViewController: UITableViewController {
    
    var countforrow:Int = 0
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
        countforrow = 0
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

    
    func fetchDataForCellRow() {
        guard let url = URL(string: "https://adoby.glitch.me/petposts/own/\(currentUsername.uid ?? "")") else { return }
        AF.request(url,method: .get)
            .responseDecodable(of: [PetPost].self)
        { response in
            self.countforrow = response.value!.count
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
            let url = "https://adoby.glitch.me/petposts/own/\(currentUsername.uid ?? "")"
            //decorate
            cell.layer.cornerRadius = 20
            cell.clipsToBounds = true
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
                if self.keepData.indices.contains(0) {
                    if self.keepData[safe: indexPath.row]?.petName == "" {
                        if self.keepData[safe: indexPath.row]?.petColor.contains("สี") == true {
                            cell.lbPetName.text = self.keepData[safe: indexPath.row]!.petColor
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
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "sentEdit", sender: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sentEdit" {
            let sender = segue.destination as! PetPostEditViewController
            sender.keepPostData = self.keepData[safe: tableView.indexPathForSelectedRow!.row]
        }
    }
    
}
