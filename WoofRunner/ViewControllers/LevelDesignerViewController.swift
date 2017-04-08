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
    static var cameraHeight: Float = 6
    static var cameraAngle: Float = -0.77
    static var cameraOffset: Float = 3.5
    static var paddingTiles: Float = 2.0
    static var panningSensitivity: Float = 15 // Default = 15
	
    // Level Designer Settings
    static var autoExtendLevel = true
    static var extensionLength = 10
    
	let disposeBag = DisposeBag();
    
    var LDScene = LevelDesignerScene()
    var sceneView = SCNView()
    var currentLevel = LevelGrid()
    var currentSelectedBrush: TileType = .floorLight // Observing overlayScene
	var currentLevelName = "Custom Level 1" // Default Name
    var spriteScene: LevelDesignerOverlayScene?
    var longPress = false

    private let gsm = GameStorageManager.getInstance()
	var loadedLevel: StoredGame?

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
		
		let sampleLevel = LevelGrid(length: 50)
		currentLevel = sampleLevel
		
		// Load a level if initialised from previous ViewController
		if let _ = loadedLevel {
			currentLevel.load(from: loadedLevel!)
		}
        
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
        // Observe currentTileSelection
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
    
    // MARK: Handle Gestures
    func handlePan(_ sender: UIPanGestureRecognizer) {
        if (!canEdit() || longPress) {
            return
        }
		
        let camera = LDScene.cameraNode
        let translation = sender.translation(in: sceneView)

        // Normal method
        let diffR = Float(translation.y / self.view.frame.height)
            * LevelDesignerViewController.panningSensitivity

        switch sender.state {
            case .began:
                LDScene.cameraLocation = camera.position
                break;
            case .changed:
                let newPos = SCNVector3(LDScene.cameraLocation.x,
                                        LDScene.cameraLocation.y,
                                        LDScene.cameraLocation.z - diffR)
                if (newPos.z <= LevelDesignerViewController.cameraOffset) {
                    camera.position = newPos
                }
                // Add padding to near plane clipping
                let padding = GameSettings.TILE_WIDTH * LevelDesignerViewController.paddingTiles
                let startRow = Int(-camera.position.z +
                                    (LevelDesignerViewController.cameraOffset - padding) / GameSettings.TILE_WIDTH)
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
            currentLevel.toggleGrid(x: toggleNode.position.x, z: toggleNode.position.z, currentSelectedBrush)
        }
    }
    
    // Bulk Toggle
    func handleLongPress(_ sender: UIGestureRecognizer) {
        switch(sender.state) {
        case .began:
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
            currentLevel.toggleGrid(x: startNode.position.x, z: startNode.position.z, currentSelectedBrush)
            currentLevel.beginSelection((x: startNode.position.x, z: startNode.position.z))
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
            currentLevel.updateSelection((x: currentNode.position.x, z: currentNode.position.z))
            break
        default:
            longPress = false
            currentLevel.endSelection()
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
            if startRow + LevelGrid.chunkLength > currentLevel.length {
                
                // Extend the level in bulk of {extensionLength}, reduce overhead
                let extend = startRow + LevelGrid.chunkLength - currentLevel.length
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
        var togglingNode: SCNNode? = nil
        for result in hitResults {
            let resultantNode = result.node
            // Skip if node is transparent
            guard resultantNode.geometry?.firstMaterial?.transparency != 0 else {
                continue
            }
            
            // Find GridNode
            if resultantNode.name != GridViewModel.gridNodeName {
                togglingNode = findParentGridNode(resultantNode)
            }
            
            guard togglingNode != nil else {
                continue
            }
            return togglingNode
        }
        return nil
    }
    
    private func findParentGridNode(_ node: SCNNode) -> SCNNode? {
        guard let parentNode = node.parent else {
            return nil
        }
        guard parentNode.name == GridViewModel.gridNodeName else {
            return findParentGridNode(parentNode)
        }
        
        return parentNode
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
		let renameVC = RenameDialogViewController(nibName: "RenameDialogViewController", bundle: nil)
		
		// Create the dialog
		let popup = PopupDialog(viewController: renameVC, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false)
		
		// Configure and add buttons
		let cancelBtn = CancelButton(title: "CANCEL", height: 60) {
			popup.dismiss()
		}
		
		let okBtn = DefaultButton(title: "OK", height: 60) {
			
			// Validate Input Level Name
			if self.validateLevelName(renameVC.getLevelName()) {
				
				// Hide warning text (in case it was previously visible)
				renameVC.hideWarningText()
				
				// Update Level Name
				self.currentLevelName = renameVC.getLevelName()
				self.spriteScene?.updateDisplayedLevelName(self.currentLevelName)
				
				// Dismiss popup
				popup.dismiss()
			} else {
				renameVC.showWarningText()
			}
		}
		okBtn.dismissOnTap = false
		
	
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
		dialogAppearance.titleFont = UIFont(name: "AvenirNextCondensed-Bold", size: 25)!
		dialogAppearance.titleColor = UIColor(white: 0.4, alpha: 1)
		dialogAppearance.titleTextAlignment = .center
		dialogAppearance.messageFont = UIFont(name: "AvenirNextCondensed-DemiBold", size: 18)!
		dialogAppearance.messageColor = UIColor(white: 0.6, alpha: 1)
		dialogAppearance.messageTextAlignment = .center
	}
	
	private func customiseDialogOverlayAppearance() {
		let overlayAppearance = PopupDialogOverlayView.appearance()
		overlayAppearance.color = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
		overlayAppearance.blurRadius = 30
		overlayAppearance.blurEnabled = true
		overlayAppearance.liveBlur = false
	}
	
	private func customiseDialogButtons() {
		// Default buttons
		let defaultBtnAppearance = DefaultButton.appearance()
		defaultBtnAppearance.titleFont = UIFont(name: "AvenirNextCondensed-DemiBold", size: 20)
		
		// Cancel Button
		let cancelBtnAppearance = CancelButton.appearance()
		cancelBtnAppearance.titleFont = UIFont(name: "AvenirNextCondensed-DemiBold", size: 20)
	}
	
	private func validateLevelName(_ name: String) -> Bool {
		return !(name.characters.count < 5 || name.characters.count > 40)
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
