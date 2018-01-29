//
//  TableViewLeaderboard.swift
//  SKLab1
//
//  Created by Lisa Steele on 1/24/18.
//  Copyright © 2018 lisahsteele. All rights reserved.
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

var tableData = [PlayerEntries]()

class TableViewLeaderboard: UITableView, UITableViewDelegate, UITableViewDataSource {
    var userName = String()
    var highScore = Int()
    let scoreKey = "SKLab_Highscore"
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        print (tableData)
        let entry = tableData[indexPath.row]
        let player = entry.playerName
        let score = entry.score
        
        cell.textLabel?.text = "\(player) : \(score)"
        cell.textLabel?.textColor = UIColor.darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your high score is: X"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let defaults = UserDefaults.standard
        let highScore = defaults.integer(forKey: scoreKey)
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 247/255, green: 237/255, blue: 205/255, alpha: 1.0)
        
        let label = UILabel(frame: CGRect(x: 10, y: 7, width: tableView.bounds.size.width, height: 15 ))
        label.textColor = UIColor.darkGray
        label.text = "Your high score is: \(highScore)"
        label.sizeToFit()
        headerView.addSubview(label)
        return headerView
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
}

class LeaderboardScene: SKScene {
    var leaderboardTableView = TableViewLeaderboard()
    var scrollView: UIScrollView!
    var playableRect: CGRect
    var deviceWidth = UIScreen.main.bounds.width
    var deviceHeight = UIScreen.main.bounds.height
    
    var count = Int()
    var total = Int()
    var userName = String()
    var highScore = Int()
    var listOfEntries = [PlayerEntries]()
    var result = [PlayerEntries]()
    
    var background: SKSpriteNode! = nil
    let usernameSceneImage = SKSpriteNode(imageNamed: "UsernameSceneImage")
    let backToGameButton = SKSpriteNode(imageNamed: "BackToGameButton")
    
    override func didMove(to: SKView) {
        loadHighScores()
        
        if UIScreen.main.sizeType == .iphone4 {
            background = SKSpriteNode(imageNamed: "LeaderboardBackground4")
        } else if UIScreen.main.sizeType == .iphone5 {
            background = SKSpriteNode(imageNamed: "LeaderboardBackground5s")
        } else if UIScreen.main.sizeType == .iphone6 {
            background = SKSpriteNode(imageNamed: "LeaderboardBackground6")
        } else if UIScreen.main.sizeType == .iphonePlus {
            background = SKSpriteNode(imageNamed: "LeaderboardBackgroundPlus")
        }
        
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        addChild(background)
        
        usernameSceneImage.position = CGPoint(x: size.width/2, y: (deviceHeight - deviceHeight) + usernameSceneImage.size.height / 1.5)
        addChild(usernameSceneImage)
        
        backToGameButton.position = CGPoint(x: (size.width - size.width) + 75, y: (size.height - size.height) + 30)
        addChild(backToGameButton)
        
        guard let view = self.view else {return}
        let originX = (size.width / 2) / 5
        
        leaderboardTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        leaderboardTableView.backgroundColor = UIColor(red: 247/255, green: 237/255, blue: 205/255, alpha: 1.0)
        
        
        if UIScreen.main.sizeType == .iphone4 {
            leaderboardTableView.frame = CGRect(x: originX, y: (size.height / 2) - 100, width: size.width / 1.25, height: 250)
        } else if UIScreen.main.sizeType == .iphone5 {
            leaderboardTableView.frame = CGRect(x: originX, y: (size.height / 2) - 125, width: size.width / 1.25, height: 325)
        } else if UIScreen.main.sizeType == .iphone6 {
            leaderboardTableView.frame = CGRect(x: originX, y: (size.height / 2) - 150, width: size.width / 1.25, height: 400)
        } else if UIScreen.main.sizeType == .iphonePlus {
            leaderboardTableView.frame = CGRect(x: originX, y: (size.height / 2) - 175, width: size.width / 1.25, height: 465)
        }
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.clear
        scrollView.contentSize = leaderboardTableView.bounds.size
        scrollView.addSubview(leaderboardTableView)
        self.scene?.view?.addSubview(scrollView)
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
            self.result = self.listOfEntries.sorted{ $0.score > $1.score }
            //let topTen = self.result.prefix(10)
            tableData = self.result
            self.leaderboardTableView.reloadData()
        })
    }
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = deviceHeight / deviceWidth
        let playableWidth = size.height / maxAspectRatio
        let playableMargin = (size.width - playableWidth) / 2.0
        playableRect = CGRect(x: playableMargin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
