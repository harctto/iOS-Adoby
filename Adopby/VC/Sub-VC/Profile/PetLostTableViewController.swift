//
//  PetLostTableViewController.swift
//  Adopby
//
//  Created by Hatto on 5/5/2565 BE.
//

import UIKit
import Alamofire

class PetLostTableViewController: UITableViewController {
    
    var countforrow:Int = 1
    var currentUsername:Users!
    var keepData:[Petlost] = []
    
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.fetchDataForCellRow()
        }
        countforrow = 1
        let backButton: UIBarButtonItem = UIBarButtonItem(
            title: "<",
            style: .plain,
            target: self,
            action: #selector(back)
        )
        
        self.navigationItem.leftBarButtonItem = backButton;
        super.viewWillAppear(animated);
        LoadingStart()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
        guard let url = URL(string: "https://adoby.glitch.me/petlosts/own/\(currentUsername.uid ?? "")") else { return }
        AF.request(url,method: .get)
            .responseDecodable(of: [Petlost].self)
        { response in
            self.countforrow = response.value!.count
        }
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "MissingTableViewCell",
                                  bundle: nil)
        tableView.register(textFieldCell,
                           forCellReuseIdentifier: "MissingTableViewCell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MissingTableViewCell") as? MissingTableViewCell {
            let url = "https://adoby.glitch.me/petlosts/own/\(currentUsername.uid ?? "")"
            //decorate
            cell.layer.cornerRadius = 20
            cell.clipsToBounds = true
            if indexPath.row % 2 == 0 {
                cell.bgCell.backgroundColor = .white
            }
            else {
                cell.bgCell.backgroundColor = UIColor.init(rgb: 0xFBE6A2)
            }
            AF.request(url,method: .get)
                .responseDecodable(of: [Petlost].self)
            { response in
                self.keepData = response.value!
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
                    cell.lbPetAge.text = "\(self.keepData[safe: indexPath.row]?.petAge ?? "") ขวบ"
                    cell.lbPetDescription.text = self.keepData[safe: indexPath.row]?.petlostDescription
                    cell.lbLastSeen.text = self.keepData[safe: indexPath.row]?.lastSeen
                    cell.lbPrice.text = "รางวัล : \(self.keepData[safe: indexPath.row]?.price ?? "") บาท"
                    cell.imgPet.loadFrom(URLAddress: self.keepData[safe: indexPath.row]?.imgURL ?? "")
                    //
                    let colorCellSelected = UIView()
                    colorCellSelected.backgroundColor  = UIColor.red.withAlphaComponent(0)
                    cell.selectedBackgroundView = colorCellSelected
                    //
                    if self.keepData[safe: indexPath.row]?.status == "กำลังตามหา" {
                        cell.lbStatus.backgroundColor = .init(rgb: 0xCB4224)
                        if dogType.contains(self.keepData[safe: indexPath.row]?.petType ?? "") {
                            cell.lbStatus.text = "🐶 กำลังตามหา"
                        } else if catType.contains(self.keepData[safe: indexPath.row]?.petType ?? "") {
                            cell.lbStatus.text = "🐱 กำลังตามหา"
                        }
                    } else if self.keepData[safe: indexPath.row]?.status == "เจอแล้ว"{
                        cell.lbStatus.backgroundColor = .init(rgb: 0x749D40)
                        cell.lbStatus.text = "🏠 เจอแล้ว"
                    } else {
                        cell.lbStatus.backgroundColor = .white
                        cell.lbStatus.text = ""
                    }
                } else {}
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
            let sender = segue.destination as! PetLostEditViewController
            sender.keepPostData = self.keepData[safe: tableView.indexPathForSelectedRow!.row]
        }
    }
    
}
