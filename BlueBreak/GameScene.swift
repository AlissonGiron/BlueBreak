//
//  GameScene.swift
//  BlueBreak
//
//  Created by Student on 7/18/16.
//  Copyright (c) 2016 Student. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var isFingerOnScreen = false
    var touchLocation: CGFloat = 0.0
    var paddle: SKSpriteNode!
    var paddleVelocity = 0.0
    
    let velocityMultiplicationFactor = 128.0
    let initialVelocity = 8.0
    
    var lastUpdateTime = 0.0
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        paddleVelocity = initialVelocity
        
        for child in self.children {
            if child.name == "paddle" {
                if let child = child as? SKSpriteNode {
                    self.paddle = child
                }
            }
        }
        
        // 1
        let cols = 7
        
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
        let touch = touches.first
        touchLocation = touch!.locationInNode(self).x
        isFingerOnScreen = true
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isFingerOnScreen = false
        touchLocation = 0.0
        paddleVelocity = initialVelocity
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        if (isFingerOnScreen) {
            paddleVelocity += velocityMultiplicationFactor * (currentTime - lastUpdateTime)
            MovePaddle(touchLocation)
        }
        lastUpdateTime = currentTime
    }
    
    func MovePaddle(touchLocation: CGFloat) {
        print(paddle.position.x, self.size.width - paddle.size.width / 2)
        
        if paddle.position.x <= self.size.width - paddle.size.width / 2 && paddle.position.x - paddle.size.width / 2 >= 0 {
            
            if touchLocation < self.size.width / 2 {
                if paddle.position.x - paddle.size.width / 2 - CGFloat(paddleVelocity) > 0 {
                    paddle.position.x -= CGFloat(paddleVelocity)
                }
                else {
                    paddle.position.x = paddle.size.width / 2 + 1
                }
            }
            else {
                if paddle.position.x + paddle.size.width / 2 + CGFloat(paddleVelocity) < self.size.width {
                    paddle.position.x += CGFloat(paddleVelocity)
                }
                else {
                    paddle.position.x = self.size.width - paddle.size.width / 2 - 1
                }
            }
        }
        /*else {
            //Checar se a raquete passou da borda da tela
            if paddle.position.x > self.size.width - paddle.size.width / 2 {
                paddle.position.x = self.size.width - paddle.size.width / 2
            }
            else if paddle.position.x - paddle.size.width / 2 < 0 {
                paddle.position.x = paddle.size.width / 2 + 1
            }
        }*/
    }
}
