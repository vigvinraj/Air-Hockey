//
//  Player2Win.swift
//  Air Hockey
//
//  Created by Vignesh Kumar Rajasekaran on 5/1/16.
//  Copyright © 2016 Vignesh Kumar Rajasekaran. All rights reserved.
//

import Foundation
import SpriteKit

class Player2Win: SKScene {
    var sscore:SKLabelNode!
    var playAgain:SKLabelNode!
    
    override  func didMoveToView(view: SKView) {
        sscore = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        sscore.text = "Player 2 Win"
        sscore.fontSize = 50
        sscore.fontColor=UIColor.redColor()
        sscore.position = CGPointMake(size.width/2,size.height/2)
        playAgain = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        playAgain.text = "Play Again"
        playAgain.fontSize = 50
        playAgain.fontColor=UIColor.redColor()
        playAgain.position = CGPointMake(size.width/2,size.height/2-100)
        self.addChild(sscore)
        self.addChild(playAgain)
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            // Check if the location of the touch is within the button's bounds
            if playAgain.containsPoint(location) {
                print("tapped!")
                
                let gameScene = StartScene(size: self.size)
                gameScene.scaleMode = scaleMode
                // 2
                let doorway = SKTransition.doorwayWithDuration(2.0)
                // 3
                view!.presentScene(gameScene, transition: doorway)
                
            }
        }
    }

    
}