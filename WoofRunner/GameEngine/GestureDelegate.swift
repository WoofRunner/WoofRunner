//
//  GestureDelegate.swift
//  test
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//

import Foundation
import SceneKit

protocol GestureDelegate {
    func panGesture(_ gesture: UIPanGestureRecognizer, _ location: CGPoint)
    
    func tapGesture(_ gesture: UITapGestureRecognizer, _ location: CGPoint)
}
