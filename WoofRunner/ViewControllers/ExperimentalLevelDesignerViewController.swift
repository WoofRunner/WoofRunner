//
//  ExperimentalLevelDesignerViewController.swift
//  WoofRunner
//
//  Created by See Loo Jane on 16/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import SceneKit

class ExperimentalLevelDesignerViewController: UIViewController {

	var mainSceneView: SCNView!
	var spriteScene: LevelDesignerOverlayScene!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Create and attach main Scenekit Scene
		self.mainSceneView = SCNView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
		self.mainSceneView.scene = ExperimentalMainScene()
		self.view.addSubview(self.mainSceneView)

		
		// Create and attach Sprite Kit Overlay scene
		self.spriteScene = LevelDesignerOverlayScene(size: self.view.bounds.size)
		self.mainSceneView.overlaySKScene = self.spriteScene
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
