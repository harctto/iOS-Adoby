//
//  StatViewController.swift
//  Adopby
//
//  Created by Hatto on 5/5/2565 BE.
//

import UIKit
import Charts
import Alamofire

class StatViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    
    var chartType:String = ""
    
    @IBAction func btnDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.delegate = self
        view.backgroundColor = .init(rgb: 0xFEF8E7)
        chartView.backgroundColor = .init(rgb: 0xFEF8E7)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        if chartType == "post" {
            AF.request(
                "https://adoby.glitch.me/petposts",
                method: .get
            ).responseDecodable(of: [PetPost].self) { response in
                switch (response.result) {
                case .success:
                    var entries = [BarChartDataEntry]()
                    var entries2 = [BarChartDataEntry]()
                    var entries3 = [BarChartDataEntry]()
                    var x:Int = 0
                    var y:Int = 0
                    var z:Int = 0
                    for i:PetPost in response.value! {
                        switch i.status {
                        case "กำลังหาบ้าน":
                            x += 1
                        case "จองแล้ว":
                            y += 1
                        case "มีบ้านแล้ว":
                            z += 1
                        default:
                            break
                        }
                    }
                    entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
                    entries2.append(BarChartDataEntry(x: Double(y), y: Double(y)))
                    entries3.append(BarChartDataEntry(x: Double(z), y: Double(z)))
                    let set = BarChartDataSet(entries: entries,label: "กำลังหาบ้าน")
                    set.colors = [.init(rgb: 0x749D40)]
                    let set2 = BarChartDataSet(entries: entries2,label: "จองแล้ว")
                    set2.colors = [.init(rgb: 0xCB4224)]
                    let set3 = BarChartDataSet(entries: entries3, label: "มีบ้านแล้ว")
                    set3.colors = [.init(rgb: 0xF7D154)]
                    let data = BarChartData(dataSets: [set,set2,set3])
                    self.chartView.data = data
                    //label1
                    self.lb1.text = "กำลังหาบ้านทั้งหมด: \(x) ตัว"
                    self.lb1.backgroundColor = .init(rgb: 0x749D40)
                    self.lb1.layer.cornerRadius = 10
                    self.lb1.layer.masksToBounds = true
                    self.lb1.font = .init(name: "Prompt-SemiBold", size: 24)
                    self.lb1.isHidden = false
                    //label2
                    self.lb2.text = "จองแล้วทั้งหมด: \(y) ตัว"
                    self.lb2.backgroundColor = .init(rgb: 0xF7D154)
                    self.lb2.layer.cornerRadius = 10
                    self.lb2.layer.masksToBounds = true
                    self.lb2.textColor = .init(rgb: 0x7E6514)
                    self.lb2.font = .init(name: "Prompt-SemiBold", size: 24)
                    self.lb2.isHidden = false
                    //label3
                    self.lb3.text = "มีบ้านแล้ว \(z) ตัว"
                    self.lb3.backgroundColor = .init(rgb: 0xCB4224)
                    self.lb3.layer.cornerRadius = 10
                    self.lb3.layer.masksToBounds = true
                    self.lb3.font = .init(name: "Prompt-SemiBold", size: 24)
                    self.lb3.isHidden = false
                case .failure:
                    break
                }
            }
        } else {
            AF.request(
                "https://adoby.glitch.me/petlosts",
                method: .get
            ).responseDecodable(of: [Petlost].self) { response in
                switch (response.result) {
                case .success:
                    var entries = [BarChartDataEntry]()
                    var entries2 = [BarChartDataEntry]()
                    var x:Int = 0
                    var y:Int = 0
                    for i:Petlost in response.value! {
                        switch i.status {
                        case "กำลังตามหา":
                            x += 1
                        case "เจอแล้ว":
                            y += 1
                        default:
                            break
                        }
                    }
                    entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
                    entries2.append(BarChartDataEntry(x: Double(y), y: Double(y)))
                    let set = BarChartDataSet(entries: entries,label: "กำลังตามหา")
                    set.colors = [.init(rgb: 0xCB4224)]
                    let set2 = BarChartDataSet(entries: entries2,label: "เจอแล้ว")
                    set2.colors = [.init(rgb: 0xF7D154)]
                    let data = BarChartData(dataSets: [set,set2])
                    self.chartView.data = data
                    //label1
                    self.lb1.text = "กำลังตามหาทั้งหมด: \(x) ตัว"
                    self.lb1.backgroundColor = .init(rgb: 0xCB4224)
                    self.lb1.layer.cornerRadius = 10
                    self.lb1.layer.masksToBounds = true
                    self.lb1.font = .init(name: "Prompt-SemiBold", size: 24)
                    self.lb1.isHidden = false
                    //label2
                    self.lb2.text = "เจอแล้วทั้งหมด: \(y) ตัว"
                    self.lb2.backgroundColor = .init(rgb: 0xF7D154)
                    self.lb2.layer.cornerRadius = 10
                    self.lb2.layer.masksToBounds = true
                    self.lb2.textColor = .init(rgb: 0x7E6514)
                    self.lb2.font = .init(name: "Prompt-SemiBold", size: 24)
                    self.lb2.isHidden = false
                    //label3
                    self.lb3.isHidden = true
                case .failure:
                    break
                }
            }
        }
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
