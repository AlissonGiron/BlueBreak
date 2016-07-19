//
//  GameScene.swift
//  BlueBreak
//
//  Created by Student on 7/18/16.
//  Copyright (c) 2016 Student. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // 1
        let cols = 5
        
        let numberOfBlocks = 5
        let blockWidth = SKSpriteNode(imageNamed: "block").size.width
        let totalBlocksWidth = blockWidth * CGFloat(numberOfBlocks)
        // 2
        let xOffset = (CGRectGetWidth(frame) - totalBlocksWidth) / 6
        // 3
        
        for j in 1...cols {
            for i in 0..<numberOfBlocks {
                let block = SKSpriteNode(imageNamed: "block.png")
            

                block.position = CGPoint(x: xOffset + CGFloat(CGFloat(i) * 1.3 + 0.5) * blockWidth,
                                     y: CGRectGetHeight(frame) * 0.05 * CGFloat(j))
            
                block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)
                
            
                // Deixa os blocos curvados
                switch i {
                    case 0:
                        block.zRotation = 3.4
                    case 1:
                        block.position.y += 12
                        block.zRotation = -3
                    case 2:
                        block.position.y += 16
                    case 3:
                        block.position.y += 12
                        block.zRotation = 3
                    case 4:
                        block.zRotation = -3.4
                    default:
                        break
                }
                
                block.physicsBody!.allowsRotation = false
                block.physicsBody!.friction = 0.0
                block.physicsBody!.affectedByGravity = false
                block.physicsBody!.dynamic = false
            
                //block.name = BlockCategoryName
                //block.physicsBody!.categoryBitMask = BlockCategory
                block.zPosition = 5
                addChild(block)
            }
        }
        
        //ball.physicsBody!.contactTestBitMask = BottomCategory | BlockCategory
    }
    
    /* QUEBRAR BLOCO, FALTA A PARTE DE COLISAO
    func didBeginContact(contact: SKPhysicsContact) {
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BlockCategory {
            breakBlock(secondBody.node!)
            //TODO: check if the game has been won
        }
    }
    
    func breakBlock(node: SKNode) {
        let particles = SKEmitterNode(fileNamed: "BrokenPlatform")!
        particles.position = node.position
        particles.zPosition = 3
        addChild(particles)
        particles.runAction(SKAction.sequence([SKAction.waitForDuration(1.0), SKAction.removeFromParent()]))
        node.removeFromParent()
    }
    */
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
