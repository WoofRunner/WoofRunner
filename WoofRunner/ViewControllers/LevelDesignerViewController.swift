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

/// The LevelDesignerViewController is responsible for controlling all the feedback from
/// the view back to the models. It also contains the sceneKit scenes and spriteKit overlays
/// within.
class LevelDesignerViewController: UIViewController, LDOverlayDelegate {
	
	typealias BottomMenu = LDOverlaySceneConstants.BottomMenuConstants
	
    // Camera Settings
    static var cameraHeight: Float = 6.75
    static var cameraAngle: Float = -1.0
    static var cameraOffset: Float = 3.0
    static var paddingTiles: Float = 4.0
    static var panningSensitivity: Float = 15 // Default = 15
	
    // Level Designer Settings
    static var autoExtendLevel = true
    static var extensionLength = 10
    
	let disposeBag = DisposeBag();
    
    // Member Variables
    private var LDScene = LevelDesignerScene()
    private var sceneView = SCNView()
    private var currentLevel = LevelGrid()
    private var currentSelectedBrush: BrushSelection = BrushSelection.defaultSelection // Observing overlayScene
    private var longPress = false
    
    // Popup Dialog
	var currentLevelName = "Custom Level 1" // Default Name
    var spriteScene: LevelDesignerOverlayScene?

    // For Loading Levels
    private let gsm = GameStorageManager.getInstance()
	var loadedLevel: StoredGame?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialise sceneView for Level Designer Scene (LDScene)
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        sceneView.allowsCameraControl = false
        sceneView.showsStatistics = false
        sceneView.autoenablesDefaultLighting = true
        sceneView.isPlaying = true
        
        // Setup LDScene and add to sceneView
        LDScene.background.contents = UIImage(named: "art.scnassets/skybox01_cube.png") as UIImage!
        sceneView.scene = LDScene
        self.view.addSubview(sceneView)
		
        // Initialise empty level
		let sampleLevel = LevelGrid(length: 50)
		currentLevel = sampleLevel
		
		// Load a level if provided any from previous ViewController
		if let loadedLevel = loadedLevel {
			currentLevel.load(from: loadedLevel)
			
			// Update current level name to the one in the loadedLevel if it exists
			if let levelName = loadedLevel.name {
				currentLevelName = levelName
			}
		}

        // Load level and Render level
        LDScene.loadLevel(currentLevel)
        sampleLevel.reloadChunk(from: 0)
        
        // Setup Gestures
        setupGestures()
        
		// Attached overlay
		spriteScene = LevelDesignerOverlayScene(size: self.view.frame.size)
		spriteScene?.setDelegate(self)
        guard let skScene = spriteScene else {
            return
        }
		sceneView.overlaySKScene = spriteScene
		spriteScene?.updateDisplayedLevelName(currentLevelName)

        // Setup observer for currentTileSelection
		skScene.currentBrushSelection.asObservable()
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
    
    // Unload all resources when segue out of current VC.
    override func viewWillDisappear(_ animated: Bool) {
        LDScene.unloadScene()
        currentLevel.unloadLevel()
    }
    
    // MARK: Handle Gestures
    /**
     Allow UIPanGesture to scroll through the level vertically and handles the scroll
     distance and define the area to render.
     - parameter sender: UIPanGestureRecognizer
    */
    func handlePan(_ sender: UIPanGestureRecognizer) {
        if (!canEdit() || longPress) {
            return
        }
		// Prepare for panning; get camera position
        let camera = LDScene.cameraNode
        let translation = sender.translation(in: sceneView)

        // Pan distance + Panning Sensitivity
        let diffR = Float(translation.y / self.view.frame.height)
            * LevelDesignerViewController.panningSensitivity

        // Scrolling Logic
        switch sender.state {
            case .began:
                LDScene.cameraLocation = camera.position
                break;
            case .changed:
                // Only allow panning along z-axis
                let newPos = SCNVector3(LDScene.cameraLocation.x,
                                        LDScene.cameraLocation.y,
                                        LDScene.cameraLocation.z - diffR)
                if (newPos.z <= LevelDesignerViewController.cameraOffset) {
                    camera.position = newPos
                }
                // Add padding to near plane clipping
                let padding = GameSettings.TILE_WIDTH * LevelDesignerViewController.paddingTiles
                
                // Inform Level Grid to re-render level
                let startRow = Int(-camera.position.z +
                                    (LevelDesignerViewController.cameraOffset - padding) / GameSettings.TILE_WIDTH)
                updateCurrentLevel(from: startRow)
                break;
            default:
                break;
        }
    }

    /**
     Allow UITapGesture to toggle the tile if any, with the selected brush.
     - parameter sender: UITapGestureRecognizer
     */
    func handleTap(_ sender: UITapGestureRecognizer) {
        // Locked when Overlay Menu is active
        if (!canEdit()) {
            return
        }
		
        // Check what nodes are tapped
        let pos = sender.location(in: sceneView)
        // Ensure not tapping menu
        guard !isTappingMenu(tap_y: pos.y) else {
            return
        }
        let hitResults = sceneView.hitTest(pos, options: [:])
        
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // Attempt to toggle the node if it is a tile
            guard let toggleNode = getValidNode(hitResults) else {
                return
            }
            currentLevel.toggleGrid(x: toggleNode.position.x, z: toggleNode.position.z, currentSelectedBrush)
        }
    }
    
    /**
     Allow UILongPressGesture to activate bulk toggle mode. Handles the logic from
     begin selection for bulk toggle till end of selection.
     - parameter sender: UILongPressGestureRecognizer
     */
    func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        // Bulk Toggle Logic
        switch(sender.state) {
        case .began:
            // Lock scrolling when activated
            longPress = true
            let pos = sender.location(in: sceneView)
            let hitResults = sceneView.hitTest(pos, options: [:])
            
            // If long pressed on valid tile, begin selection
            guard hitResults.count > 0 else {
                longPress = false
                break
            }
            let selectedNode = getValidNode(hitResults)
            guard let startNode = selectedNode else {
                longPress = false
                break
            }
            // Toggle the initial grid before begin selection
            currentLevel.toggleGrid(x: startNode.position.x, z: startNode.position.z, currentSelectedBrush)
            // Special handler for moving platforms: Disallow
            guard isNotMovingPlatform(currentSelectedBrush) else {
                break;
            }
            currentLevel.beginSelection((x: startNode.position.x, z: startNode.position.z))
            break
        case .changed:
            // Update selection box
            let pos = sender.location(in: sceneView)
            let hitResults = sceneView.hitTest(pos, options: [:])
            guard hitResults.count > 0 else {
                longPress = false
                break
            }
            let selectedNode = getValidNode(hitResults)
            guard let currentNode = selectedNode else {
                longPress = false
                break
            }
            currentLevel.updateSelection((x: currentNode.position.x, z: currentNode.position.z))
            break
        default:
            // Terminate selection
            longPress = false
            currentLevel.endSelection()
            break
        }
    }
    
    // MARK: Helper Functions
    
    private func setupGestures() {
        // Pan Gesture: Scrolling
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view.addGestureRecognizer(panGesture)
        // Tap Gesture: Toggling Tile
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        // Long Press Gesture: Activate Bulk Edit
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        self.view.addGestureRecognizer(longPressGesture)
        
        // Prevent touchesCancelled from triggering to protect Overlay Menu functionality
        panGesture.cancelsTouchesInView = false
        tapGesture.cancelsTouchesInView = false
    }
    
    /// Locking function to prevent UI Taps falling through when Overlay Menu is active
    private func canEdit() -> Bool {
        guard let skScene = spriteScene else {
            return true
        }
        return skScene.overlayMenu.alpha == 0
    }
	
	/**
	Returns whether the input y coordinate is contained in the bounds of the BottomMenu 
	*/
    private func isTappingMenu(tap_y: CGFloat) -> Bool {
        let menuHeight = self.view.bounds.height - BottomMenu.barHeight / 2
        return tap_y > menuHeight
    }
    
    /// Update the current level view after changes to level model
    private func updateCurrentLevel(from startRow: Int) {
        if LevelDesignerViewController.autoExtendLevel {
            if startRow + LevelGrid.chunkLength > currentLevel.length {
                
                // Extend the level in bulk of {extensionLength}, reduce overhead
                let extend = startRow + LevelGrid.chunkLength - currentLevel.length
                            + LevelDesignerViewController.extensionLength - 1
                currentLevel.extendLevel(by: extend)
            }
        }
        currentLevel.reloadChunk(from: startRow)
    }
    
    /// Handle the logic to ensure that node tapped on is a valid tile node for toggling
    private func getValidNode(_ hitResults: [SCNHitTestResult]) -> SCNNode? {
        var togglingNode: SCNNode? = nil
        for result in hitResults {
            let resultantNode = result.node
            
            // Find GridNode
            if resultantNode.name != GridViewModel.gridNodeName {
                togglingNode = findParentGridNode(resultantNode)
            }
            
            guard let validNode = togglingNode else {
                continue
            }
            return validNode
        }
        return nil
    }
    
    /// Helper function to recursively look for parent nodes till a valid tile node is found
    private func findParentGridNode(_ node: SCNNode) -> SCNNode? {
        guard let parentNode = node.parent else {
            return nil
        }
        guard parentNode.name == GridViewModel.gridNodeName else {
            return findParentGridNode(parentNode)
        }
        
        return parentNode
    }
    
    /// Special handler to identify if moving platforms are currently selected
    private func isNotMovingPlatform(_ currentBrush: BrushSelection) -> Bool {
        guard currentBrush.selectionType == .platform else {
            return true
        }
        guard let tileModel = currentBrush.tileModel else {
            return true
        }
        guard let platform = tileModel as? PlatformModel else {
            return true
        }
        guard platform.platformBehaviour == .moving else {
            return true
        }
        return false
    }

    /// Saves the current level into CoreData.
    private func saveGame() {
		
		// Converts currentLevel to a storedGame objcet and set its levelName property
		let storedGame = currentLevel.toStoredGame()
		storedGame.name = self.currentLevelName

		// Save Game
        gsm.saveGame(storedGame)
            .onSuccess { _ in
				self.showSaveFeedback(title: "Save Success", message: "Game is successfully saved as \(self.currentLevelName)")
            }
            .onFailure { error in
                print("\(error.localizedDescription)")
                self.showSaveFeedback(title: "Save Failed", message: "Oops! An error occured while saving!")
        }
    }

	// - MARK: LDOverlayDelegate
	
	internal func saveLevel() {
		saveGame()
	}
	
	internal func renameLevel(_ name: String) {
		self.currentLevelName = name
		showRenameDialog()
	}
	
	internal func back() {
		showBackWarning()
	}

}
