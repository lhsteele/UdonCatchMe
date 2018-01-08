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

struct PlayerEntries {
    var playerName: String
    var score: Int
    
    init(playerName: String, score: Int) {
        self.playerName = playerName
        self.score = score
    }
}

class Leaderboard: SKScene, UITextFieldDelegate {
    
    let background = SKSpriteNode(imageNamed: "GameOverBackground")
    let usernameSceneImage = SKSpriteNode(imageNamed: "UsernameSceneImage")
    let leaderboardGreeting = SKSpriteNode(imageNamed: "LeaderboardComingSoon")
    let backToGameButton = SKSpriteNode(imageNamed: "BackToGameButton")
    var textField0: UITextField!
    var textField1: UITextField!
    var textField2: UITextField!
    var textField3: UITextField!
    var textField4: UITextField!
    var textField5: UITextField!
    var textField6: UITextField!
    var textField7: UITextField!
    var textField8: UITextField!
    var textField9: UITextField!
    var username = String()
    
    var userName = String()
    var highScore = Int()
    //var player = PlayerEntries()
    var listOfEntries = [PlayerEntries]()
    var firstPlace = String()
    
    
    var playableRect: CGRect
    var deviceWidth = UIScreen.main.bounds.width
    var deviceHeight = UIScreen.main.bounds.height
    
    
    override func sceneDidLoad() {
        background.position = CGPoint(x: size.width / 2 , y: size.height / 2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        addChild(background)
        
        usernameSceneImage.position = CGPoint(x: size.width/2, y: (deviceHeight - deviceHeight) + usernameSceneImage.size.height / 1.5)
        addChild(usernameSceneImage)
        
        //leaderboardGreeting.position = CGPoint(x: size.width / 2, y: (size.height / 2 + backToGameButton.size.height) + leaderboardGreeting.size.height)
        //addChild(leaderboardGreeting)
        
        backToGameButton.position = CGPoint(x: (size.width - size.width) + 75, y: (size.height - size.height) + 30)
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
        textField0 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 140, width: size.width / 1.25, height: 35))
        textField1 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 105, width: size.width / 1.25, height: 35))
        textField2 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 70, width: size.width / 1.25, height: 35))
        textField3 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 35, width: size.width / 1.25, height: 35))
        textField4 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2, width: size.width / 1.25, height: 35))
        textField5 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 + 35, width: size.width / 1.25, height: 35))
        textField6 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 + 70, width: size.width / 1.25, height: 35))
        textField7 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 + 105, width: size.width / 1.25, height: 35))
        textField8 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 + 140, width: size.width / 1.25, height: 35))
        textField9 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 + 175, width: size.width / 1.25, height: 35))
        //customize(textField: textField)
        view.addSubview(textField0)
        view.addSubview(textField1)
        view.addSubview(textField2)
        view.addSubview(textField3)
        view.addSubview(textField4)
        view.addSubview(textField5)
        view.addSubview(textField6)
        view.addSubview(textField7)
        view.addSubview(textField8)
        view.addSubview(textField9)
        //textField.addTarget(self, action: #selector(UserRegistration.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }
    
    func customize(textField: UITextField, isSecureTextEntry: Bool = false) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftView = paddingView
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.leftViewMode = UITextFieldViewMode.always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        //textField.layer.borderColor = UIColor.black.cgColor
        //textField.layer.borderWidth = 0.5
        //textField.layer.cornerRadius = 4.0
        textField.textColor = .black
        //textField.isSecureTextEntry = isSecureTextEntry
        textField.text = self.firstPlace
    }

 
    /*
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
        textField.text = self.firstPlace
    }
    */
    
    func textFieldDidChange(textField: UITextField) {
        if textField == self.textField0 {
            self.firstPlace = textField.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func loadHighScores() {
        let ref: DatabaseReference!
        ref = Database.database().reference().child("Users")
        ref.observe(.value, with: { (snapshot) in
            let entries = snapshot.children
            for entry in entries {
                if let pair = entry as? DataSnapshot {
                    if let score = pair.value {
                        let name = pair.key
                        self.userName = name
                        self.highScore = score as! Int
                    }
                    var player = PlayerEntries(playerName: self.userName, score: self.highScore)
                    self.listOfEntries.append(player)
                }
            }
            /*
            let result = self.listOfEntries.sorted{ $0.score > $1.score }
            print (result[0])
            self.firstPlace = "Player: \(result[0].playerName) - Score: \(result[0].score)"
            print (self.firstPlace)
            self.customize(textField: self.textField0)
            self.customize(textField: self.textField1)
            self.customize(textField: self.textField2)
            self.customize(textField: self.textField3)
            self.customize(textField: self.textField4)
            self.customize(textField: self.textField5)
            self.customize(textField: self.textField6)
            self.customize(textField: self.textField7)
            self.customize(textField: self.textField8)
            self.customize(textField: self.textField9)
            */
            self.populateLeaderboard()
        })
    }
    
    func populateLeaderboard() {
        print (self.listOfEntries)
        let result = self.listOfEntries.sorted{ $0.score > $1.score }
        print (result[0])
        self.firstPlace = "\(result[0].playerName) :               \(result[0].score)"
        print (self.firstPlace)
        self.customize(textField: self.textField0)
        self.customize(textField: self.textField1)
        self.customize(textField: self.textField2)
        self.customize(textField: self.textField3)
        self.customize(textField: self.textField4)
        self.customize(textField: self.textField5)
        self.customize(textField: self.textField6)
        self.customize(textField: self.textField7)
        self.customize(textField: self.textField8)
        self.customize(textField: self.textField9)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

