//
//  GameController.swift
//  test
//
//  Created by limte on 15/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//

import UIKit
import SceneKit

class GameController: UIViewController, PlayerDelegate {

    private let gsm = GameStorageManager.getInstance()
    
    var player: Player?
    var tileManager: TileManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        World.setUpWorld(self.view)

        let newPlayer = Player()
        World.spawnGameObject(newPlayer)
        World.registerGestureInput(newPlayer)
        newPlayer.delegate = self
        self.player = newPlayer
        
        let tileManager = TileManager()
        World.spawnGameObject(tileManager)
        self.tileManager = tileManager
        
        let camera = Camera()
        World.spawnGameObject(camera)
        //World.spawnGameObject(TestCube(SCNVector3(0, 0, 0)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var shouldAutorotate: Bool {
        return true
    }

    /// Returns a tile manager for a game loaded from CoreData.
    /// - Parameters:
    ///     - uuid: unique ID string of the game to identify which game to laod
    /// - Returns: TileManager that is created using the data from loaded game
    private func getTileManagerForGame(uuid: String) -> TileManager {
        let game = gsm.getGame(uuid: uuid)

        let obstacles = game!.getObstacles()
        let platforms = game!.getPlatforms()

        return TileManager(obstacleData: obstacles, platformData: platforms)
    }

    func playerDied() {
        tileManager?.restartLevel()
        player?.restart()
    }
    
    func createNewPlayer() {
    
    }
}
