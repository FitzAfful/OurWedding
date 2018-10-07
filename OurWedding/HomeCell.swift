//
//  HomeCell.swift
//  OurWedding
//
//  Created by Fitzgerald Afful on 14/12/2017.
//  Copyright © 2017 oasiswebsoft. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

	@IBOutlet weak var postLabel: UILabel!
	@IBOutlet weak var postImageView: UIImageView!
	@IBOutlet weak var userLabel: UILabel!
	@IBOutlet weak var userImageView: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
