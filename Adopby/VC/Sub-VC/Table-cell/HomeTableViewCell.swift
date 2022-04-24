//
//  HomeTableViewCell.swift
//  Adopby
//
//  Created by Hatto on 23/3/2565 BE.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPet: UIImageView!
    @IBOutlet weak var lbPetName: UILabel!
    @IBOutlet weak var lbPetAge: UILabel!
    @IBOutlet weak var lbPetType: UILabel!
    @IBOutlet weak var lbPetAddress: UILabel!
    @IBOutlet weak var lbPetDescription: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lbStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lbStatus.layer.cornerRadius = 5
        lbStatus.layer.masksToBounds = true
        imgPet.layer.cornerRadius = 10
        backgroundColor = .clear
        lbPetName.textColor = .black
        lbPetType.textColor = .black
        lbPetDescription.textColor = .black
        lbPetAddress.textColor = .black
        lbPetAge.textColor = .black
        lbStatus.textColor = .white
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
