//
//  LevelDesignerViewController.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 12/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class LevelDesignerViewController: UIViewController {
    
    @IBOutlet weak var levelDesignerSceneView: LevelDesignerSceneView!

    override func viewDidLoad() {
        super.viewDidLoad()
        levelDesignerSceneView.setupScene()
        
        // Create sample level
        let sampleLevel = LevelGridStub(length: 50)
        
        // Load level
        levelDesignerSceneView.loadLevel(sampleLevel)
    }
    
//    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
//        // retrieve the SCNView
//        guard let scnView = sceneView else {
//            return
//        }
//        
//        // check what nodes are tapped
//        let p = gestureRecognize.location(in: scnView)
//        let hitResults = scnView.hitTest(p, options: [:])
//        // check that we clicked on at least one object
//        if hitResults.count > 0 {
//            // retrieved the first clicked object
//            let result: AnyObject = hitResults[0]
//            
//            // get its material
//            let material = result.node!.geometry!.firstMaterial!
//            
//            // highlight it
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 0.5
//            
//            // on completion - unhighlight
//            SCNTransaction.completionBlock = {
//                SCNTransaction.begin()
//                SCNTransaction.animationDuration = 0.5
//                
//                material.emission.contents = UIColor.black
//                
//                SCNTransaction.commit()
//            }
//            
//            material.emission.contents = UIColor.red
//            
//            SCNTransaction.commit()
//        }
//    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}

class LevelGridStub {
    
    var cols = 4
    var rows: Int
    var levelGrid: [GridStub]
    
    init(length: Int) {
        levelGrid = [GridStub]()
        rows = length
        createEmptyLevel()
    }
    
    func createEmptyLevel() {
        for row in 0...rows - 1 {
            for col in 0...cols - 1 {
                let tagNumber = col + (row * cols)
                levelGrid.append(GridStub(row: row, col: col, tag: tagNumber))
            }
        }
    }
    
    func loadChunk(start: Int, chunkLength: Int) {
        for grid in levelGrid {
            if grid.position.row >= start && grid.position.row < start + chunkLength {
                grid.shouldRender = true
            } else {
                grid.shouldRender = false
            }
        }
    }
}
