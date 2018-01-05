//
//  Leaderboard.swift
//  SKLab1
//
//  Created by Lisa Steele on 12/13/17.
//  Copyright © 2017 lisahsteele. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import Firebase
import FirebaseDatabase


class Leaderboard: SKScene, UITextFieldDelegate {
    
    let background = SKSpriteNode(imageNamed: "GameOverBackground")
    let usernameSceneImage = SKSpriteNode(imageNamed: "UsernameSceneImage")
    let leaderboardGreeting = SKSpriteNode(imageNamed: "LeaderboardComingSoon")
    let backToGameButton = SKSpriteNode(imageNamed: "BackToGameButton")
    var textField: UITextField!
    var username = String()
    
    var userName = String()
    var highScore = Int()
    var listOfPlayers = [[String : Any]]()
    var player = [(String) : (Any)]()
    
    
    var playableRect: CGRect
    var deviceWidth = UIScreen.main.bounds.width
    var deviceHeight = UIScreen.main.bounds.height
    
    
    override func sceneDidLoad() {
        background.position = CGPoint(x: size.width / 2 , y: size.height / 2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        addChild(background)
        
        usernameSceneImage.position = CGPoint(x: size.width/2, y: (deviceHeight - deviceHeight) + usernameSceneImage.size.height)
        addChild(usernameSceneImage)
        
        //leaderboardGreeting.position = CGPoint(x: size.width / 2, y: (size.height / 2 + backToGameButton.size.height) + leaderboardGreeting.size.height)
        //addChild(leaderboardGreeting)
        
        backToGameButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backToGameButton)
        
        self.loadHighScores()
    }
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = deviceHeight / deviceWidth
        let playableWidth = size.height / maxAspectRatio
        let playableMargin = (size.width - playableWidth) / 2.0
        playableRect = CGRect(x: playableMargin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if backToGameButton.contains(location) {
                let scene = GameScene(size: size)
                self.view?.presentScene(scene)
            }
        }
    }
    
    
    override func didMove(to view: SKView) {
        guard let view = self.view else {return}
        let originX = (size.width / 2) / 5
        textField = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 125, width: size.width / 1.25, height: 50))
        customize(textField: textField, placeholder: "Player : High Score")
        view.addSubview(textField)
        textField.addTarget(self, action: #selector(UserRegistration.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }
 
    func customize(textField: UITextField, placeholder: String, isSecureTextEntry: Bool = false) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        textField.leftView = paddingView
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.leftViewMode = UITextFieldViewMode.always
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName : UIColor.gray])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 4.0
        textField.textColor = .darkGray
        textField.isSecureTextEntry = isSecureTextEntry
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        if textField == self.textField {
            self.username = textField.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func loadHighScores() {
        let ref: DatabaseReference!
        ref = Database.database().reference().child("Users")
        ref.queryOrderedByValue().observe(.value, with: { (snapshot) in
            let entries = snapshot.children
            for entry in entries {
                if let pair = entry as? DataSnapshot {
                    if let score = pair.value {
                        let name = pair.key
                        self.userName = name
                        self.highScore = score as! Int
                    }
                }
                self.player["playerName"] = self.userName as String
                self.player["highScore"] = self.highScore as Int
                self.listOfPlayers.append(self.player)
                let result = listOfPlayers.sorted { (first: (key: [String], value: [Int]), second: (key: [String], value: [Int])) -> Bool in
                    return first.value.first! < second.value.first!
                }
            }
        })
    }
    
    /*
    func loadHighScores() {
        let ref: DatabaseReference!
        ref = Database.database().reference().child("Users")
        ref.observe(.value, with: { (snapshot) in
            let players = snapshot.children
            for item in players {
                if let pair = item as? DataSnapshot {
                    if let score = pair.value {
                        let name = pair.key
                        self.highScore = score as! Int
                        self.userName = name
                    }
                }
                self.player["playerName"] = self.userName as String
                self.player["highScore"] = self.highScore as Int
                self.listOfPlayers.append(self.player)
            }
            let sortedPlayers = self.listOfPlayers.sorted {$0["highScore"] as! Int > $1["highScore"] as! Int}
            print (sortedPlayers)
            //let player1 = sortedPlayers.indices
            //print (player1)
        })
    }
    */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

