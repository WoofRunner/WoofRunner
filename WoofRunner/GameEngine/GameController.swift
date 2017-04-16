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

class GameController: UIViewController, PlayerDelegate, GameplayOverlayDelegate,TileManagerDelegate {
    
    private var overlaySpriteScene: GameplayOverlayScene?
    private var gameUUID: String?
    private let gsm = GameStorageManager.shared
    
    private var player: Player?
    private var tileManager: TileManager?
    
    private var bgm: AVAudioPlayerManager?
    
    private let bgmFadeOutDuration: Float = 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uuid = gameUUID else {
            fatalError("Game UUID not defined")
        }
        
        gsm.getGame(uuid: uuid)
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
        setupBGM()
        playBGM()
    }
    
    // notified by player when player dies
    func playerDied() {
        tileManager?.stopMoving()
		overlaySpriteScene?.showLoseMenu()
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
    
    private func createPlayer() {
        let newPlayer = Player()
        World.spawnGameObject(newPlayer)
        World.registerGestureInput(newPlayer)
        newPlayer.delegate = self
        self.player = newPlayer
    }
    
    // MARK: Audio Functions
    private func setupBGM() {
        let audioManager = AVAudioPlayerManager(path: "art.scnassets/TheFatRat.mp3")
        audioManager.setLoop(-1)
        bgm = audioManager
    }
    
    private func playBGM() {
        guard let sound = bgm else {
            return
        }
        sound.playFromStart()
    }
    
    private func resumeBGM() {
        guard let sound = bgm else {
            return
        }
        sound.play()
    }
    
    private func startFadeOutBGM(duration: Float) {
        guard let sound = bgm else {
            return
        }
        sound.startFadeOut(duration: duration)
    }
    
    private func startFadeInBGM(duration: Float) {
        guard let sound = bgm else {
            return
        }
        sound.startFadeIn(duration: duration)
    }
    
    private func stopBGM() {
        guard let sound = bgm else {
            return
        }
        sound.stop()
    }
    
    // MARK: - GameplayOverlayDelegate
    
    internal func pauseGame() {
        startFadeOutBGM(duration: bgmFadeOutDuration)
        World.setPause(isPaused: true)
    }
    
    internal func resumeGame() {
        startFadeInBGM(duration: bgmFadeOutDuration)
        World.setPause(isPaused: false)
    }
    
    internal func exitGame() {
        self.dismiss(animated: true, completion: nil)
        stopBGM()
    }
    
    internal func retryGame() {
        restartGame()
        stopBGM()
        playBGM()
    }
}
