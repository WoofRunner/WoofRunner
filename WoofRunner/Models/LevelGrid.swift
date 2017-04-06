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
    
    static var levelCols = GameSettings.PLATFORM_COLUMNS
    static var chunkLength = 20
    
    var length: Int
    var platformArray: [[Int]]
    var obstacleArray: [[Int]]
    var gridViewModelArray: [[GridViewModel]]
    
    // Selection extension usage
    var selectionCache = [String: [TileType]]()
    var selectionStartPos: Position?
    var selectionEndPos: Position?
    var selectionTemplate = [TileType.none, TileType.none]
    
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
    
    func toggleGrid(x: Float, z: Float, _ currentSelectedBrush: TileType) {
        guard let gridVM = getValidGrid((x: x, z: z)) else {
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
    
    func getValidGrid(_ pos: (x: Float, z: Float)) -> GridViewModel? {
        // Identify grid
        let col = Int(pos.x / GameSettings.TILE_WIDTH)
        let row = Int(-pos.z / GameSettings.TILE_WIDTH)
        // Check valid coord
        guard col >= 0 && col < LevelGrid.levelCols && row >= 0 && row < self.length else {
            return nil
        }
        return gridViewModelArray[row][col]
    }
    
	func setupObservables(_ gridVM: GridViewModel) {
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

    private func updatePlatformArray(row: Int, col: Int, _ newValue: Int) {
        platformArray[row][col] = newValue
    }
    
    private func updateObstacleArray(row: Int, col: Int, _ newValue: Int) {
        obstacleArray[row][col] = newValue
    }
}
