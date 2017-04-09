//
//  Tile.swift
//  WoofRunner
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//
import Foundation
import SceneKit

class Tile: GameObject {
    
    var delegate: TileDelegate?
    
    var tileType: TileType = TileType.none
    
    var autoDestroyPositionZ: Float = 5
    
    var triggerDistance: Float = 0
    var isTriggered: Bool = false
    
    var positionOffSet: SCNVector3 = SCNVector3.zero()
    
    let tileId: Int

    init(_ tileModel: TileModel) {
        tileId = tileModel.tileId
        super.init()
        isTickEnabled = true
        
        guard let scenePath = tileModel.scenePath else {
            return
        }
        loadModel(scenePath)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func update(_ deltaTime: Float) {
        if worldPosition.z > autoDestroyPositionZ {
            destroy()
        }
        
        if worldPosition.z > triggerDistance {
            if !isTriggered {
                onTriggered()
                isTriggered = true
            }
        }
    }
    
    func onTriggered() {
    }
    
    override func deactivate() {
        super.deactivate()
        isTriggered = false
    }
    
    override func destroy() {
        delegate?.onTileDestroy(self)
    }
    
    func setPositionWithOffset(position: SCNVector3) {
        self.position = position + positionOffSet
    }
    
    public func equal(tileModel: TileModel) -> Bool {
        return tileId == tileModel.tileId
    }
}
