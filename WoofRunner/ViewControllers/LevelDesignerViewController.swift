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
import RxSwift
import RxCocoa

class LevelDesignerViewController: UIViewController {
    
    // Camera Settings
    static var cameraHeight: Float = 8.5
    static var cameraAngle: Float = 30.0
    static var cameraOffset: Float = 2.0
	
	let disposeBag = DisposeBag();

	let levelCols = 4
    let chunkLength = 20
    var LDScene = LevelDesignerScene()
    var sceneView = SCNView()
    var currentLevel = LevelGrid()
    var currentSelectedBrush: TileType = .floorLight // Observing overlayScene
    var spriteScene: LevelDesignerOverlayScene?

    private let gsm = GameStorageManager.getInstance()

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
        let sampleLevel = LevelGrid(length: 50)
        currentLevel = sampleLevel
        
        // Load level
        LDScene.loadLevel(currentLevel)
        sampleLevel.reloadChunk(from: 0)
        
        // Gestures
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view.addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
		// Attached overlay
		spriteScene = LevelDesignerOverlayScene(size: self.view.frame.size)
        guard let skScene = spriteScene else {
            return
        }
		sceneView.overlaySKScene = spriteScene
		skScene.currentTileSelection.asObservable()
			.subscribe(onNext: {
				(brush) in
				self.currentSelectedBrush = brush
			}
			).addDisposableTo(disposeBag);
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
    private func canEdit() -> Bool {
        guard let skScene = spriteScene else {
            return true
        }
        return skScene.overlayMenu.alpha == 0
    }
    
    func handlePan(_ sender: UIPanGestureRecognizer) {
        if (!canEdit()) {
            return
        }
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
            if (newPos.y >= -LevelDesignerViewController.cameraOffset) {
                camera.position = newPos
            }
            let startRow = Int(camera.position.y + LevelDesignerViewController.cameraOffset / Tile.TILE_WIDTH)
            currentLevel.reloadChunk(from: startRow)
            break;
        default:
            break;
        }
    }

    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        if (!canEdit()) {
            return
        }
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
                return currentLevel.toggleGrid(x: gridNode.position.x, y: gridNode.position.y, currentSelectedBrush)
            }
        }
    }

    /// Saves the current level into CoreData.
    private func saveGame() {
        gsm.saveGame(currentLevel)
    }

}
