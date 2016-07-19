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
    
    var lastUpdateTime = 0.0
    
    override func didMoveToView(view: SKView) {
        for child in self.children {
            if child.name == "paddle" {
                if let child = child as? SKSpriteNode {
                    self.paddle = child
                }
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        let touch = touches.first
        touchLocation = touch!.locationInNode(self).x
        isFingerOnScreen = true
        
        
        /*for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }*/
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isFingerOnScreen = false
        touchLocation = 0.0
        paddleVelocity = 0.0
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if (isFingerOnScreen) {
            paddleVelocity += 2 * (currentTime - lastUpdateTime)
            MovePaddle(touchLocation)
        }
        lastUpdateTime = currentTime
    }
    
    func MovePaddle(touchLocation: CGFloat) {
        print(paddle.position.x, self.size.width - paddle.size.width / 2)
        
        if paddle.position.x <= self.size.width - paddle.size.width / 2 && paddle.position.x - paddle.size.width / 2 >= 0 {
            
            if touchLocation < self.size.width / 2 {
                paddle.position.x -= CGFloat(paddleVelocity)
            }
            else {
                paddle.position.x += CGFloat(paddleVelocity)
            }
        }
        else {
            //Checar se a raquete passou da borda da tela
            if paddle.position.x > self.size.width - paddle.size.width / 2 {
                paddle.position.x = self.size.width - paddle.size.width / 2
            }
            else if paddle.position.x - paddle.size.width / 2 < 0 {
                paddle.position.x = paddle.size.width / 2 + 1
            }
        }
    }
}
