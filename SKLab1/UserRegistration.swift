//
//  UserRegistration.swift
//  SKLab1
//
//  Created by Lisa Steele on 12/12/17.
//  Copyright © 2017 lisahsteele. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import Firebase
import FirebaseDatabase

class UserRegistration: SKScene, UITextFieldDelegate {
    
    var background : SKSpriteNode! = nil
    let usernameSceneImage = SKSpriteNode(imageNamed: "UsernameSceneImageLg")
    let createUsernameLabel = SKSpriteNode(imageNamed: "CreateUsernameLabel")
    let backButtonSm = SKSpriteNode(imageNamed: "BackButtonSm")
    let submitButtonSm = SKSpriteNode(imageNamed: "SubmitButtonSm")
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
        
        if UIScreen.main.sizeType == .iphone4 {
            background = SKSpriteNode(imageNamed: "GameOverBackground4")
        } else if UIScreen.main.sizeType == .iphone5 {
            background = SKSpriteNode(imageNamed: "GameOverBackground5s")
        } else if UIScreen.main.sizeType == .iphone6 {
            background = SKSpriteNode(imageNamed: "GameOverBackground6")
        } else if UIScreen.main.sizeType == .iphonePlus {
            background = SKSpriteNode(imageNamed: "GameOverBackgroundPlus")
        } else if UIScreen.main.sizeType == .iphoneX {
            background = SKSpriteNode(imageNamed: "GameOverBackgroundX")
        }
        
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        addChild(background)
        
        usernameSceneImage.position = CGPoint(x: size.width / 2, y: (deviceHeight - deviceHeight) + usernameSceneImage.size.height)
        usernameSceneImage.zPosition = 0
        addChild(usernameSceneImage)
        
        submitButtonSm.position = CGPoint(x: size.width/2 + submitButtonSm.size.width/2, y: size.height/2 - submitButtonSm.size.height * 1.5)
        submitButtonSm.zPosition = 1
        addChild(submitButtonSm)
        
        backButtonSm.position = CGPoint(x: size.width/2 - backButtonSm.size.width/2, y: size.height/2 - backButtonSm.size.height * 1.5)
        backButtonSm.zPosition = 2
        addChild(backButtonSm)
        
        createUsernameLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + createUsernameLabel.size.height * 2)
        addChild(createUsernameLabel)
        
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
            
            if backButtonSm.contains(location) {
                DispatchQueue.main.async(execute: {
                    self.usernameTextField.removeFromSuperview()
                })
                let scene = GameScene(size: size)
                self.view?.presentScene(scene)
            }
            
            if submitButtonSm.contains(location) {
                self.checkForUsernameInFirebase()
            }
            
        }
    }
    
    
    override func didMove(to view: SKView) {
        guard let view = self.view else {return}
        
        let originX = (size.width - size.width / 2) / 2
        usernameTextField = UITextField(frame: CGRect.init(x: originX, y: size.height / 2 - 40, width: size.width / 2, height: 50))
        customize(textField: usernameTextField, placeholder: "Username")
        view.addSubview(usernameTextField)
        usernameTextField.addTarget(self, action: #selector(UserRegistration.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }
   
    func saveUsernameToFirebase() {
        let defaults = UserDefaults.standard
        let highScore = defaults.integer(forKey: scoreKey)
        defaults.set(username, forKey: usernameKey)
        
        if self.usernameExists == false {
            var ref: DatabaseReference!
            ref = Database.database().reference().child("Users")
            let childUpdates = [username : highScore]
            ref.updateChildValues(childUpdates)
            displaySuccessAlertMessage(messageToDisplay: "Your high score now lives in the UDON hall of fame.")
        }
    }
    
    func checkForUsernameInFirebase() {
        var ref: DatabaseReference!
        ref = Database.database().reference().child("Users")
        _ = ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for item in snapshot.children {
                if let pair = item as? DataSnapshot {
                    let userName = pair.key
                        if userName == self.username {
                            self.displayUsernameExistsAlertMessage(messageToDisplay: "This username is already taken.")
                            return
                        } else {
                            self.usernameExists = false
                        }
                }
            }
             self.saveUsernameToFirebase()
        })
    }
    
    func customize(textField: UITextField, placeholder: String, isSecureTextEntry: Bool = false) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        textField.leftView = paddingView
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.leftViewMode = UITextFieldViewMode.always
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 4.0
        textField.textColor = .darkGray
        textField.isSecureTextEntry = isSecureTextEntry
        textField.delegate = self
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if textField == self.usernameTextField {
            self.username = textField.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func displayUsernameExistsAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Sorry!", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
        }
        
        alertController.addAction(OKAction)
        if let vc = self.scene?.view?.window?.rootViewController {
            if vc.presentedViewController == nil {
                vc.present(alertController, animated: true, completion: nil)
            } else {
                DispatchQueue.main.async(execute: {
                    vc.dismiss(animated: true, completion: { 
                        vc.present(alertController, animated: true, completion: nil)
                    })
                })
            }
        }
    }
    
    func displaySuccessAlertMessage(messageToDisplay: String) {
        let successAlertController = UIAlertController(title: "Congratulations!", message: messageToDisplay, preferredStyle: .alert)
        
        let viewLeaderboardAction = UIAlertAction(title: "View Leaderboard", style: .default) { (action: UIAlertAction!) in
            let scene = LeaderboardScene(size: self.size)
            self.view?.presentScene(scene)
            DispatchQueue.main.async(execute: {
                self.usernameTextField.removeFromSuperview()
            })
        }
        
        successAlertController.addAction(viewLeaderboardAction)
        if let vc = self.scene?.view?.window?.rootViewController {
            if vc.presentedViewController == nil {
                vc.present(successAlertController, animated: true, completion: nil)
            } else {
                DispatchQueue.main.async(execute: {
                    vc.dismiss(animated: true, completion: {
                        vc.present(successAlertController, animated: true, completion: nil)
                    })
                })
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

