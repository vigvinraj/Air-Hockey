//
//  GameScene.swift
//  Air Hockey
//
//  Created by Vignesh Kumar Rajasekaran on 3/23/16.
//  Copyright (c) 2016 Vignesh Kumar Rajasekaran. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, MalletDelegate {
    
    var puck : SKShapeNode?
    var southMallet : Mallet?
    var northMallet : Mallet?
    let  playableRect: CGRect
    var northscore = 0
    var southscore = 0
    var nscore:SKLabelNode!
    var sscore:SKLabelNode!
    var leftEdge:SKSpriteNode!
    var rightEdge:SKSpriteNode!
    
    override init (size: CGSize ) {
        let  maxAspectRatio:CGFloat  = 16.0/9.0 // 1
        let  playableHeight = size.width /  maxAspectRatio // 2
        let  playableMargin = (size.height - playableHeight)/2.0 // 3
        playableRect  = CGRect (x: 0 , y: playableMargin, width: size.width , height: playableHeight) // 4
        
        super.init(size: size) // 5
        
    }
    
    required init (coder aDecoder: NSCoder ) {
        fatalError ("init(coder:) has not been implemented" ) // 6
    }

    
    override func didMoveToView(view: SKView) {
        
      /*  let background = SKSpriteNode(imageNamed: "Background")
        background.position = CGPoint(x: playableRect.width/2, y: playableRect.height/2)
        background.zPosition = -1
        addChild(background)*/
        
        drawCenterLine()
        createMallets()
        resetPuck()
        createEdges()
        
        nscore = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        nscore.text = "\(northscore)"
        nscore.fontSize = 50
        nscore.fontColor=UIColor.redColor()
        nscore.position = CGPointMake(size.width - 700,size.height/2 - 50)
        sscore = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        sscore.text = "\(southscore)"
        sscore.fontSize = 50
        sscore.fontColor=UIColor.redColor()
        sscore.position = CGPointMake(size.width - 700,size.height/2 + 50)
        
        self.addChild(nscore)
        self.addChild(sscore)
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        if  nodeIsOffScreen(puck!){
            if puck?.position.y > frame.maxY
            {
                northscore = northscore + 1
                nscore.text = "\(northscore)"
                northMallet?.position = CGPoint(x: CGRectGetMidX(frame), y: size.height * 0.75)
                southMallet?.position = CGPoint(x: CGRectGetMidX(frame), y: size.height/4)
                Win()
                resetPuck()
            }
            else if puck?.position.y < frame.minY
            {
                southscore = southscore + 1
                sscore.text = "\(southscore)"
                southMallet?.position = CGPoint(x: CGRectGetMidX(frame), y: size.height/4)
                northMallet?.position = CGPoint(x: CGRectGetMidX(frame), y: size.height * 0.75)
                Win()
                resetPuck()

            }
            
        }
        if puck?.position.y > frame.midY
        {
            computerAI()
    
        }
        
    /*    if CGRectIntersectsRect(leftEdge.frame, (puck?.frame)!){
              puck?.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 20))
        }*/
        
        if CGRectIntersectsRect((northMallet?.frame)!, (puck?.frame)!) {
            puck?.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 0))
            
        }

    }
    
    func Win()
    {
        if northscore == 7 {
            let winScene = Player1Win(size: self.size)
            winScene.scaleMode = scaleMode
            // 2
            let doorway = SKTransition.doorwayWithDuration(2.0)
            // 3
            view!.presentScene(winScene, transition: doorway)
        }
        
        else if southscore == 7 {
            let winScene = Player2Win(size: self.size)
            winScene.scaleMode = scaleMode
            // 2
            let doorway = SKTransition.doorwayWithDuration(2.0)
            // 3
            view!.presentScene(winScene, transition: doorway)
        }
    
    }
    
    
    
   func computerAI()
    {
        var targetPosition = puck?.position
        var nodePosition = northMallet?.position
        let actionDuration = 0.1
        var ox = (targetPosition?.x)! - (nodePosition?.x)!
        var oy = (targetPosition?.y)! - (nodePosition?.y)!
        let offset = CGPoint(x: ox , y: oy)
        let direction = offset.normalized()
        let amountToMovePerSec = direction * 150.0
        let amountToMove = amountToMovePerSec * CGFloat(actionDuration)
        let moveAction = SKAction.moveByX(amountToMove.x, y: amountToMove.y, duration: actionDuration)
        northMallet!.runAction(moveAction)
        targetPosition = northMallet?.position
       }
    
    
    
    
    
    func force(force: CGVector, fromMallet mallet: Mallet) {
        if CGRectIntersectsRect(mallet.frame, puck!.frame){
            puck!.physicsBody!.applyImpulse(force)
        }

        
        
     /*   if CGRectIntersectsRect(leftEdge.frame, (puck?.frame)!){
            puck!.physicsBody!.applyImpulse(force)
        }*/
        
        if CGRectIntersectsRect(rightEdge.frame, puck!.frame){
            puck!.physicsBody!.applyImpulse(force)
        }

    }
    
    func drawCenterLine(){
    
        let centerLine = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(size.width, 10))
        centerLine.position = CGPointMake(size.width/2, size.height/2)
        centerLine.colorBlendFactor = 0.5;
        addChild(centerLine)
    }
    
    func malletAtPosition(position: CGPoint, withBoundary boundary:CGRect) -> Mallet{
        
        let mallet = Mallet(activeArea: boundary)
        mallet.position = position
        mallet.delegate = self
        addChild(mallet)
        return mallet;
    }
    
    func createMallets(){
        let southMalletArea = CGRectMake(0, 0, size.width, size.height/2)
        let southMalletStartPoint = CGPointMake(CGRectGetMidX(frame), size.height/4)
        
        let northMalletArea = CGRectMake(0, size.height/2, size.width, size.height)
        let northMalletStartPoint = CGPointMake(CGRectGetMidX(frame), size.height * 0.75)
        
        southMallet = malletAtPosition(southMalletStartPoint, withBoundary: southMalletArea)
        northMallet = malletAtPosition(northMalletStartPoint, withBoundary: northMalletArea)
    }
    
    func resetPuck(){
        
        if  puck == nil{
            
            //create puck object
            puck = SKShapeNode()
            
            //draw puck
            let radius : CGFloat = 30.0
            let puckPath = CGPathCreateMutable()
            let π = CGFloat(M_PI)
            CGPathAddArc(puckPath, nil, 0, 0, radius, 0, 2 * π, true)
            puck!.path = puckPath
            puck!.lineWidth = 0
            puck!.fillColor = UIColor.blueColor()
            
            //set puck physics properties
            puck!.physicsBody = SKPhysicsBody(circleOfRadius: radius)
            
            //how heavy it is
            puck!.physicsBody!.mass = 0.02
            puck!.physicsBody!.affectedByGravity = false
            
            //how much momentum is maintained after it hits somthing
            puck!.physicsBody!.restitution = 0.85
            
            //how much friction affects it
            puck!.physicsBody!.linearDamping = 0.4
        }
        
        //set puck position at centre of screen
        puck!.position = CGPointMake(size.width/2, size.height/2)
        puck!.physicsBody!.velocity = CGVectorMake(0, 0)
        
        //if not alreay in scene, add to scene
        if puck!.parent == nil{
            addChild(puck!)
        }
    }
    
    func createEdges(){
        
        let bumperDepth = CGFloat(20.0)
        
        leftEdge = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(bumperDepth, size.height))
        leftEdge.position = CGPointMake(frame.minX+600, frame.height/2)
        
        //setup physics for this edge
        leftEdge.physicsBody = SKPhysicsBody(rectangleOfSize: leftEdge.size)
        leftEdge.physicsBody!.dynamic = false
        addChild(leftEdge)
        
        //copy the left edge and position it as the right edge
        rightEdge = leftEdge.copy() as! SKSpriteNode
        rightEdge.position = CGPointMake(frame.maxX - 600, frame.height/2)
        addChild(rightEdge)
        
        //calculate some values for the end bumpers (four needed to allow for goals)
        let endBumperWidth = (size.width / 2) - 150
        let endBumperSize = CGSizeMake(endBumperWidth, bumperDepth)
        let endBumperPhysics = SKPhysicsBody(rectangleOfSize: endBumperSize)
        endBumperPhysics.dynamic = false;
        
        //create a bottom edge
        let bottomLeftEdge = SKSpriteNode(color: UIColor.blueColor(), size: endBumperSize)
        bottomLeftEdge.position = CGPointMake(endBumperWidth/2, bumperDepth/2)
        bottomLeftEdge.physicsBody = endBumperPhysics
        addChild(bottomLeftEdge)
        
        //copy edge to other three locations
        let bottomRightEdge = bottomLeftEdge.copy() as! SKSpriteNode
        bottomRightEdge.position = CGPointMake(size.width - endBumperWidth/2, bumperDepth/2)
        addChild(bottomRightEdge)
        
        let topLeftEdge = bottomLeftEdge.copy() as! SKSpriteNode
        topLeftEdge.position = CGPointMake(endBumperWidth/2, size.height - bumperDepth/2)
        addChild(topLeftEdge)
        
        let topRightEdge = bottomRightEdge.copy() as! SKSpriteNode
        topRightEdge.position = CGPointMake(size.width - endBumperWidth/2, size.height - bumperDepth/2 )
        addChild(topRightEdge)  
    }
    func nodeIsOffScreen(node: SKShapeNode) -> Bool{
        return !CGRectContainsPoint(frame, node.position)
    }
    
    
    
    
}
