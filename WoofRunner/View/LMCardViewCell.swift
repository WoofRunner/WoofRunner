//
//  LMCardViewCell.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/25/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

public class LMCardViewCell: UICollectionViewCell {

    @IBOutlet var gameName: UILabel!
    public var name: String? {
        didSet {
            gameName.text = name
        }
    }

}
