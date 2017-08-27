//
//  ArticleTableViewCell.swift
//  Vositive News Reader
//
//  Created by Daniel Chong on 27/6/17.
//  Copyright © 2017 Vositive Solutions. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor(red: 129.0/255.0, green: 139.0/255.0, blue: 155.0/255.0, alpha: 0.3)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
