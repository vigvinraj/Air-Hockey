//
//  Mallet.swift
//  Air Hockey
//
//  Created by Vignesh Kumar Rajasekaran on 3/23/16.
//  Copyright © 2016 Vignesh Kumar Rajasekaran. All rights reserved.
//


import SpriteKit



class Mallet: SKShapeNode {
    
    //keep track of previous touch time (will use to calculate vector)
    var lastTouchTimeStamp: Double?
    
    //delegate will refer to class which will act on mallet force
    var delegate:MalletDelegate?
    
    //this will determine the allowable area for the mallet
    let activeArea:CGRect
    //define mallet size
    let radius:CGFloat = 40.0
    
    //when we instantiate the class we will set the active area
    init(activeArea: CGRect) {
        //set the active area variable this class with the variable passed in
        self.activeArea = activeArea
        
        //ensure we pass the init call to the base class
        super.init()
        
        //allow the mallet to handle touch events
        userInteractionEnabled = true
        
        //create a mutable path (later configured as a circle)
        let circularPath = CGPathCreateMutable()
        
        //define pi as CGFloat (type π using alt-p)
        let π = CGFloat(M_PI)
        
        //create the circle shape
        CGPathAddArc(circularPath, nil, 0, 0, radius, 0, π*2, true)
        
        //assign the path to this SKShapeNode's path property
        path = circularPath
        
        lineWidth = 0;
        
        fillColor = .redColor()
        //set physics properties (note physicsBody is an optional)
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody!.mass = 500;
        physicsBody!.affectedByGravity = false;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
               
        var relevantTouch:UITouch!
        
        //convert set to known type
        let touchSet = touches as! Set<UITouch>
        
        //get array of touches so we can loop through them
        let orderedTouches = Array(touchSet)
        
        for touch in orderedTouches{
            //if we've not yet found a relevant touch
            if relevantTouch == nil{
                //look for a touch that is in the activeArea (Avoid touches by opponent)
                if CGRectContainsPoint(activeArea, touch.locationInNode(parent!)){
                    relevantTouch = touch
                }
            }
        }
        
        if (relevantTouch != nil){
            
            //get touch position and relocate mallet
            let location = relevantTouch!.locationInNode(parent!)
            position = location
            
            //find old location and use Pythagoras to determine length between both points
            let oldLocation = relevantTouch!.previousLocationInNode(parent!)
            let xOffset = location.x - oldLocation.x
            let yOffset = location.y - oldLocation.y
            let vectorLength = sqrt(xOffset * xOffset + yOffset * yOffset)
            
            //get elapsed time and use to calculate speed
            if lastTouchTimeStamp != nil {
                let seconds = relevantTouch.timestamp - lastTouchTimeStamp!
                let velocity = 0.01 * Double(vectorLength) / seconds
                
                //to calculate the vector, the velcity needs to be converted to a CGFloat
                let velocityCGFloat = CGFloat(velocity)
                
                //calculate the impulse
                let directionVector = CGVectorMake(velocityCGFloat * xOffset / vectorLength, velocityCGFloat * yOffset / vectorLength)
                
                //pass the vector to the scene (so it can apply an impulse to the puck)
                delegate?.force(directionVector, fromMallet: self)
            }    
            //update latest touch time for next calculation
            lastTouchTimeStamp = relevantTouch.timestamp
            
        }
    }

}


protocol MalletDelegate {
    func force(force: CGVector, fromMallet mallet: Mallet)
}