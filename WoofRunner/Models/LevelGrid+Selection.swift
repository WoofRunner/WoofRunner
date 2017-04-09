//
//  LevelGrid+Selection.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 4/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

extension LevelGrid {
    
    func beginSelection(_ pos: (x: Float, z: Float)) {
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
    
    func updateSelection(_ pos: (x: Float, z: Float)) {
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
    
    func endSelection() {
        // Empty selection
        selectionCache = [String: [TileModel?]]()
        selectionStartPos = nil
        selectionEndPos = nil
        selectionTemplate = [nil, nil]
    }
    
    private func revertGridInPosition(_ pos: Position) {
        // Look for cached Tiletype
        guard let prevTileType = selectionCache[getPosString(pos)] else {
            return
        }
        // Revert
        let gridVM = gridViewModelArray[pos.getRow()][pos.getCol()]
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
        // Cache initial type if not cached
        let gridVM = gridViewModelArray[pos.getRow()][pos.getCol()]
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
        setGridVMType(gridVM,
                      platform: platform,
                      obstacle: obstacle)
    }
    
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
    
    private func getPosString(_ gridPos: Position) -> String {
        return String(gridPos.getRow()) + "," + String(gridPos.getCol())
    }
}
