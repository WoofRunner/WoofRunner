//
//  ReactiveGrid.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 24/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SceneKit
import RxSwift
import RxCocoa

/// The view component of the LevelGrid object for the Level Designer. 
/// This object will hold all the ReactiveGridNodes that are observing 
/// their respective GridViewModels contained in the same LevelGrid.
/// The ReactiveGrid will handle the rendering of its ReactiveGridNodes
class ReactiveGrid {
    
    let disposeBag = DisposeBag()
    
    //var gridRows: Int
    var gridSize: Float = GameSettings.TILE_WIDTH
    var gridNodes: [ReactiveGridNode]
    var gridVMArray: [[GridViewModel]]
    var grid: SCNNode
    
    /// Creates an empty Reactive Grid that holds a parent grid node
    init() {
        self.grid = SCNNode()
        self.gridNodes = [ReactiveGridNode]()
        self.gridVMArray = [[GridViewModel]]()
    }
    
    /// Creates a Reactive Grid that observes the specified LevelGrid object.
    /// - Parameters: 
    ///     - levelGrid: The level grid object hold an array of grid view models
    init(levelGrid: LevelGrid) {
        self.grid = SCNNode()
        self.gridNodes = [ReactiveGridNode]()
        self.gridVMArray = levelGrid.gridViewModelArray.value
        updateGridNodes(gridVMArray)
        
        // Subscribe to gridViewModelArray
        levelGrid.gridViewModelArray.asObservable()
            .subscribe(onNext:
                {
                    (gridVMArray) in
                    self.updateGridNodes(gridVMArray)
            }).addDisposableTo(disposeBag)
        
    }
    
    /// Removes the current grid node from the scene.
    public func removeGrid() {
        self.grid.removeFromParentNode()
    }
    
    /// Unloads the resources used by grid and its components
    public func unloadGrid() {
        for gridNode in gridNodes {
            gridNode.unloadGridNode()
        }
        // Refresh all references
        self.grid = SCNNode()
        self.gridNodes = [ReactiveGridNode]()
        self.gridVMArray = [[GridViewModel]]()
        // Unload self
        removeGrid()
    }
    
    /// Called when the observed levelGrid has changed
    /// Will process the delta grid view models and append them to the rxGrid
    /// Usually called during extension of the level
    private func updateGridNodes(_ gridVMArray: [[GridViewModel]]) {
        // Map current reactive nodes into array of Positions
        var delta = [GridViewModel]()
        let currentReactiveNodes = getReactiveNodePosArray(gridNodes)
        
        // Filter for grid view models that do not exist in current reactive nodes
        for gridVMRow in gridVMArray {
            for gridVM in gridVMRow {
                if !currentReactiveNodes.contains(where: { (pos) -> Bool in
                    return pos.getRow() == gridVM.gridPos
                                                    .value
                                                    .getRow() &&
                            pos.getCol() == gridVM.gridPos
                                                    .value
                                                    .getCol()
                }) {
                    delta.append(gridVM)
                }
            }
        }
        
        // Early termination
        guard delta.count > 0 else {
            return
        }
        
        // Append nad observe new grid view models
        for gridVM in delta {
            let rxGridNode = ReactiveGridNode(gridVM)
            if rxGridNode.shouldRender.value {
                grid.addChildNode(rxGridNode.platformNode.value)
                grid.addChildNode(rxGridNode.obstacleNode.value)
            }
            setupObservables(rxGridNode)
            gridNodes.append(rxGridNode)
        }
    }
    
    /// Maps each reactive grid node into its corresponding Position struct.
    /// - Returns: An array of Positions for each rxGridNode in rxGrid.
    private func getReactiveNodePosArray(_ gridNodes: [ReactiveGridNode]) -> [Position] {
        
        var gridPosArray = [Position]()
        guard gridNodes.count > 0 else {
            return gridPosArray
        }
        gridPosArray = gridNodes.map { (node) -> Position in
            let pos = Position(row: Int(-node.position.z / gridSize),
                               col: Int(node.position.x / gridSize))
            return pos
        }
        return gridPosArray
    }
    
    /// Setup observers for grid view model's render condition
    private func setupObservables(_ gridNode: ReactiveGridNode) {
        gridNode.shouldRender.asObservable()
            .subscribe(onNext: {
                (render) in
                if render {
                    self.grid.addChildNode(gridNode.platformNode.value)
                    self.grid.addChildNode(gridNode.obstacleNode.value)
                } else {
                    gridNode.platformNode.value.removeFromParentNode()
                    gridNode.obstacleNode.value.removeFromParentNode()
                }
            }).addDisposableTo(disposeBag)
    }
}
