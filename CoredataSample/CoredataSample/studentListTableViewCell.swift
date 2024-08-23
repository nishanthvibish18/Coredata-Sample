//
//  studentListTableViewCell.swift
//  CoredataSample
//
//  Created by Nishanth on 09/07/24.
//

import UIKit

class studentListTableViewCell: UITableViewCell {

    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var studentRegNameLabel: UILabel!
    @IBOutlet weak var studentDepartmentLabel: UILabel!
    @IBOutlet weak var studentAgeLabel:UILabel!
    @IBOutlet weak var studentMarkLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
