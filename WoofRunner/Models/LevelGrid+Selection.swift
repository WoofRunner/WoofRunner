//
//  LevelGrid+Selection.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 4/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

/// Extension: Selection functionality for designing level grid.
/// Allows the user to long tap and box an area to bulk edit.
extension LevelGrid {
    
    /**
     Called on .began of gesture to start selection.
     - parameter pos: pair of floats containing the x and z coordinates of the tapped point in scene
     - note: Will toggle the starting grid on the specified coordinates and use that toggled grid
     as the template for bulk edit
     */
    public func beginSelection(_ pos: (x: Float, z: Float)) {
        guard let startGridVM = getValidGrid(pos) else {
            return
        }
        // init selection cache
        selectionCache = [String: [TileModel?]]()
        let startGridKey = getPosString(startGridVM.gridPos.value)
        selectionCache[startGridKey] = [startGridVM.platformType.value,
                                        startGridVM.obstacleType.value]
        
        // Save selection
        selectionStartPos = startGridVM.gridPos.value
        selectionEndPos = startGridVM.gridPos.value
        selectionTemplate = [startGridVM.platformType.value,
                             startGridVM.obstacleType.value]
    }
    
    /**
     Called on .changed of gesture to update selection.
     - parameter pos: pair of floats containing the x and z coordinates of the last tapped point in scene
     - note: Optimised with smarter rendering conditions to only render the delta of the selection correctly.
     - remark: Expensive operation as this will have to render all the grid nodes within the selection.
     */
    public func updateSelection(_ pos: (x: Float, z: Float)) {
        guard let startPos = selectionStartPos else {
            return
        }
        guard let endPos = selectionEndPos else {
            return
        }
        guard let endGrid = getValidGrid(pos) else {
            return
        }
        
        // Check for changes in selection
        if endGrid.gridPos.value.getRow() == endPos.getRow() &&
            endGrid.gridPos.value.getCol() == endPos.getCol() {
            return
        }
        // Handle selection difference
        toggleSelectionDifference(startPos, endPos, endGrid.gridPos.value)
        // Update selection
        selectionEndPos = endGrid.gridPos.value
    }
    
    /**
     Called on .end of gesture to terminate the selection and apply all changes.
     */
    public func endSelection() {
        // Empty selection
        selectionCache = [String: [TileModel?]]()
        selectionStartPos = nil
        selectionEndPos = nil
        selectionTemplate = [nil, nil]
    }
    
    private func revertGridInPosition(_ pos: Position) {
        // Look for cached tileModel
        guard let prevTileType = selectionCache[getPosString(pos)] else {
            return
        }
        // Revert
        let gridVM = gridViewModelArray.value[pos.getRow()][pos.getCol()]
        var platform: PlatformModel? = nil
        var obstacle: ObstacleModel? = nil
        if let prevPlatform = prevTileType[0] {
            if let platformType = prevPlatform as? PlatformModel {
                platform = platformType
            }
        }
        if let prevObstacle = prevTileType[1] {
            if let obstacleType = prevObstacle as? ObstacleModel {
                obstacle = obstacleType
            }
        }
        setGridVMType(gridVM,
                      platform: platform,
                      obstacle: obstacle)
    }
    
    private func toggleGridInPosition(_ pos: Position) {
        // Cache initial tileModel if not cached
        let gridVM = gridViewModelArray.value[pos.getRow()][pos.getCol()]
        let posString = getPosString(pos)
        if selectionCache[posString] == nil {
            selectionCache[posString] = [gridVM.platformType.value,
                                         gridVM.obstacleType.value]
        }
        var platform: PlatformModel? = nil
        var obstacle: ObstacleModel? = nil
        if let selectionPlatform = selectionTemplate[0] {
            if let platformType = selectionPlatform as? PlatformModel {
                platform = platformType
            }
        }
        if let selectionObstacle = selectionTemplate[1] {
            if let obstacleType = selectionObstacle as? ObstacleModel {
                obstacle = obstacleType
            }
        }
        // Preprocess for moving platforms
        preProcessMovingPlatform(pos.getRow(), platform)
        setGridVMType(gridVM,
                      platform: platform,
                      obstacle: obstacle)
    }
    
    // Iterates through the top and lower bounds; start row and end row, and
    // retrieve the grids within the box delimited by these 2 points
    private func getSelection(_ start: Position, _ end: Position) -> [Position] {
        if start.getRow() == end.getRow() && start.getCol() == end.getCol() {
            return [start]
        }
        var selection = [Position]()
        let bottomLeft = Position(row: min(start.getRow(), end.getRow()),
                                  col: min(start.getCol(), end.getCol()))
        let topRight = Position(row: max(start.getRow(), end.getRow()),
                                col: max(start.getCol(), end.getCol()))
        
        for row in bottomLeft.getRow()...topRight.getRow() {
            for col in bottomLeft.getCol()...topRight.getCol() {
                selection.append(Position(row: row, col: col))
            }
        }
        
        return selection
    }
    
    // Performs a double filter with the two boxes: start to prevEnd, and start to newEnd to retrieve
    // the delta for grids to be reverted and grids to be toggled.
    private func toggleSelectionDifference(_ start: Position, _ prevEnd: Position, _ newEnd: Position) {
        let prevSelection = getSelection(start, prevEnd)
        let newSelection = getSelection(start, newEnd)
        let revertSelection = prevSelection.filter({
            pos in
            return !newSelection.contains(where: {
                element in
                element.getRow() == pos.getRow() && element.getCol() == pos.getCol()
            })
        })
        let toggleSelection = newSelection.filter({
            pos in
            return !prevSelection.contains(where: {
                element in
                element.getRow() == pos.getRow() && element.getCol() == pos.getCol()
            })
        })
        if revertSelection.count > 0 {
            for pos in revertSelection {
                revertGridInPosition(pos)
            }
        }
        if toggleSelection.count > 0 {
            for pos in toggleSelection {
                toggleGridInPosition(pos)
            }
        }
    }
    
    // Simple hash for caching grid nodes
    private func getPosString(_ gridPos: Position) -> String {
        return String(gridPos.getRow()) + "," + String(gridPos.getCol())
    }
}
