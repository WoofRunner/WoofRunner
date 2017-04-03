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
        // Identify grid
        let col = Int(x / Tile.TILE_WIDTH)
        let row = Int(y / Tile.TILE_WIDTH)
        // Check valid coord
        guard col >= 0 && col < LevelGrid.levelCols && row >= 0 && row < self.length else {
            return
        }
        let gridVM = gridViewModelArray[row][col]
        
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
    
    func beginSelection(_ pos: (x: Float, y: Float)) {
        // Identify grid
        let col = Int(pos.x / Tile.TILE_WIDTH)
        let row = Int(pos.y / Tile.TILE_WIDTH)
        // Check valid coord
        guard col >= 0 && col < LevelGrid.levelCols && row >= 0 && row < self.length else {
            return
        }
        print(row, col)
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
    
    private func updatePlatformArray(row: Int, col: Int, _ newValue: Int) {
        platformArray[row][col] = newValue
    }
    
    private func updateObstacleArray(row: Int, col: Int, _ newValue: Int) {
        obstacleArray[row][col] = newValue
    }
}
