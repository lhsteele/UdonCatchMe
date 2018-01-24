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
    
    var background: SKSpriteNode! = nil
    let usernameSceneImage = SKSpriteNode(imageNamed: "UsernameSceneImage")
    let backToGameButton = SKSpriteNode(imageNamed: "BackToGameButton")
    
    let scoreKey = "SKLab_Highscore"
    
    var playableRect: CGRect
    var deviceWidth = UIScreen.main.bounds.width
    var deviceHeight = UIScreen.main.bounds.height
    
    override init(frame: CGRect, style: UITableViewStyle) {
        let maxAspectRatio: CGFloat = deviceHeight / deviceWidth
        let playableWidth = frame.height / maxAspectRatio
        let playableMargin = (frame.width - playableWidth) / 2.0
        playableRect = CGRect(x: playableMargin, y: 0, width: playableWidth, height: frame.height)
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
    
}

class LeaderboardScene: SKScene {
    var
}

