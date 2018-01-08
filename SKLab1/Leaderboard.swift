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
    
    let background = SKSpriteNode(imageNamed: "LeaderboardBackground")
    let usernameSceneImage = SKSpriteNode(imageNamed: "UsernameSceneImage")
    let backToGameButton = SKSpriteNode(imageNamed: "BackToGameButton")

    var textField0: UITextField!
    var textField01: UITextField!
    var textField1: UITextField!
    var textField2: UITextField!
    var textField3: UITextField!
    var textField4: UITextField!
    var textField5: UITextField!
    var textField6: UITextField!
    var textField7: UITextField!
    var textField8: UITextField!
    var textField9: UITextField!
    var labelTextField: UITextField!
    var username = String()
    
    var userName = String()
    var highScore = Int()
    var listOfEntries = [PlayerEntries]()
    
    var leaderboardEntry = String()
    var firstPlace = String()
    var secondPlace = String()
    var thirdPlace = String()
    var fourthPlace = String()
    var fifthPlace = String()
    var sixthPlace = String()
    var seventhPlace = String()
    var eigthPlace = String()
    var ninthPlace = String()
    var tenthPlace = String()
    
    
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
                DispatchQueue.main.async(execute: {
                    self.textField0.removeFromSuperview()
                    self.textField1.removeFromSuperview()
                    self.textField2.removeFromSuperview()
                    self.textField3.removeFromSuperview()
                    self.textField4.removeFromSuperview()
                    self.textField5.removeFromSuperview()
                    self.textField6.removeFromSuperview()
                    self.textField7.removeFromSuperview()
                    self.textField8.removeFromSuperview()
                    self.textField9.removeFromSuperview()
                    self.labelTextField.removeFromSuperview()
                })
            }
        }
    }
    
    
    override func didMove(to view: SKView) {
        guard let view = self.view else {return}
        let originX = (size.width / 2) / 5
        let originX2 = size.width / 2
        labelTextField = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 175, width: size.width / 1.25, height: 35))
        textField0 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 140, width: size.width / 2.5, height: 35))
        textField01 = UITextField(frame: CGRect.init(x: originX2, y: size.height / 2 - 140, width: size.width / 2.5, height: 35))
        //textField0 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 140, width: size.width / 1.25, height: 35))
        textField1 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 105, width: size.width / 1.25, height: 35))
        textField2 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 70, width: size.width / 1.25, height: 35))
        textField3 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 35, width: size.width / 1.25, height: 35))
        textField4 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2, width: size.width / 1.25, height: 35))
        textField5 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 + 35, width: size.width / 1.25, height: 35))
        textField6 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 + 70, width: size.width / 1.25, height: 35))
        textField7 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 + 105, width: size.width / 1.25, height: 35))
        textField8 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 + 140, width: size.width / 1.25, height: 35))
        textField9 = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 + 175, width: size.width / 1.25, height: 35))
        view.addSubview(labelTextField)
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
    }
    
    func customize(textField: UITextField, placeholder: String, textFieldText: String?) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftView = paddingView
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName : UIColor.gray])
        textField.text = textFieldText
        
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 4.0
    }
    
    
    /*
    func textFieldDidChange(textField: UITextField) {
        if textField == self.textField0 {
            self.firstPlace = textField.text!
        }
    }
    */
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
                    let player = PlayerEntries(playerName: self.userName, score: self.highScore)
                    self.listOfEntries.append(player)
                }
            }
            //self.populateLeaderboard()
            self.customize(textField: self.textField0, placeholder: "Player", textFieldText: "")
            self.customize(textField: self.textField01, placeholder: "Score", textFieldText: "")
            
        })
    }
    
    func populateLeaderboard() {
        let result = self.listOfEntries.sorted{ $0.score > $1.score }
        var textFieldArray = [textField0, textField1, textField2, textField3, textField4, textField5, textField6, textField7, textField8, textField9]
        for (index, _) in result.enumerated() {
            leaderboardEntry = "\(result[index].playerName) :                    \(result[index].score)"
            print (leaderboardEntry)
            for textField in textFieldArray {
                if let entry = leaderboardEntry as? String {
                    _ = self.customize(textField: textFieldArray[index]!, placeholder: "", textFieldText: leaderboardEntry)
                } else {
                    _ = self.customize(textField: textFieldArray[index]!, placeholder: "Player:               Score:", textFieldText: nil)
                }
            }
        }
        customize(textField: labelTextField, placeholder: "", textFieldText: "Player                              Score")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

