//
//  SampleGameController.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 9/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import SceneKit

class SampleGameController: UIViewController {
    
    private var sceneView = SCNView()
    private var scnScene = SCNScene()
    private var gameplayOverlay: GameplayOverlayScene?
    let LEVEL_PATH = "art.scnassets/level.scn"

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        if let newScnScene = SCNScene(named: LEVEL_PATH) {
            scnScene = newScnScene
        }
        sceneView.scene = scnScene
        
        gameplayOverlay = GameplayOverlayScene(size: self.view.frame.size)
        sceneView.overlaySKScene = gameplayOverlay
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
