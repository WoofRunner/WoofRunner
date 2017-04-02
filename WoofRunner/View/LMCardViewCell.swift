//
//  LMCardViewCell.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/25/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import FacebookCore

public class LMCardViewCell: UICollectionViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var facebookProfilePicture: UIView!
    @IBOutlet weak var gameName: UILabel!

    // MARK: - IBInspectables
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }

            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    // MARK: - Public variables

    public var name: String? {
        didSet {
            gameName.text = name
        }
    }

    public var facebookProfileId: String? {
        didSet {
            let profile = UserProfile(userId: facebookProfileId!)
            facebookProfilePicture.addSubview(
                UserProfile.PictureView(
                    frame: facebookProfilePicture.frame, profile: profile)
            )
        }
    }

    /// UUID of the game it is representing
    public var uuid: String?

}
