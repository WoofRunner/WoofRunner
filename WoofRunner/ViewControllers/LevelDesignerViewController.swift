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
    var currentSelectedBrush: TileType = .floor // Observing overlayScene

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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
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
    
    private func toggleGrid(x: Float, y: Float) {
        for gridVM in currentLevel {
            guard gridVM.position.value.x == x && gridVM.position.value.y == y else {
                continue
            }
            if currentSelectedBrush.isPlatform() {
                gridVM.setPlatform(currentSelectedBrush)
            } else if currentSelectedBrush.isObstacle() && gridVM.platformType.value != TileType.none {
                gridVM.setPlatform(currentSelectedBrush)
            } else if currentSelectedBrush == TileType.none {
                // Current implementation: Delete both obstacle and platform
                gridVM.removePlatform()
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

    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // Check what nodes are tapped
        let pos = gestureRecognize.location(in: sceneView)
        let hitResults = sceneView.hitTest(pos, options: [:])
        
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            for result in hitResults {
                // Check if node is transparent
                let gridNode = result.node
                guard gridNode.geometry?.firstMaterial?.transparency != 0 else {
                    continue
                }
                // Else toggle
                return toggleGrid(x: gridNode.position.x, y: gridNode.position.y)
            }
        }
    }
}
