//
//  GameController.swift
//  test
//
//  Created by limte on 15/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//

import UIKit
import SceneKit

class GameController: UIViewController, PlayerDelegate, TileManagerDelegate {

	private var gameUUID: String?
    private let gsm = GameStorageManager.getInstance()
    
    private var player: Player?
    private var tileManager: TileManager?
    
    var obstacleData: [[Int]] = [[0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 5],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 5],
                                 [4, 4, 0, 0, 0],
                                 [4, 4, 0, 0, 5],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 6],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 6],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 6],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 6],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 6],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 6],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 6],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 6],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 6],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 6],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 6],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0]]
    /*
    var obstacleData: [[Int]] = [[0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0]]
    */
    var platformData: [[Int]] = [[1, 1, 1, 1, 1],
                                 [1, 1, 1, 1, 1],
                                 [1, 1, 1, 1, 1],
                                 [7, 0, 0, 0, 0],
                                 [1, 1, 3, 1, 1],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 3, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 3, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 3, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 0, 0, 0],
                                 [0, 0, 3, 2, 2],
                                 [1, 0, 1, 2, 2],
                                 [2, 0, 2, 1, 2],
                                 [1, 0, 1, 2, 2],
                                 [2, 1, 2, 1, 2],
                                 [1, 2, 1, 2, 2],
                                 [2, 1, 2, 1, 2],
                                 [1, 2, 7, 2, 1],
                                 [2, 1, 7, 1, 2],
                                 [0, 0, 7, 0, 0],
                                 [0, 0, 7, 0, 0],
                                 [0, 0, 7, 0, 0],
                                 [0, 0, 7, 1, 2],
                                 [1, 0, 7, 2, 1],
                                 [2, 0, 2, 1, 2],
                                 [1, 1, 1, 2, 1]]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempSetup()

        /*
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
*/
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
        World.setUpWorld(self.view)

        let newPlayer = Player()
        World.spawnGameObject(newPlayer)
        World.registerGestureInput(newPlayer)
        newPlayer.delegate = self
        self.player = newPlayer

        if let tileManager = TileManager(obstacleData: game.getObstacles(), platformData: game.getPlatforms()) {
            World.spawnGameObject(tileManager)
            tileManager.delegate = self
            self.tileManager = tileManager
        }
        
        let camera = Camera()
        World.spawnGameObject(camera)
        //World.spawnGameObject(TestCube(SCNVector3(0, 0, 0)))
    }
    
    private func tempSetup() {
        World.setUpWorld(self.view)
        let newPlayer = Player()
        World.spawnGameObject(newPlayer)
        World.registerGestureInput(newPlayer)
        newPlayer.delegate = self
        self.player = newPlayer
        
        if let tileManager = TileManager(obstacleData: obstacleData, platformData: platformData) {
            World.spawnGameObject(tileManager)
            tileManager.delegate = self
            self.tileManager = tileManager
        }
        
        
        let camera = Camera()
        World.spawnGameObject(camera)
    }
    
    // notified by player when player dies
    func playerDied() {
        restartGame()
    }
    
    func restartGame() {
        tileManager?.restartLevel()
        player?.restart()
    }
    
    func onTileManagerEnded() {
        restartGame()
    }
}
