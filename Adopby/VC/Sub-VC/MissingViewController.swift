//
//  MissingViewController.swift
//  Adopby
//
//  Created by Hatto on 7/4/2565 BE.
//

import UIKit
import Alamofire
import AnimatableReload

class MissingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    let refreshControl = UIRefreshControl()
    var countforrow:Int = 0
    
    func setupUI() {
        view.backgroundColor = UIColor.init(rgb: 0xFEF8E7)
        self.tableview.dataSource = self
        self.tableview.delegate = self
        registerTableViewCells()
        self.tableview.rowHeight = 177
        self.tableview.separatorStyle = .none
        self.tableview.backgroundColor = .clear
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 0x7E6514)]
        refreshControl.attributedTitle = NSAttributedString(string: "", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.init(rgb: 0x7E6514)
        tableview.addSubview(refreshControl)
    }
    
    func fetchDataForCellRow() {
        guard let url = URL(string: "https://adoby.glitch.me/petlosts") else { return }
        AF.request(url,method: .get)
            .responseDecodable(of: [Petlost].self)
        { response in
            self.countforrow = response.value!.count as Int
        }
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "MissingTableViewCell", bundle: nil)
        self.tableview.register(textFieldCell, forCellReuseIdentifier: "MissingTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countforrow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MissingTableViewCell") as? MissingTableViewCell {
            //decorate
            cell.layer.cornerRadius = 20
            cell.clipsToBounds = true
            if indexPath.row % 2 == 0 {
                cell.bgCell.backgroundColor = .white
            }
            else {
                cell.bgCell.backgroundColor = UIColor.init(rgb: 0xFBE6A2)
            }
            //fetch data
            let url = "https://adoby.glitch.me/petlosts"
            AF.request(url,method: .get)
                .responseDecodable(of: [Petlost].self)
            { response in
                let keepData:[Petlost] = response.value!
                if keepData.indices.contains(0) {
                    cell.lbPetName.text = keepData[safe: indexPath.row]?.petName
                    cell.lbPetType.text = keepData[safe: indexPath.row]?.petType
                    cell.lbPetAge.text = "\(keepData[safe: indexPath.row]?.petAge ?? "") ขวบ"
                    cell.lbPetDescription.text = keepData[safe: indexPath.row]?.petlostDescription
                    cell.lbLastSeen.text = keepData[safe: indexPath.row]?.lastSeen
                    cell.lbPrice.text = "รางวัล : \(keepData[safe: indexPath.row]?.price ?? "") บาท"
                    cell.imgPet.loadFrom(URLAddress: keepData[safe: indexPath.row]?.imgURL ?? "")
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchDataForCellRow()
        //reload await
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableview.reloadData()
            AnimatableReload.reload(tableView: self.tableview, animationDirection: "up")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableview.reloadData()
        fetchDataForCellRow()
        countforrow = 0
        refreshControl.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableview.reloadData()
            AnimatableReload.reload(tableView: self.tableview, animationDirection: "up")
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        tableview.reloadData()
        fetchDataForCellRow()
        refreshControl.endRefreshing()
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
