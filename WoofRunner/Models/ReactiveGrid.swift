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

/// The view component of the LevelGrid object. This object will hold all the ReactiveGridNodes that
/// are observing their respective GridViewModels contained in the same LevelGrid.
/// The ReactiveGrid will handle the rendering of its ReactiveGridNodes
class ReactiveGrid {
    
    let disposeBag = DisposeBag()
    
    //var gridRows: Int
    var gridNodes: [ReactiveGridNode]
    var gridVMArray: [[GridViewModel]]
    var grid: SCNNode
    
    init() {
        self.grid = SCNNode()
        self.gridNodes = [ReactiveGridNode]()
        self.gridVMArray = [[GridViewModel]]()
    }
    
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
    
    func updateGridNodes(_ gridVMArray: [[GridViewModel]]) {
        
        var delta = [GridViewModel]()
        let currentReactiveNodes = getReactiveNodePosArray(gridNodes)
        
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
        
        guard delta.count > 0 else {
            return
        }
        
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
    
    private func getReactiveNodePosArray(_ gridNodes: [ReactiveGridNode]) -> [Position] {
        let size = GameSettings.TILE_WIDTH
        var gridPosArray = [Position]()
        guard gridNodes.count > 0 else {
            return gridPosArray
        }
        gridPosArray = gridNodes.map { (node) -> Position in
            let pos = Position(row: Int(-node.position.z / size),
                               col: Int(node.position.x / size))
            return pos
        }
        return gridPosArray
    }
    
    func removeGrid() {
        self.grid.removeFromParentNode()
    }
    
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
