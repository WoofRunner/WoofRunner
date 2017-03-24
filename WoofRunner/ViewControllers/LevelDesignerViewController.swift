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

	let levelCols = 4
    let chunkLength = 10
    var LDScene = LevelDesignerScene()
    var sceneView = SCNView()
    var currentLevel = [GridViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        sceneView.allowsCameraControl = false
        sceneView.showsStatistics = true
        sceneView.backgroundColor = UIColor.black
        sceneView.isPlaying = true
        
        sceneView.scene = LDScene
        self.view.addSubview(sceneView)
		
        // Create sample level
        let sampleLevel = createEmptyLevel(length: 50)
        currentLevel = sampleLevel
        
        // Load level
        LDScene.loadLevel(currentLevel)
        reloadChunk(currentLevel, from: 0)
        
        // Gestures
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view.addGestureRecognizer(panGesture)
		
		// Create and attach main Scenekit Scene
		//sceneView.setupScene()
		
		//sceneView.loadLevel(sampleLevel)
		//self.mainSceneView.scene = ExperimentalMainScene()
		//self.view.addSubview(levelDesignerSceneView)
		
		// Attached overlay
		let spriteScene = LevelDesignerOverlayScene(size: self.view.frame.size)
		sceneView.overlaySKScene = spriteScene

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
            return .portrait
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: Helper Functions
    
    private func createEmptyLevel(length: Int) -> [GridViewModel] {
        var emptyLevel = [GridViewModel]()
        
        guard length > 0 else {
            return emptyLevel
        }
        
        for row in 0...length-1 {
            for col in 0...levelCols-1 {
                let gridVM = GridViewModel(SCNVector3(CGFloat(col) * Tile.TILE_WIDTH, CGFloat(row) * Tile.TILE_WIDTH, 0))
                emptyLevel.append(gridVM)
            }
        }
        
        return emptyLevel
    }
    
    private func reloadChunk(_ level: [GridViewModel], from row: Int) {
        let startPt: Float = Float(row) * Float(Tile.TILE_WIDTH)
        let endPt: Float = Float(row + chunkLength) * Float(Tile.TILE_WIDTH)
        
        for gridVM in level {
            if gridVM.position.value.y >= startPt && gridVM.position.value.y < endPt {
                gridVM.shouldRender.value = true
            } else {
                gridVM.shouldRender.value = false
            }
        }
    }
    
    func handlePan(_ sender: UIPanGestureRecognizer) {
        let camera = LDScene.cameraNode

        let translation = sender.translation(in: sceneView)

        let location = sender.location(in: sceneView)
        let secLocation = CGPoint(x: location.x + translation.x,
                                  y: location.y + translation.y)

        let P1 = sceneView.unprojectPoint(SCNVector3(x: Float(location.x), y: Float(location.y), z: 0.0))
        let P2 = sceneView.unprojectPoint(SCNVector3(x: Float(location.x), y: Float(location.y), z: 1.0))

        let Q1 = sceneView.unprojectPoint(SCNVector3(x: Float(secLocation.x), y: Float(secLocation.y), z: 0.0))
        let Q2 = sceneView.unprojectPoint(SCNVector3(x: Float(secLocation.x), y: Float(secLocation.y), z: 1.0))

        let t1 = -P1.z / (P2.z - P1.z)
        let y1 = P1.y + t1 * (P2.y - P1.y)
        let P0 = SCNVector3Make(0, y1,0)
        let y2 = Q1.y + t1 * (Q2.y - Q1.y)
        let Q0 = SCNVector3Make(0, y2, 0)
        let diffR = P0.y - Q0.y

        switch sender.state {
        case .began:
            LDScene.cameraLocation = camera.position
            break;
        case .changed:
            let newPos = SCNVector3(LDScene.cameraLocation.x,
                                    LDScene.cameraLocation.y + diffR,
                                    LDScene.cameraLocation.z)
            if (newPos.y >= -5.0) {
                camera.position = newPos
            }
            let startRow = Int(camera.position.y + 5.0 / Float(Tile.TILE_WIDTH))
            reloadChunk(currentLevel, from: startRow)
            break;
        default:
            break;
        }
    }

}

//class LevelGridStub {
//    
//    var cols = 4
//    var rows: Int
//    var levelGrid: [GridStub]
//    
//    init(length: Int) {
//        levelGrid = [GridStub]()
//        rows = length
//        createEmptyLevel()
//    }
//    
//    func createEmptyLevel() {
//        for row in 0...rows - 1 {
//            for col in 0...cols - 1 {
//                let tagNumber = col + (row * cols)
//                levelGrid.append(GridStub(row: row, col: col, tag: tagNumber))
//            }
//        }
//    }
//    
//    func loadChunk(start: Int, chunkLength: Int) {
//        for grid in levelGrid {
//            if grid.position.row >= start && grid.position.row < start + chunkLength {
//                grid.shouldRender = true
//            } else {
//                grid.shouldRender = false
//            }
//        }
//    }
//}
