//
//  MissingTableViewCell.swift
//  Adopby
//
//  Created by Hatto on 8/4/2565 BE.
//

import UIKit

class MissingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbPetName: UILabel!
    @IBOutlet weak var lbPetAge: UILabel!
    @IBOutlet weak var imgPet: UIImageView!
    @IBOutlet weak var lbPetType: UILabel!
    @IBOutlet weak var lbLastSeen: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var bgCell: UIView!
    @IBOutlet weak var lbPetDescription: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lbStatus.layer.cornerRadius = 5
        backgroundColor = .clear
        imgPet.layer.cornerRadius = 10
        lbPetName.textColor = .black
        lbPetType.textColor = .black
        lbLastSeen.textColor = .black
        lbPetDescription.textColor = .black
        lbPetAge.textColor = .black
        lbPrice.textColor = .black
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
