//
//  GameScene.swift
//  ApplePicking
//
//  Created by Tanmay Bakshi on 2016-03-18.
//  Copyright (c) 2016 Tanmay Bakshi. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    
    var node: SKSpriteNode!
    var node_right: SKSpriteNode!
    var node_right_b: SKSpriteNode!
    var node_left: SKSpriteNode!
    var node_left_b: SKSpriteNode!
    
    var apples: [Apple]!
    
    var spawnTimer = NSTimer()
    
    var playerScore = 0
    
    let scoreLabel = SKLabelNode(fontNamed: "Arial")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.scene?.backgroundColor = UIColor.whiteColor()
        
        scoreLabel.fontSize = 100
        scoreLabel.fontColor = UIColor.blackColor()
        scoreLabel.position = CGPointMake(self.frame.midX, self.frame.midY)
        self.addChild(scoreLabel)
        
        spawnTimer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(spawnApple), userInfo: nil, repeats: true)
        
        apples = []
        
        node = SKSpriteNode(imageNamed: "vline")
        node.size = CGSizeMake(5, 300)
        node.position = CGPointMake(self.frame.midX, self.frame.maxY - node.frame.height / 2)
        self.addChild(node)
        
        node_right = SKSpriteNode(imageNamed: "vline")
        node_right.size = CGSizeMake(5, 300)
        node_right.position = CGPointMake(self.frame.midX + 200, self.frame.maxY - node.frame.height / 2)
        self.addChild(node_right)
        
        node_left = SKSpriteNode(imageNamed: "vline")
        node_left.size = CGSizeMake(5, 300)
        node_left.position = CGPointMake(self.frame.midX - 200, self.frame.maxY - node.frame.height / 2)
        self.addChild(node_left)
        
        node_right_b = SKSpriteNode(imageNamed: "vline")
        node_right_b.size = CGSizeMake(5, 300)
        node_right_b.position = CGPointMake(self.frame.midX + 400, self.frame.maxY - node.frame.height / 2)
        self.addChild(node_right_b)
        
        node_left_b = SKSpriteNode(imageNamed: "vline")
        node_left_b.size = CGSizeMake(5, 300)
        node_left_b.position = CGPointMake(self.frame.midX - 400, self.frame.maxY - node.frame.height / 2)
        self.addChild(node_left_b)
        
        player = SKSpriteNode(imageNamed: "player")
        player.size = CGSizeMake(50, 50)
        player.position = CGPointMake(self.frame.midX, 125)
        self.addChild(player)
    }
    
    func randomNumberFrom(from: Range<Int>) -> Int {
        return from.startIndex + Int(arc4random_uniform(UInt32(from.endIndex - from.startIndex)))
    }
    
    func spawnApple() {
        var randPos = CGPoint()
        let pipe = randomNumberFrom(1...5)
        if pipe == 1 {
            randPos = node.position
        } else if pipe == 2 {
            randPos = node_right.position
        } else if pipe == 3 {
            randPos = node_left.position
        } else if pipe == 4 {
            randPos = node_right_b.position
        } else if pipe == 5 {
            randPos = node_left_b.position
        }
        let typeApple = randomNumberFrom(1...6)
        if typeApple == 1 {
            let typeApple2 = randomNumberFrom(1...3)
            if typeApple2 == 1 {
                let appleNode = Apple(imageNamed: "goodapple")
                appleNode.position = randPos
                appleNode.size = CGSizeMake(50, 50)
                appleNode.type = 1
                self.addChild(appleNode)
                apples.append(appleNode)
            } else {
                let appleNode = Apple(imageNamed: "badapple")
                appleNode.position = randPos
                appleNode.size = CGSizeMake(50, 50)
                appleNode.type = -1
                self.addChild(appleNode)
                apples.append(appleNode)
            }
        } else {
            let appleNode = Apple(imageNamed: "apple")
            appleNode.position = randPos
            appleNode.size = CGSizeMake(50, 50)
            appleNode.type = 0
            self.addChild(appleNode)
            apples.append(appleNode)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        let touch = touches.first!
        player.position.x = touch.locationInNode(self).x
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        player.position.x = touch.locationInNode(self).x
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        var newApples = [Apple]()
        for i in apples {
            i.position.y -= 2 + (i.type == -1 ? 2 : 0)
            var shouldContinue = true
            if i.position.y <= self.frame.minY {
                shouldContinue = false
            }
            if i.frame.intersects(player.frame) {
                shouldContinue = false
                if i.type == -1 {
                    playerScore -= 3
                } else if i.type == 0 {
                    playerScore += 1
                } else if i.type == 1 {
                    playerScore += 3
                }
            }
            if shouldContinue {
                newApples.append(i)
            } else {
                i.removeFromParent()
            }
        }
        apples = newApples
        scoreLabel.text = "\(playerScore)"
    }
    
}

class Apple: SKSpriteNode {
    
    var type = 0
    
}