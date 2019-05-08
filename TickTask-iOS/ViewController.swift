//
//  ViewController.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 4/23/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController
{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad()
    {
        if let scene = SCNScene(named: "./timer.scn")
        {
            sceneView.scene = scene
            
            if let light = scene.rootNode.childNode(withName: "Light", recursively: false)
            {
                // We don't have dark mode on iOS
                light.light?.intensity = 200
            }
            
            if let dial = scene.rootNode.childNode(withName: "Dial", recursively: false)
            {
                let color: UIColor = .green
                
                
//                switch state
//                {
//                case .inactive:
//                    color = NSColor.systemGreen
//                case .userDragging:
//                    color = NSColor.systemYellow
//                case .countdown:
//                    color = NSColor.systemRed
//                }
                
                dial.geometry?.firstMaterial?.diffuse.contents = color
                dial.geometry?.firstMaterial?.emission.contents = color
            }
        }
        
        super.viewDidLoad()
    }
    
    @IBAction func handlePan(gesture: UIPanGestureRecognizer)
    {   
        // Copied verbatum from the other view controller
        let location = gesture.location(in: sceneView)
        let origin = sceneView.center
        let angle = location.angleFromPoint(point: origin, snap: CGFloat(12))
        
        guard let scene = sceneView.scene else { return }
        
        guard let dial = scene.rootNode.childNode(withName: "Dial",
                                                  recursively: false) else { return}
        
        dial.runAction(SCNAction.rotateTo(x: 0, y: -angle, z: 0, duration: 0))
    }
}

