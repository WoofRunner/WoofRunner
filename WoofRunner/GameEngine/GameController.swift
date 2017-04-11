//
//  GameController.swift
//  test
//
//  Created by limte on 15/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit

class GameController: UIViewController, PlayerDelegate, TileManagerDelegate, GameplayOverlayDelegate {
    
    private var overlaySpriteScene: GameplayOverlayScene?
    private var gameUUID: String?
    private let gsm = GameStorageManager.getInstance()
    
    private var player: Player?
    private var tileManager: TileManager?
    private var bgmSoundNode = GameObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uuid = gameUUID else {
            fatalError("Game UUID not defined")
        }
        
        GameStorageManager.getInstance().getGame(uuid: uuid)
            .onSuccess { game in
                self.setup(game: game)
            }
            .onFailure { error in
                print("\(error.localizedDescription)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    public func setGameUUID(_ uuid: String) {
        self.gameUUID = uuid
    }
    
    private func setup(game: StoredGame) {
        guard let sceneView = self.view as? SCNView else {
            print("Error: Unable to setup game world as SCNView cannt be found!")
            return
        }
        
        // TODO: Swap self.view with sceneView
        World.setUpWorld(sceneView)
        
        // Setup Gameplay Overlay UI
        overlaySpriteScene = GameplayOverlayScene(size: sceneView.frame.size)
        sceneView.overlaySKScene = overlaySpriteScene
        overlaySpriteScene?.setDelegate(self)
        
        createPlayer()
        
        if let tileManager = TileManager(obstacleModels: game.getObstacles(), platformModels: game.getPlatforms()) {
            World.spawnGameObject(tileManager)
            tileManager.delegate = self
            self.tileManager = tileManager
        }
        
        let camera = Camera()
        World.spawnGameObject(camera)
        
        // Play background music
        playBGM()
    }
    
    // notified by player when player dies
    func playerDied() {
        tileManager?.stopMoving()
		overlaySpriteScene?.showLoseMenu()
        
        sceneShake(shakeCount: 5, intensity: CGVector(dx: 1, dy: 1), shakeDuration: 1)
    }
    
    func restartGame() {
        resumeGame()
        tileManager?.restartLevel()
        player?.restart()
    }
    
    func onTileManagerEnded() {
		overlaySpriteScene?.showWinMenu()
    }
    
    func getCompletedPercentage() -> Float {
        return tileManager?.percentageCompleted ?? 0.0
    }
    
    func onCompletionUpdated(_ percentageCompleted: Float) {
        overlaySpriteScene?.updateScore(percentageCompleted * Float(100))
    }
    
    private func createPlayer() {
        let newPlayer = Player()
        World.spawnGameObject(newPlayer)
        World.registerGestureInput(newPlayer)
        newPlayer.delegate = self
        self.player = newPlayer
    }
    
    // Play background music
    private func playBGM() {
        let bgmSound = SCNAudioSource(name: "TheFatRat.mp3", volume: 1.0, loops: true)
        bgmSoundNode = GameObject()
        World.spawnGameObject(bgmSoundNode)
        bgmSoundNode.runAction(SCNAction.playAudio(bgmSound, waitForCompletion: false))
    }
    
    private func stopBGM() {
        bgmSoundNode.destroy()
    }
    
    // MARK: - GameplayOverlayDelegate
    
    internal func pauseGame() {
        World.setPause(isPaused: true)
    }
    
    internal func resumeGame() {
        World.setPause(isPaused: false)
    }
    
    internal func exitGame() {
        stopBGM()
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func retryGame() {
        restartGame()
    }
    
    func sceneShake(shakeCount: Int, intensity: CGVector, shakeDuration: Double) {
        let sceneView = self.view! as UIView
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = shakeDuration / Double(shakeCount)
        shakeAnimation.repeatCount = Float(shakeCount)
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: sceneView.center.x - intensity.dx, y: sceneView.center.y - intensity.dy))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: sceneView.center.x + intensity.dx, y: sceneView.center.y + intensity.dy))
        sceneView.layer.add(shakeAnimation, forKey: "position")
    }
}
