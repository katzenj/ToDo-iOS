//
//  ToDoTableViewCell.swift
//  ToDo
//
//  Created by Jordan  on 10/26/18.
//  Copyright © 2018 Jordan Katzen. All rights reserved.
//

import UIKit

@objc protocol ToDoCellDelegate: class {
    func isCompleteButtonTapped(sender: ToDoTableViewCell)
}

class ToDoTableViewCell: UITableViewCell {
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    
    var delegate: ToDoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func isCompleteButtonTapped(_ sender: Any) {
        delegate?.isCompleteButtonTapped(sender: self)
    }
}
