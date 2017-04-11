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

/// Creates a LevelGrid object that holds the GridViewModels in the level. 
/// It also supports saving and loading of the level into StoredGameObject in CoreData. 
/// The LevelGrid object also takes in calls from the View Controller to propagate down updates to the level.
class LevelGrid {

    var disposeBag = DisposeBag()
    
    // Constants
    static let levelCols = GameSettings.PLATFORM_COLUMNS
    static let chunkLength = 20
    
    // Member variables
    var length: Int
    var platformArray: [[PlatformModel?]]
    var obstacleArray: [[ObstacleModel?]]
    // GridViewModelArray observed by ReactiveGrid
    var gridViewModelArray: Variable<[[GridViewModel]]>
    
    // Selection extension variables
    var selectionCache = [String: [TileModel?]]()
    var selectionStartPos: Position?
    var selectionEndPos: Position?
    var selectionTemplate: [TileModel?] = [nil, nil]
    
    // MARK: - SaveableGame
    var storedGame: StoredGame?
    
    /**
     Creates an empty level of specifed length number of rows.
     This will generate rows of empty platforms and obstacles.
     - parameter length: Number of rows
     */
    init(length: Int) {
        // Populate arrays
        self.length =  length
        self.platformArray = [[PlatformModel?]](repeating: [PlatformModel?](repeating: nil,
                                                                            count: LevelGrid.levelCols),
                                                count: length)
        self.obstacleArray = [[ObstacleModel?]](repeating: [ObstacleModel?](repeating: nil,
                                                                            count: LevelGrid.levelCols),
                                                count: length)
        self.gridViewModelArray = Variable<[[GridViewModel]]>([[GridViewModel]](repeating: [GridViewModel](repeating: GridViewModel(),
                                                                                                           count: LevelGrid.levelCols),
                                                                                count: length))
        
        guard length > 0 else {
            return
        }
        
        // Initialise empty level
        for row in 0...length - 1 {
            for col in 0...LevelGrid.levelCols - 1 {
                let gridVM = GridViewModel(row: row, col: col)
                setupObservables(gridVM)
                // Append to array
                gridViewModelArray.value[row][col] = gridVM
            }
        }
    }
    
    convenience init() {
        self.init(length: 0);
    }
    
    /**
     Toggles the grid on the specified scene coordinates with the specified brush selection object
     - parameter x: x coordinate of the tapped scene object
     - parameter z: z coordinate of the tapped scene object
     - parameter currentSelectedBrush: Brush selection object that holds the brush type and selection type
     - note:
        y coordinate of the tapped object is ignored as the level has to be planar.
     */
    func toggleGrid(x: Float, z: Float, _ currentSelectedBrush: BrushSelection) {
        guard let gridVM = getValidGrid((x: x, z: z)) else {
            return
        }
        return toggleGrid(gridVM, currentSelectedBrush)
    }
    
    /**
     Toggles the grid for the specified GridViewModel object with the specified brush selection object
     - parameter gridVM: GridViewModel object to be toggled
     - parameter currentSelectedBrush: Brush selection object that holds the brush type and selection type
     */
    func toggleGrid(_ gridVM: GridViewModel, _ currentSelectedBrush: BrushSelection) {
        if currentSelectedBrush.selectionType == .delete {
            gridVM.removeTop()
            return
        }
        
        let tileModel = currentSelectedBrush.tileModel
        // Toggle grid with platform / obstacle
        if let platform = tileModel as? PlatformModel {
            // Custom handler for moving platforms
            guard platform.platformBehaviour != .moving else {
                return postProcessMovingPlatform(gridVM.gridPos.value.getRow(),
                                                 platform)
            }
            gridVM.setPlatform(platform)
        } else if let obstacle = tileModel as? ObstacleModel {
            guard let _ = gridVM.platformType.value else {
                return
            }
            gridVM.setObstacle(obstacle)
        }
    }
    
    /**
     Reloads the scene from the specified start row to toggle which grid node to render
     - parameter startRow: The row number to render from
     - note: The rows that will be rendered will be [chunkLength] from the startRow
     - complexity: O(n^2) where n is the number of rows in the level. 
     Optimised by checking if current grid node is already rendered instead of naively
     re-rendering all grid nodes.
     */
    func reloadChunk(from startRow: Int) {
        
        let endRow = startRow + LevelGrid.chunkLength
        
        for gridVMRow in gridViewModelArray.value {
            for gridVM in gridVMRow {
                if gridVM.gridPos.value.getRow() >= startRow &&
                    gridVM.gridPos.value.getRow() < endRow {
                    renderGridVM(gridVM, true)
                } else {
                    renderGridVM(gridVM, false)
                }
            }
        }
    }
    
    /**
     Extends the level length by the specified number of rows.
     - parameter extend: Number of rows to extend by
     - note: This function is expensive as it will attempt to render large number of grid nodes to the level grid.
     Advised to extend by bulk amount to reduce overhead.
     */
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
        var extendedGridVMArray = [[GridViewModel]](repeating: [GridViewModel](repeating: GridViewModel(),
                                                                               count: LevelGrid.levelCols),
                                                    count: extend)
        
        // Initialise extended array data
        for row in length...length + extend - 1 {
            for col in 0...LevelGrid.levelCols - 1 {
                let gridVM = GridViewModel(row: row, col: col)
                setupObservables(gridVM)
                
                // Populate array
                extendedGridVMArray[row - length][col] = gridVM
            }
        }
        
        // Append to gridVMArray in one transcation to reduce update counts on rxVariable
        self.gridViewModelArray.value
            .append(contentsOf: extendedGridVMArray)
        
        // Update level length
        self.length += extend
    }
    
    /// Unloads the level by de-referencing
    func unloadLevel() {
        platformArray = [[PlatformModel]]()
        obstacleArray = [[ObstacleModel]]()
        gridViewModelArray = Variable<[[GridViewModel]]>([[GridViewModel]]())
        storedGame = nil
    }
    
    // MARK: Helper Functions
    
    internal func getValidGrid(_ pos: (x: Float, z: Float)) -> GridViewModel? {
        // Identify grid
        let col = Int(pos.x / GameSettings.TILE_WIDTH)
        let row = Int(-pos.z / GameSettings.TILE_WIDTH)
        // Check valid coord
        guard col >= 0 && col < LevelGrid.levelCols && row >= 0 && row < self.length else {
            return nil
        }
        return gridViewModelArray.value[row][col]
    }

    // Setup observers for grid view model's tileModel attribute to update 
    // platform and obstacle array which will be used for saving the level
	internal func setupObservables(_ gridVM: GridViewModel) {
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
    
    // Special handler used for moving platforms to ensure that replace the entire row
    internal func postProcessMovingPlatform(_ row: Int, _ movingPlatform: PlatformModel) {
        for gridVM in gridViewModelArray.value[row] {
            setGridVMType(gridVM, platform: nil, obstacle: nil)
        }
        let middleCol = (LevelGrid.levelCols / 2)
        let middleGridVM = gridViewModelArray.value[row][middleCol]
        setGridVMType(middleGridVM, platform: movingPlatform, obstacle: nil)
    }
    
    internal func setGridVMType(_ gridVM: GridViewModel, platform: PlatformModel?, obstacle: ObstacleModel?) {
        gridVM.setType(platform: platform, obstacle: obstacle)
    }
    
    private func renderGridVM(_ gridVM: GridViewModel, _ condition: Bool) {
        if gridVM.shouldRender.value != condition {
            gridVM.shouldRender.value = condition
        }
    }

    private func updatePlatformArray(row: Int, col: Int, _ newModel: PlatformModel?) {
        platformArray[row][col] = newModel
    }
    
    private func updateObstacleArray(row: Int, col: Int, _ newModel: ObstacleModel?) {
        obstacleArray[row][col] = newModel
    }
}
