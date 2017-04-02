//
//  GameController.swift
//  test
//
//  Created by limte on 15/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//

import UIKit
import SceneKit

class GameController: UIViewController {

    private let gsm = GameStorageManager.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        World.setUpWorld(self.view)

        let platformManager = TileManager()
        World.spawnGameObject(platformManager)
        
        let player = Player()
        World.spawnGameObject(player)
        World.registerGestureInput(player)
        
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
        return TileManager(obstacleData: [], platformData: [])
    }

}
