//
//  TileViewModel.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 22/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import RxSwift
import RxCocoa

/// The GridViewModel object encapsulates the TileModel properties
/// that are applicable to the rendered node in it.
/// The GridViewModel listens to the LevelGrid for updates.
/// The GridViewModel also contains observables for a Reactive Grid Node to observe.
class GridViewModel {
    
    // Used by reactive grid nodes to identify the parent grid node
    static let gridNodeName = "gridNode"
    
    // Observables
    var gridPos: Variable<Position>
    var size = Variable<Float>(GameSettings.TILE_WIDTH)
	var platformType = Variable<PlatformModel?>(nil)
	var obstacleType = Variable<ObstacleModel?>(nil)
    var shouldRender = Variable<Bool>(false)
    
    /**
     Creates an empty Grid View Model of a specified position.
     - parameter row: The row number of the grid view model
     - parameter col The column number of the grid view model
     */
    init (row: Int, col: Int) {
        self.gridPos = Variable<Position>(Position(row: row, col: col))
        self.size = Variable<Float>(Float(GameSettings.TILE_WIDTH))
    }
    
    /**
     Creates an empty Grid View Model at row 0, column 0.
     */
    convenience init() {
        self.init(row: 0, col: 0)
    }
    
    /**
     Set the platform tile model to the specified PlatformModel
     - parameter platform: PlatformModel to be updated with
     */
	func setPlatform(_ platform: PlatformModel) {
        // Add Platform
        self.platformType.value = platform
    }
    
    /**
     Removes the current platform and set it to nil.
     - note: Current constraints requires obstacles to exist on a platform
     Thus any obstacle on this platform will be removed together.
     */
    func removePlatform() {
		platformType.value = nil
		obstacleType.value = nil
    }
	
    /**
     Set the obstacle tile model to the specified ObstacleModel
     - parameter obstacle: ObstacleModel to be updated with
     - note: This function will not change anything if current grid does not have
     a platform.
     */
	func setObstacle(_ obstacle: ObstacleModel) {
		guard platformType.value != nil else {
            debugPrint("Error: Adding obstacle to grid without platform")
            return
        }
        // Add Obstacle
        self.obstacleType.value = obstacle
    }
    
    /**
     Removes the current obstacle and set it to nil.
     */
    func removeObstacle() {
        obstacleType.value = nil
    }
    
    /**
     Removes the top level tile model and set it to nil.
     If the grid has an obstacle, it will be removed, else the
     platform will be removed.
     */
    func removeTop() {
		guard obstacleType.value == nil else {
            return removeObstacle()
        }
        return removePlatform()
    }
    
    /**
     Set both platform and obstacle tile models concurrently.
     Use this method to escape platform, obstacle constraints.
     - parameter row: The row number of the grid view model
     - parameter col The column number of the grid view model
     */
	func setType(platform: PlatformModel?, obstacle: ObstacleModel?) {
		platformType.value = platform
		obstacleType.value = obstacle
    }
}
