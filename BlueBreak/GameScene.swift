//
//  GameScene.swift
//  BlueBreak
//
//  Created by Student on 7/18/16.
//  Copyright (c) 2016 Student. All rights reserved.
//

import SpriteKit

let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let BlockCategoryName = "block"
let GameMessageName = "gameMessage"

let BallCategory   : UInt32 = 0x1 << 0
let TopCategory : UInt32 = 0x1 << 1
let BlockCategory  : UInt32 = 0x1 << 2
let PaddleCategory : UInt32 = 0x1 << 3
let BorderCategory : UInt32 = 0x1 << 4


class GameScene: SKScene, SKPhysicsContactDelegate  {
    
    var isFingerOnScreen = false
    var touchLocation: CGFloat = 0.0
    var paddle: SKSpriteNode!
    var paddleVelocity = 0.0
    
    let velocityMultiplicationFactor = 128.0
    let initialVelocity = 8.0
    
    var lastUpdateTime = 0.0
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        //Barreira em volta da tela, para a bola não escapar
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
        
        let paddle = childNodeWithName(PaddleCategoryName) as! SKSpriteNode
        let ball = childNodeWithName(BallCategoryName) as! SKSpriteNode
        ball.physicsBody!.applyImpulse(CGVector(dx: 2.0, dy: -2.0))
        
        let topRect = CGRect(x: frame.origin.x, y: frame.size.height - 1, width: frame.size.width, height: 1)
        let top = SKNode()
        top.physicsBody = SKPhysicsBody(edgeLoopFromRect: topRect)
        addChild(top)
        
        top.physicsBody!.categoryBitMask = TopCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        borderBody.categoryBitMask = BorderCategory
        
        
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
                        block.zRotation = CGFloat(M_PI)
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
            
                block.name = BlockCategoryName
                block.physicsBody!.categoryBitMask = BlockCategory
                block.zPosition = 5
                addChild(block)
            }
        }
        
        ball.physicsBody!.contactTestBitMask = TopCategory | BlockCategory
        
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        // 2
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        /* 3
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
            print("Hit bottom. First contact has been made.")
        }*/
    }
    
    func breakBlock(node: SKNode) {
        node.removeFromParent()
    }
    
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
        //Se o usuário tocar na parte esquerda da tela, mover a raquete para a esquerda
        if touchLocation < self.size.width / 2 {
            //Checar se a raquete vai sair da tela
            if paddle.position.x - paddle.size.width / 2 - CGFloat(paddleVelocity) + 1 > 0 {
                paddle.position.x -= CGFloat(paddleVelocity)
            }
            else {
                paddle.position.x = paddle.size.width / 2 + 1
            }
        }
        //Caso contrário, mover para a direita
        else {
            //Checar se a raquete vai sair da tela
            if paddle.position.x + paddle.size.width / 2 + CGFloat(paddleVelocity) - 1 < self.size.width {
                paddle.position.x += CGFloat(paddleVelocity)
            }
            else {
                paddle.position.x = self.size.width - paddle.size.width / 2 - 1
            }
        }
    }
}
