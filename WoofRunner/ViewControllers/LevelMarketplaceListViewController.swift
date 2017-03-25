//
//  LevelMarketplaceListViewController.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/25/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

public enum LevelListType {
    case Downloaded
    case Created
}

public class LevelMarketplaceListViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet var viewTitle: UILabel!

    // MARK: - Public variables

    public var listType: LevelListType?

    // MARK: - Lifecyle methods

    public override func viewDidLoad() {
        switch listType! {
        case .Downloaded:
            viewTitle.text = "Downloaded Levels"
        case .Created:
            viewTitle.text = "Created Levels"
        }
    }

}
