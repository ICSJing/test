//
//  GameScene.swift
//  test
//
//  Created by IMD 224 on 2023-03-31.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene,SKPhysicsContactDelegate {
    var sprite : SKSpriteNode!
    var opponentSprite: SKSpriteNode!
    let spriteCategory1 : UInt32 = 0b1
    let spriteCategory2 : UInt32 = 0b10
    var counter = 0
    var isOver = false
    
    var score: SKLabelNode!
    let minSpeed = 2
    let maxSpeed = 4
    override func didMove(to view: SKView) {
        
        sprite = SKSpriteNode(imageNamed: "PlayerSprite")
        sprite.position = CGPoint(x: size.width / 2, y: 50)
        sprite.size = CGSize(width: 50, height:50)
        addChild(sprite)
        
        opponentSprite = SKSpriteNode(imageNamed: "OpponentSprite")
        let randomX = GKRandomSource.sharedRandom().nextInt(upperBound: Int(size.width))
        let constantY = size.height - 100
        opponentSprite.position = CGPoint(x: randomX, y: Int(constantY))
        opponentSprite.size = CGSize(width: 50, height:50)
        addChild(opponentSprite)
        
        score = SKLabelNode()
        score.text = String(counter);
        score.horizontalAlignmentMode = .right
        score.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(score)
        
        moveOpponent()
        
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        opponentSprite.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        
        sprite.physicsBody?.categoryBitMask = spriteCategory1
        sprite.physicsBody?.contactTestBitMask = spriteCategory1
        sprite.physicsBody?.collisionBitMask = spriteCategory2
        opponentSprite.physicsBody?.categoryBitMask = spriteCategory1
        opponentSprite.physicsBody?.contactTestBitMask = spriteCategory1
        opponentSprite.physicsBody?.collisionBitMask = spriteCategory2
        self.physicsWorld.contactDelegate = self
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        
        counter += 1
        score.text = String(counter);
        let randomX = GKRandomSource.sharedRandom().nextInt(upperBound: Int(size.width))
        opponentSprite.removeAllActions()
        opponentSprite.run(SKAction.move(to: CGPoint(x: randomX, y: Int(size.height-100)), duration: 0), completion:{self.moveOpponent()})
        
        print(counter)
        print("Hit!")
        
    }
    func moveOpponent() {
        var speed = GKRandomSource.sharedRandom().nextInt(upperBound: maxSpeed)
        if speed < minSpeed {
            speed = minSpeed
        }
        let movement = SKAction.move(to: CGPoint(x: opponentSprite.position.x, y: 0), duration: Double(speed))
        
        opponentSprite.run(movement, completion: {
            if self.counter > 0{
                self.counter -= 1
                self.score.text = String(self.counter)
                self.removeAllActions()
                let randomX = GKRandomSource.sharedRandom().nextInt(upperBound: Int(self.size.width))
                self.opponentSprite.run(SKAction.move(to: CGPoint(x: randomX, y: Int(self.size.height-100)), duration: 0),completion:{self.moveOpponent()})
            
            }
            else {
                self.sprite.run(SKAction.move(to: CGPoint(x: self.size.width / 2, y: 50), duration: 1))
                self.score.text = "gameover"
                self.isOver = true
                }
        })
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        sprite.run(SKAction.move(to: CGPoint(x: pos.x, y: 50), duration: 1))
        
    }
    func touchMoved(toPoint pos : CGPoint) {
        //sprite.run(SKAction.move(to: CGPoint(x: pos.x, y: 50), duration: 1))
    }
    func touchUp(atPoint pos : CGPoint) {
        sprite.run(SKAction.move(to: pos, duration: 1))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isOver {
            for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       // for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       // for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
      //  for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    override func update(_ currentTime: TimeInterval) {
    }
    
}
