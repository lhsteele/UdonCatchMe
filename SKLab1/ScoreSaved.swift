//
//  ScoreSaved.swift
//  SKLab1
//
//  Created by Lisa Steele on 1/10/18.
//  Copyright © 2018 lisahsteele. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import Firebase
import FirebaseDatabase

class ScoreSaved: SKScene, UITextFieldDelegate {
    
    let background = SKSpriteNode(imageNamed: "GameOverBackground")
    let usernameSceneImage = SKSpriteNode(imageNamed: "UsernameSceneImageLg")
    let scoreSavedLabel = SKSpriteNode(imageNamed: "ScoreSavedLabel")
    let leaderboardButtonTexture = SKTexture(imageNamed: "ViewLeaderboardSm")
    var leaderboardButton: SKSpriteNode! = nil
    var usernameTextField: UITextField!
    var fireUserID = String()
    var username = String()
    let scoreKey = "SKLab_Highscore"
    let usernameKey = "DBUsername"
    var usernameExists = true
    
    var playableRect: CGRect
    var deviceWidth = UIScreen.main.bounds.width
    var deviceHeight = UIScreen.main.bounds.height
    
    
    
    override func sceneDidLoad() {
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        addChild(background)
        
        usernameSceneImage.position = CGPoint(x: size.width / 2, y: (deviceHeight - deviceHeight) + usernameSceneImage.size.height)
        addChild(usernameSceneImage)

        leaderboardButton = SKSpriteNode(texture: leaderboardButtonTexture)
        leaderboardButton.position = CGPoint(x: size.width/2, y: (size.height/2 - 20) - leaderboardButton.size.height)
        addChild(leaderboardButton)
        
        scoreSavedLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + scoreSavedLabel.size.height * 2)
        addChild(scoreSavedLabel)
        
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
            
            if leaderboardButton.contains(location) {
                self.saveScoreToFirebase()
                DispatchQueue.main.async(execute: {
                    self.usernameTextField.removeFromSuperview()
                    self.scoreSavedLabel.removeFromParent()
                })
                let scene = Leaderboard(size: size)
                self.view?.presentScene(scene)
            }

        }
    }
    
    
    override func didMove(to view: SKView) {
        let defaults = UserDefaults.standard
        let savedUsername = defaults.object(forKey: usernameKey) as? String ?? String()
        print (savedUsername)
        guard let view = self.view else {return}
        
        let originX = (size.width - size.width / 2) / 2
        usernameTextField = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 40, width: size.width / 2, height: 50))
        customize(textField: usernameTextField, placeholder: "", textFieldText: savedUsername)
        view.addSubview(usernameTextField)
        usernameTextField.addTarget(self, action: #selector(UserRegistration.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }
    

    
    func customize(textField: UITextField, placeholder: String, textFieldText: String?) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        textField.leftView = paddingView
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName : UIColor.gray])
        textField.textAlignment = .center
        textField.text = textFieldText
        textField.font = UIFont(name: "AvenirNext-Light", size: 20)
        textField.textColor = UIColor.darkGray
    }
    
    func textFieldDidChange(textField: UITextField) {
        if textField == self.usernameTextField {
            self.username = textField.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func saveScoreToFirebase() {
        let defaults = UserDefaults.standard
        let highScore = defaults.integer(forKey: scoreKey)
        let savedUsername = defaults.object(forKey: usernameKey) as? String ?? String()
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("Users")
        let childUpdates = [savedUsername : highScore]
        ref.updateChildValues(childUpdates)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

