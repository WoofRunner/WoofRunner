//
//  LevelGrid.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 27/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class LevelGrid {

    // MARK: - SaveableGame

    var storedGame: StoredGame?
    
    var disposeBag = DisposeBag()
    
    static var levelCols = 5
    static var chunkLength = 20
    
    var length: Int
    var platformArray: [[Int]]
    var obstacleArray: [[Int]]
    var gridViewModelArray: [[GridViewModel]]
    
    var selectionCache = [String: [TileType]]()
    var selectionStartPos: Position?
    var selectionEndPos: Position?
    var selectionBrush = TileType.none
    
    init(length: Int) {
        self.length = length
        self.platformArray = [[Int]](repeating: [Int](repeating: TileType.none.rawValue,
                                                      count: LevelGrid.levelCols),
                                     count: length)
        self.obstacleArray = [[Int]](repeating: [Int](repeating: TileType.none.rawValue,
                                                      count: LevelGrid.levelCols),
                                     count: length)
        self.gridViewModelArray = [[GridViewModel]](repeating: [GridViewModel](repeating: GridViewModel(),
                                                                               count: LevelGrid.levelCols),
                                                    count: length)
        
        guard length > 0 else {
            return
        }
        
        // Initialise empty level
        for row in 0...length - 1 {
            for col in 0...LevelGrid.levelCols - 1 {
                let gridVM = GridViewModel(row: row, col: col)
                setupObservables(gridVM)
                // Append to array
                gridViewModelArray[row][col] = gridVM
            }
        }
    }
    
    convenience init() {
        self.init(length: 0);
    }
    
    func toggleGrid(x: Float, y: Float, _ currentSelectedBrush: TileType) {
        guard let gridVM = getValidGrid((x: x, y: y)) else {
            return
        }
        return toggleGrid(gridVM, currentSelectedBrush)
    }
    
    func toggleGrid(_ gridVM: GridViewModel, _ currentSelectedBrush: TileType) {
        // Toggle grid
        if currentSelectedBrush.isPlatform() {
            gridVM.setPlatform(currentSelectedBrush)
        } else if currentSelectedBrush.isObstacle() && gridVM.platformType.value != TileType.none {
            gridVM.setObstacle(currentSelectedBrush)
        } else if currentSelectedBrush == TileType.none {
            // Current implementation: Delete top level node; obstacle if any else platform
            gridVM.removeTop()
        }
    }
    
    func reloadChunk(from startRow: Int) {
        
        let endRow = startRow + LevelGrid.chunkLength
        
        for gridVMRow in gridViewModelArray {
            for gridVM in gridVMRow {
                if gridVM.gridPos.value.getRow() >= startRow &&
                    gridVM.gridPos.value.getRow() < endRow {
                    gridVM.shouldRender.value = true
                } else {
                    gridVM.shouldRender.value = false
                }
            }
        }
    }
    
    func extendLevel(by extend: Int) {
        // Prepare empty arrays for extension
        let extendedPlatformArray = [[Int]](repeating: [Int](repeating: TileType.none.rawValue,
                                                             count: LevelGrid.levelCols),
                                            count: extend)
        self.platformArray.append(contentsOf: extendedPlatformArray)
        let extendedObstacleArray = [[Int]](repeating: [Int](repeating: TileType.none.rawValue,
                                                             count: LevelGrid.levelCols),
                                            count: extend)
        self.obstacleArray.append(contentsOf: extendedObstacleArray)
        let extendedGridVMArray = [[GridViewModel]](repeating: [GridViewModel](repeating: GridViewModel(),
                                                                               count: LevelGrid.levelCols),
                                                    count: extend)
        self.gridViewModelArray.append(contentsOf: extendedGridVMArray)
        
        // Initialise extended array data
        for row in length...length + extend - 1 {
            for col in 0...LevelGrid.levelCols - 1 {
                let gridVM = GridViewModel(row: row, col: col)
                setupObservables(gridVM)
                // Append to array
                gridViewModelArray[row][col] = gridVM
            }
        }
        
        // Update level length
        self.length += extend
    }
    
    func beginSelection(_ pos: (x: Float, y: Float), _ currentSelectedBrush: TileType) {
        guard let startGridVM = getValidGrid(pos) else {
            return
        }
        // init selection cache
        selectionCache = [String: [TileType]]()
        let startGridKey = getPosString(startGridVM.gridPos.value)
        selectionCache[startGridKey] = [startGridVM.platformType.value,
                                        startGridVM.obstacleType.value]
        
        // Save selection
        selectionStartPos = startGridVM.gridPos.value
        selectionEndPos = startGridVM.gridPos.value
        selectionBrush = currentSelectedBrush
    }
    
    func updateSelection(_ pos: (x: Float, y: Float)) {
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
        // Do revert for previous selection
        revertSelection(startPos, endPos)
        // Do toggle for current selection
        toggleSelection(startPos, endGrid.gridPos.value)
        // Update selection
        selectionEndPos = endGrid.gridPos.value
    }
    
    func endSelection() {
        // Empty selection
        selectionCache = [String: [TileType]]()
        selectionStartPos = nil
        selectionEndPos = nil
    }
    
    private func revertSelection(_ start: Position, _ end: Position) {
        // Get selection and revert all gridVMs to cached tiletype
        let selection = getSelection(start, end)
        for pos in selection {
            guard let prevTileType = selectionCache[getPosString(pos)] else {
                continue
            }
            // Revert
            let gridVM = gridViewModelArray[pos.getRow()][pos.getCol()]
            toggleGrid(gridVM, prevTileType[0])
            toggleGrid(gridVM, prevTileType[1])
        }
    }
    
    private func toggleSelection(_ start: Position, _ end: Position) {
        // Get selection and revert all gridVMs to cached tiletype
        let selection = getSelection(start, end)
        for pos in selection {
            let posString = getPosString(pos)
            let gridVM = gridViewModelArray[pos.getRow()][pos.getCol()]
            // Cache initial type if not cached
            if selectionCache[posString] == nil {
                selectionCache[posString] = [gridVM.platformType.value,
                                            gridVM.obstacleType.value]
            }
            // toggle
            toggleGrid(gridVM, selectionBrush)
        }
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
    
    private func getPosString(_ gridPos: Position) -> String {
        return String(gridPos.getRow()) + "," + String(gridPos.getCol())
    }
    
    private func setupObservables(_ gridVM: GridViewModel) {
        // Setup observation on gridVM tileType
        gridVM.platformType.asObservable().subscribe(onNext: {
            (newType) in
            self.updatePlatformArray(row: gridVM.gridPos.value.getRow(),
                                     col: gridVM.gridPos.value.getCol(),
                                     newType.rawValue)
        }).addDisposableTo(disposeBag)
        gridVM.obstacleType.asObservable().subscribe(onNext: { (newType) in
            self.updateObstacleArray(row: gridVM.gridPos.value.getRow(),
                                     col: gridVM.gridPos.value.getCol(),
                                     newType.rawValue)
        }).addDisposableTo(disposeBag)
    }
    
    private func getValidGrid(_ pos: (x: Float, y: Float)) -> GridViewModel? {
        // Identify grid
        let col = Int(pos.x / Tile.TILE_WIDTH)
        let row = Int(pos.y / Tile.TILE_WIDTH)
        // Check valid coord
        guard col >= 0 && col < LevelGrid.levelCols && row >= 0 && row < self.length else {
            return nil
        }
        return gridViewModelArray[row][col]
    }
    
    private func updatePlatformArray(row: Int, col: Int, _ newValue: Int) {
        platformArray[row][col] = newValue
    }
    
    private func updateObstacleArray(row: Int, col: Int, _ newValue: Int) {
        obstacleArray[row][col] = newValue
    }
}
