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
import PopupDialog

class LevelDesignerViewController: UIViewController, LDOverlayDelegate {
    
    // Camera Settings
    static var cameraHeight: Float = 8.5
    static var cameraAngle: Float = 30.0
    static var cameraOffset: Float = 2.0
    static var paddingTiles: Float = 2.0
	
    // Level Designer Settings
    static var autoExtendLevel = true
    static var extensionLength = 10
    
	let disposeBag = DisposeBag();

	let levelCols = 4
    let chunkLength = 15
    var LDScene = LevelDesignerScene()
    var sceneView = SCNView()
    var currentLevel = LevelGrid()
    var currentSelectedBrush: TileType = .floorLight // Observing overlayScene
	var currentLevelName = "Custom Level 1" // Default Name
    var spriteScene: LevelDesignerOverlayScene?
    var longPress = false

    private let gsm = GameStorageManager.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        sceneView.allowsCameraControl = false
        sceneView.showsStatistics = true
        // sceneView.backgroundColor = UIColor.black
        sceneView.autoenablesDefaultLighting = true
        sceneView.isPlaying = true
        
        LDScene.background.contents = UIImage(named: "art.scnassets/skybox01_cube.png") as UIImage!
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
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        self.view.addGestureRecognizer(longPressGesture)
		panGesture.cancelsTouchesInView = false // Turn this property to prevent touchesCancelled from happening
		tapGesture.cancelsTouchesInView = false
        
		// Attached overlay
		spriteScene = LevelDesignerOverlayScene(size: self.view.frame.size)
		spriteScene?.setDelegate(self)
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
    
    func handlePan(_ sender: UIPanGestureRecognizer) {
        if (!canEdit() || longPress) {
            return
        }
		
        let camera = LDScene.cameraNode
        let translation = sender.translation(in: sceneView)

        let location = sender.location(in: sceneView)
        let secLocation = CGPoint(x: location.x + translation.x,
                                  y: location.y + translation.y)
        // Project tap to scene
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
            // Add padding to near plane clipping
            let padding = -Tile.TILE_WIDTH * LevelDesignerViewController.paddingTiles
            let startRow = Int(camera.position.y + (LevelDesignerViewController.cameraOffset + padding) / Tile.TILE_WIDTH)
            updateCurrentLevel(from: startRow)
            break;
        default:
            break;
        }
    }

    func handleTap(_ sender: UIGestureRecognizer) {
        if (!canEdit()) {
            return
        }
		
        // Check what nodes are tapped
        let pos = sender.location(in: sceneView)
        let hitResults = sceneView.hitTest(pos, options: [:])
        
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            guard let toggleNode = getValidNode(hitResults) else {
                return
            }
            currentLevel.toggleGrid(x: toggleNode.position.x, y: toggleNode.position.y, currentSelectedBrush)
        }
    }
    
    // Bulk Toggle
    func handleLongPress(_ sender: UIGestureRecognizer) {
        switch(sender.state) {
        case .began:
            print("began")
            longPress = true
            let pos = sender.location(in: sceneView)
            let hitResults = sceneView.hitTest(pos, options: [:])
            
            guard hitResults.count > 0 else {
                longPress = false
                break
            }
            let selectedNode = getValidNode(hitResults)
            guard let startNode = selectedNode else {
                longPress = false
                break
            }
            currentLevel.toggleGrid(x: startNode.position.x, y: startNode.position.y, currentSelectedBrush)
            currentLevel.beginSelection((x: startNode.position.x, y: startNode.position.y))
            break
        case .changed:
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
            currentLevel.updateSelection((x: currentNode.position.x, y: currentNode.position.y))
            break
        default:
            longPress = false
            currentLevel.endSelection()
            print("ended")
            break
        }
    }
    
    // MARK: Helper Functions
    private func canEdit() -> Bool {
        guard let skScene = spriteScene else {
            return true
        }
        return skScene.overlayMenu.alpha == 0
    }
    
    // Update the current level view after changes to level model
    private func updateCurrentLevel(from startRow: Int) {
        if LevelDesignerViewController.autoExtendLevel {
            if startRow + chunkLength > currentLevel.length {
                // Extend the level in bulk of {extensionLength}, reduce overhead
                let extend = startRow + chunkLength - currentLevel.length
                            + LevelDesignerViewController.extensionLength - 1
                let originalLength = currentLevel.length
                currentLevel.extendLevel(by: extend)
                LDScene.updateLevel(currentLevel, from: originalLength)
            }
        }
        currentLevel.reloadChunk(from: startRow)
    }
    
    // Handle the logic for toggling of grid nodes
    private func getValidNode(_ hitResults: [SCNHitTestResult]) -> SCNNode? {
        let togglingNode: SCNNode?
        for result in hitResults {
            let resultantNode = result.node
            // Skip if node is transparent
            guard resultantNode.geometry?.firstMaterial?.transparency != 0 else {
                continue
            }
            // Take parent is node is a model
            if resultantNode.name == GridViewModel.modelNodeName {
                guard let parentNode = resultantNode.parent else {
                    continue
                }
                togglingNode = parentNode
            } else {
                // Else toggle node
                togglingNode = resultantNode
            }
            
            return togglingNode
        }
        return nil
    }

    /// Saves the current level into CoreData.
    private func saveGame() {
        gsm.saveGame(currentLevel)
            .onSuccess { _ in
				self.showSaveFeedback(title: "Save Success", message: "Game is successfully saved as \(self.currentLevelName)")
            }
            .onFailure { error in
                print("\(error.localizedDescription)")
                self.showSaveFeedback(title: "Save Failed", message: "Oops! An error occured while saving!")
        }
    }
	
	// - MARK: Popup Dialogs
	
	private func showSaveFeedback(title: String, message: String) {
		let popup = PopupDialog(title: title, message: message, image: nil)
		
		let okBtn = DefaultButton(title: "OK") {
			popup.dismiss()
		}
		
		// Add buttons to dialog
		popup.addButton(okBtn)
		
		// Customising Dialog Style
		customisePopupDialog()

		self.present(popup, animated: true, completion: nil)
	}
	
	private func showBackWarning() {
		let popup = PopupDialog(title: "Warning", message: "Any unsaved changes will be lost, proceed anyway?", image: nil)
		
		let okBtn = DefaultButton(title: "OK") {
			self.dismiss(animated: true, completion: nil)
		}
		
		let cancelBtn = CancelButton(title: "CANCEL") {
			popup.dismiss()
		}
		
		// Add buttons to dialog
		popup.addButtons([okBtn, cancelBtn])
		
		// Customising Dialog Style
		customisePopupDialog()
		
		self.present(popup, animated: true, completion: nil)
	}
	
	private func showRenameDialog() {
		// Create a custom view controller
		let renameVC = RenameDialogViewController()
		
		// Create the dialog
		let popup = PopupDialog(viewController: renameVC, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false)
		
		// Configure and add buttons
		let cancelBtn = CancelButton(title: "CANCEL", height: 60) {
			popup.dismiss()
		}
		
		let okBtn = DefaultButton(title: "OK", height: 60) {
			self.currentLevelName = renameVC.getLevelName()
		}
	
		popup.addButtons([cancelBtn, okBtn])
		customiseDialogButtons()
		
		// Present dialog
		present(popup, animated: true, completion: nil)
	}
	
	private func customisePopupDialog() {
		customiseDialogAppearance()
		customiseDialogOverlayAppearance()
		customiseDialogButtons()
	}
	
	private func customiseDialogAppearance() {
		let dialogAppearance = PopupDialogDefaultView.appearance()
		dialogAppearance.titleFont            = UIFont(name: "AvenirNextCondensed-Bold", size: 25)!
		dialogAppearance.titleColor           = UIColor(white: 0.4, alpha: 1)
		dialogAppearance.titleTextAlignment   = .center
		dialogAppearance.messageFont          = UIFont(name: "AvenirNextCondensed-DemiBold", size: 18)!
		dialogAppearance.messageColor         = UIColor(white: 0.6, alpha: 1)
		dialogAppearance.messageTextAlignment = .center
	}
	
	private func customiseDialogOverlayAppearance() {
		let overlayAppearance = PopupDialogOverlayView.appearance()
		overlayAppearance.color       = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
		overlayAppearance.blurRadius  = 30
		overlayAppearance.blurEnabled = true
		overlayAppearance.liveBlur    = false
	}
	
	private func customiseDialogButtons() {
		// Default buttons
		let defaultBtnAppearance = DefaultButton.appearance()
		defaultBtnAppearance.titleFont      = UIFont(name: "AvenirNextCondensed-DemiBold", size: 20)
		
		// Cancel Button
		let cancelBtnAppearance = CancelButton.appearance()
		cancelBtnAppearance.titleFont      = UIFont(name: "AvenirNextCondensed-DemiBold", size: 20)
	}
	
	
	// - MARK: LDOverlayDelegate
	
	internal func saveLevel() {
		saveGame()
	}
	
	internal func renameLevel() {
		showRenameDialog()
	}
	
	internal func back() {
		showBackWarning()
	}

}
