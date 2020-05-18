//
//  WorkoutTableViewCell.swift
//  FitLevel
//
//  Created by Jacky Eng on 19/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var WorkoutNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
