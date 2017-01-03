//
//  DetailCollectionCell.swift
//  NYRA
//
//  Created by Joey on 1/2/17.
//  Copyright © 2017 NelsonJE. All rights reserved.
//

import UIKit

class DetailCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentLabel: UITextField!
    @IBOutlet weak var localGoalLabel: UILabel!
    @IBOutlet weak var totalGoalLabel: UILabel!
    @IBOutlet weak var downArrow: GHButton!
    @IBOutlet weak var upArrow: GHButton!
    @IBOutlet weak var deleteButton: UIButton!
}
