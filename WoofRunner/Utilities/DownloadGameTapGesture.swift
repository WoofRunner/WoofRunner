//
//  DownloadGameTapGesture.swift
//  WoofRunner
//
//  Created by Xu Bili on 4/9/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

public class DownloadGameTapGesture: UITapGestureRecognizer {

    public private(set) var uuid: String?

    public func setUUID(_ uuid: String) {
        self.uuid = uuid
    }

}
