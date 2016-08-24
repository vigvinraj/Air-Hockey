//
//  StartScene.swift
//  Air Hockey
//
//  Created by Vignesh Kumar Rajasekaran on 5/1/16.
//  Copyright © 2016 Vignesh Kumar Rajasekaran. All rights reserved.
//

import Foundation
import SpriteKit

class StartScene: SKScene {
    
    var singlePlayer: SKLabelNode!
    var multiPlayer: SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        // Create a simple red rectangle that's 100x44
       // button = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 100, height: 44))
        singlePlayer = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        singlePlayer.text = "Single Player"
        singlePlayer.fontSize = 50
        singlePlayer.fontColor=UIColor.redColor()
       // button = SKLabelNode(text: "P l a y")
        // Put it in the center of the scene
        singlePlayer.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        multiPlayer = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        multiPlayer.text = "Multi Player"
        multiPlayer.fontSize = 50
        multiPlayer.fontColor=UIColor.redColor()
        // button = SKLabelNode(text: "P l a y")
        // Put it in the center of the scene
        multiPlayer.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-100)
        

        
        self.addChild(singlePlayer)
        self.addChild(multiPlayer)
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            // Check if the location of the touch is within the button's bounds
            if singlePlayer.containsPoint(location) {
                print("tapped!")
                
                let gameScene = GameScene(size: self.size)
                gameScene.scaleMode = scaleMode
                // 2
                let doorway = SKTransition.doorwayWithDuration(2.0)
                // 3
                view!.presentScene(gameScene, transition: doorway)

            }
           else if multiPlayer.containsPoint(location) {
                print("tapped!")
                
                let gameScene = MultiPlayer(size: self.size)
                gameScene.scaleMode = scaleMode
                // 2
                let doorway = SKTransition.doorwayWithDuration(2.0)
                // 3
                view!.presentScene(gameScene, transition: doorway)
                
            }

        }
        
        
        
    }
    
    
}

