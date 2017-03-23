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
	//var sceneView: LevelDesignerSceneView!

    override func viewDidLoad() {
        super.viewDidLoad()
        levelDesignerSceneView.setupScene()
		print(levelDesignerSceneView.frame.width, levelDesignerSceneView.frame.height);
		print(self.view.frame.width, self.view.frame.height)
		
		levelDesignerSceneView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
		
		print(levelDesignerSceneView.frame.width, levelDesignerSceneView.frame.height);
		
        // Create sample level
        let sampleLevel = LevelGridStub(length: 50)
        
        // Load level
        levelDesignerSceneView.loadLevel(sampleLevel)
        
        let newTile = TileStub(position: SCNVector3(1, 0, 0), size: 2.0, tileType: 0)
        let tileVM = TileViewModel(newTile)
        let tileNode = TileNode(tileVM)
        print("before - ", tileNode.position)
        tileVM.position.value = SCNVector3(2, 0, 0)
        print("after - ", tileNode.position)
		
		
		// Create and attach main Scenekit Scene
		//sceneView.setupScene()
		
		//sceneView.loadLevel(sampleLevel)
		//self.mainSceneView.scene = ExperimentalMainScene()
		self.view.addSubview(levelDesignerSceneView)
		
		// Attached overlay
		let spriteScene = LevelDesignerOverlayScene(size: self.view.bounds.size)
		levelDesignerSceneView.overlaySKScene = spriteScene

    }
    
    
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
