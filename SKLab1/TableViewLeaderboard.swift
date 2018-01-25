//
//  TableViewLeaderboard.swift
//  SKLab1
//
//  Created by Lisa Steele on 1/24/18.
//  Copyright © 2018 lisahsteele. All rights reserved.
//

import UIKit
import SpriteKit

struct PlayerEntries {
    var playerName: String
    var score: Int
    
    init(playerName: String, score: Int) {
        self.playerName = playerName
        self.score = score
    }
}

class TableViewLeaderboard: UITableView, UITableViewDelegate, UITableViewDataSource {
    var items: [String] = ["Player1", "Player2", "Player3"]
    
    
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
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your high score is: X"
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
}

class LeaderboardScene: SKScene {
    var leaderboardTableView = TableViewLeaderboard()
    var playableRect: CGRect
    var deviceWidth = UIScreen.main.bounds.width
    var deviceHeight = UIScreen.main.bounds.height
    
    var currentPlayerLabel: UILabel!
    var counterLabel = SKLabelNode()
    var totalLabel = SKLabelNode()
    
    var background: SKSpriteNode! = nil
    let usernameSceneImage = SKSpriteNode(imageNamed: "UsernameSceneImage")
    let backToGameButton = SKSpriteNode(imageNamed: "BackToGameButton")
    
    let scoreKey = "SKLab_Highscore"
    
    override func didMove(to: SKView) {
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
        
        counterLabel.position = CGPoint(x: size.width - 50, y: (size.height - size.height) + 50)
        counterLabel.fontColor = SKColor.black
        counterLabel.fontSize = 15
        addChild(counterLabel)
        
        totalLabel.position = CGPoint(x: size.width - 50, y: (size.height - size.height) + 30)
        totalLabel.fontColor = SKColor.black
        totalLabel.fontSize = 15
        addChild(totalLabel)
        
        guard let view = self.view else {return}
        let originX = (size.width / 2) / 5
        
        
        leaderboardTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        leaderboardTableView.backgroundColor = UIColor.gray
        leaderboardTableView.frame = CGRect(x: originX, y: (size.height / 2) - 100, width: size.width / 1.25, height: 250)
        self.scene?.view?.addSubview(leaderboardTableView)
        leaderboardTableView.reloadData()
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
