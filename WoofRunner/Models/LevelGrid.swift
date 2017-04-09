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
	var platformArray: [[PlatformModel?]]
	var obstacleArray: [[ObstacleModel?]]
    var gridViewModelArray: [[GridViewModel]]
    
    // Selection extension usage
	var selectionCache = [String: [TileModel?]]()
    var selectionStartPos: Position?
    var selectionEndPos: Position?
	var selectionTemplate: [TileModel?] = [nil, nil]
	
    init(length: Int) {
        self.length = length
		self.platformArray = [[PlatformModel?]](repeating: [PlatformModel?](repeating: nil,
		                                                                    count: LevelGrid.levelCols),
		                                        count: length)
		self.obstacleArray = [[ObstacleModel?]](repeating: [ObstacleModel?](repeating: nil,
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
    
    func toggleGrid(x: Float, z: Float, _ currentSelectedBrush: BrushSelection) {
        guard let gridVM = getValidGrid((x: x, z: z)) else {
            return
        }
        return toggleGrid(gridVM, currentSelectedBrush)
    }
    
	func toggleGrid(_ gridVM: GridViewModel, _ currentSelectedBrush: BrushSelection) {
		if currentSelectedBrush.selectionType == .delete {
			// Delete Brush
			gridVM.removeTop()
		}
		
		let tileModel = currentSelectedBrush.tileModel

		// Toggle grid with platform / obstacle
		if let platform = tileModel as? PlatformModel {
			gridVM.setPlatform(platform)
		} else if let obstacle = tileModel as? ObstacleModel {
			if gridVM.platformType.value != nil {
				gridVM.setObstacle(obstacle)
			}
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
		let extendedPlatformArray = [[PlatformModel?]](repeating: [PlatformModel?](repeating: nil,
		                                                                           count: LevelGrid.levelCols),
		                                               count: extend)
        self.platformArray.append(contentsOf: extendedPlatformArray)
		let extendedObstacleArray = [[ObstacleModel?]](repeating: [ObstacleModel?](repeating: nil,
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
			(newModel) in
            self.updatePlatformArray(row: gridVM.gridPos.value.getRow(),
                                     col: gridVM.gridPos.value.getCol(),
                                     newModel)
        }).addDisposableTo(disposeBag)
		gridVM.obstacleType.asObservable().subscribe(onNext: {
			(newModel) in
            self.updateObstacleArray(row: gridVM.gridPos.value.getRow(),
                                     col: gridVM.gridPos.value.getCol(),
                                     newModel)
        }).addDisposableTo(disposeBag)
    }
    
    // Used for moving platforms
    internal func postProcessMovingPlatform(_ row: Int, _ movingPlatform: PlatformModel) {
        for gridVM in gridViewModelArray[row] {
            setGridVMType(gridVM, platform: nil, obstacle: nil)
        }
        let middleCol = (LevelGrid.levelCols / 2)
        let middleGridVM = gridViewModelArray[row][middleCol]
        setGridVMType(middleGridVM, platform: movingPlatform, obstacle: nil)
    }
    
    internal func setGridVMType(_ gridVM: GridViewModel, platform: PlatformModel?, obstacle: ObstacleModel?) {
        gridVM.setType(platform: platform!, obstacle: obstacle!)
    }

    private func updatePlatformArray(row: Int, col: Int, _ newModel: PlatformModel?) {
        platformArray[row][col] = newModel
    }
    
    private func updateObstacleArray(row: Int, col: Int, _ newModel: ObstacleModel?) {
        obstacleArray[row][col] = newModel
    }
}
