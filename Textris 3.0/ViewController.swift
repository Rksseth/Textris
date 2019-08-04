//
//  ViewController.swift
//  Textris 3.0
//
//  Created by Ravi Seth on 2018-02-18.
//  Copyright © 2018 Sethco. All rights reserved.
//
/*
IMPROVEMENTS
 SOUNDS
 SCORING VIEWCONTROLLER PAGE
 EASY MEDIUM HARD DROP DOWN LIST, JUST LIKE SCORING AND LEADERBOARD DROP UP LIST

 */

import UIKit
import Foundation
import GameKit
import AVFoundation

let m = Matrix()
var ani = Matrix()
var root = ViewController()
var score_view = MyTableViewController()

class MyTableViewController:UITableViewController{
    
    //var items = ["item 1","item 2","item 3"]
    var items = ["MODES","EASY","MEDIUM","HARD","SWIPING","SWIPE LEFT, RIGHT","SWIPE DOWN","LETTER POINTS","A, E, I, O, U, L, N, S, T, R","D, G","B, C, M, P","F, H, V, W, Y","K","J, X","Q, Z"]
    var pts = ["minimum word length","3 letters","4 letters","5 letters","","move letter left, right","move letter to bottom", "","+1","+2","+3","+4","+5","+8","+10"] as [Any]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.register(MyCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
        tableView.sectionHeaderHeight = m.screenSize.height/10
        tableView.rowHeight = m.screenSize.height/10
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell =  tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MyCell
        myCell.nameLabel.text = items[indexPath.row]
        myCell.points_lbl.text = "\(pts[indexPath.row])"
        
        //  FONT --------------------------------------------------
        if myCell.nameLabel.text == "MODES" || myCell.nameLabel.text == "LETTER POINTS" || myCell.nameLabel.text == "SWIPING"{
            myCell.nameLabel.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/25)
        }
        else if ((myCell.nameLabel.text?.range(of: "SWIPE")) != nil){
            myCell.nameLabel.font = UIFont(name: "Avenir-BookOblique", size: m.screenSize.height/35)
        }
        else{
            myCell.nameLabel.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/35)
        }
        //  --------------------------------------------------------
        //  COLOUR --------------------------------------------------
        if myCell.nameLabel.text == "EASY"{
            myCell.nameLabel.textColor = UIColor(red:50.0/255,green:150.0/255,blue:255.0/255,alpha: 1.0)
        }
        else if myCell.nameLabel.text == "MEDIUM"{
            myCell.nameLabel.textColor = UIColor(red:255.0/255,green:180.0/255,blue:80.0/255,alpha: 1.0)
        }
        else if myCell.nameLabel.text == "HARD"{
            myCell.nameLabel.textColor = UIColor(red:20.0/255,green: 200.0/255,blue:20.0/255,alpha: 1.0)
        }
        else if indexPath.row > 7 && indexPath.row < 15{
            let index = indexPath.row - 8
            ani.basis.letter = ani.data[0][index]!.letter
            let points = ani.wordPoints(word: String(ani.basis.letter))
            let colours = ani.basis.setColor(points: points)
            myCell.nameLabel.textColor = UIColor(red: colours[0]/255.0, green: colours[1]/255.0, blue: colours[2]/255.0, alpha: 1.0)
        }
        else{
            myCell.nameLabel.textColor = UIColor.black
        }
        //  --------------------------------------------------------
        
        return myCell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId")
    }
}
class Header: UITableViewHeaderFooterView{
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let nameLabel:UILabel = {
        let label = UILabel()
        label.text = "INSTRUCTIONS"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/30)//UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.black
        return label
    }()
    let actionButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.textAlignment = .right
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/30)
        button.showsTouchWhenHighlighted = true
        button.titleLabel?.textColor = UIColor.black
        return button
    }()
    func setupView(){
        self.backgroundColor = UIColor(red:255.0/255,green:255.0/255,blue:230.0/255,alpha: 1.0)
        addSubview(nameLabel)
        addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(self.handleAction), for: .touchUpInside)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0(\(m.screenSize.width))]-0-[v1(80)]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":nameLabel,"v1":actionButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":actionButton]))
    }
    @objc func handleAction(){
        score_view.dismiss(animated: true, completion: nil)
    }
}
class MyCell:UITableViewCell{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let nameLabel:UILabel = {
        let label = UILabel()
        label.text = "Sample item"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/40)
        label.textColor = UIColor.black
        return label
    }()
    let points_lbl:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Light", size: m.screenSize.height/40)
        label.textColor = UIColor.black
        return label
    }()
    func setupView(){
        addSubview(nameLabel)
        addSubview(points_lbl)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-8-[v1]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":nameLabel,"v1":points_lbl]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":points_lbl]))
    }
    
}
class ViewController3: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // define arrays for table
    private let fruit: NSArray = ["apple", "orange", "banana", "strawberry", "lemon"]
    private let vegitable: NSArray = ["carrots", "avocado", "potato", "onion"]
    
    // define category array for section
    private let sections: NSArray = ["fruit", "vegitable"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get width and height of View
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // make tableview
        let myTableView: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        
        // register cell name
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        // set DataSource
        myTableView.dataSource = self
        
        // set Delegate
        myTableView.delegate = self
        
        // add it to View
        self.view.addSubview(myTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // return the number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    // return the title of sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section] as? String
    }
    
    // called when the cell is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            //print("Value: \(fruit[indexPath.row])")
        } else if indexPath.section == 1 {
            //print("Value: \(vegitable[indexPath.row])")
        }
    }
    
    // return the number of cells each section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return fruit.count
        } else if section == 1 {
            return vegitable.count
        } else {
            return 0
        }
    }
    
    // return cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "\(fruit[indexPath.row])"
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "\(vegitable[indexPath.row])"
        }
        
        return cell
    }
    
}
class View2:UIViewController{
    var bg_lbl:UILabel = UILabel()
    var back_btn:UIButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.bg_lbl = UILabel(frame: CGRect(x: 0, y: 0, width: m.screenSize.width, height: m.screenSize.height))
        self.bg_lbl.center = CGPoint(x : m.screenSize.width/2,  y: m.screenSize.height/2)
        self.bg_lbl.backgroundColor = UIColor(red:255.0/255,green:255.0/255,blue:230.0/255,alpha: 1.0)
        self.bg_lbl.textAlignment = .center
        self.view.addSubview(bg_lbl)
        
        self.back_btn = UIButton(frame: CGRect(x: 0, y: 0, width: m.screenSize.width/2, height: m.screenSize.height/20))
        self.back_btn.center = CGPoint(x : m.screenSize.width/2,  y: m.screenSize.height/16)
        self.back_btn.setTitle("BACK", for: UIControlState.normal)
        self.back_btn.setTitleColor(UIColor(red:50.0/255,green:150.0/255,blue:255.0/255,alpha: 1.0), for: .normal)
        self.back_btn.titleLabel?.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/40)
        self.back_btn.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        self.back_btn.layer.cornerRadius = self.back_btn.frame.height/3
        self.back_btn.layer.backgroundColor = UIColor(red:50.0/255,green:150.0/255,blue:255.0/255,alpha: 0.25).cgColor
        self.back_btn.showsTouchWhenHighlighted = true
        self.view.addSubview(back_btn)
        
        showPoints()
        super.viewDidLoad()
        
        //showPoints()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showPoints(){
        let incrementY = m.screenSize.height/20
        let dist = ["A, E, I, O, U, L, N, S, T, R","D, G","B, C, M, P","F, H, V, W, Y","K","J, X","Q, Z"]
        let pts = [1,2,3,4,5,8,10]
        
        var y:CGFloat = 0
        
        
        var text = "SCORING\n"
        for i in 0...dist.count-1{
            text.append("\(pts[i]) point(s) = '\(dist[i])' ")
            if i != dist.count-1{
                text.append("\n")
            }
            /*
            let letter = dist[i]
            let points = pts[i]
            var p_lbl:UILabel = UILabel()
            p_lbl = UILabel(frame: CGRect(x: 0, y: 0, width: m.screenSize.width/1.5, height: m.screenSize.width/10))
            p_lbl.center = CGPoint(x : m.screenSize.width/2,  y: m.screenSize.height/16*3+y*incrementY)
            p_lbl.font = UIFont(name: "Avenir-Light", size: m.screenSize.height/40)
            p_lbl.textAlignment = .right
            p_lbl.text = "'\(letter.uppercased())' = +\(points)"
            p_lbl.layer.backgroundColor = UIColor(white: 1, alpha: 0.0).cgColor
            //p_lbl.layer.borderWidth = 1
            p_lbl.layer.cornerRadius = p_lbl.frame.height/2
            self.view.addSubview(p_lbl)
            y += 1
             */
        }
        let p_lbl = UILabel(frame: CGRect(x: 0, y: 0, width: m.screenSize.width*0.9, height: m.screenSize.height/2.5))
        p_lbl.center = CGPoint(x : m.screenSize.width/2,  y: m.screenSize.height/3)
        p_lbl.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/40)
        p_lbl.textAlignment = .center
        p_lbl.text = text
        p_lbl.textColor = UIColor(red:0.0/255,green:0.0/255,blue:0.0/255,alpha: 0.8)//UIColor.white
        //p_lbl.layer.backgroundColor = UIColor(red:255.0/255,green:180.0/255,blue:80.0/255,alpha: 1.0).cgColor
        p_lbl.layer.borderWidth = 0
        p_lbl.layer.borderColor = UIColor(red:255.0/255,green:180.0/255,blue:80.0/255,alpha: 1.0).cgColor
        p_lbl.layer.cornerRadius = p_lbl.frame.height/4
        p_lbl.numberOfLines = dist.count+1
        self.view.addSubview(p_lbl)
    }
    @objc func back(){
        root.back()
        
    }
}
class ViewController: UIViewController,GKGameCenterControllerDelegate {
    var timer = Timer()
    var someBlock:Block? = nil//Block(letter0: "0")
    
    var title_btn:UIButton = UIButton()
    var score_lbl:UILabel = UILabel()
    var gCenter_btn:UIButton = UIButton()
    var bg_lbl:UILabel = UILabel()
    var time_lbl:UILabel = UILabel()
    var badge_lbl:UILabel = UILabel()
    var play_lbl:UILabel = UILabel()
    var about_btn:UIButton = UIButton()
    var hard_btn:UIButton = UIButton()
    var med_btn:UIButton = UIButton()
    var again_btn:UIButton = UIButton()
    
    var isPlay:Bool = false
    
    var highScore = UserDefaults().integer(forKey: "HIGHSCORE")
    var highScore_med = UserDefaults().integer(forKey: "HIGHSCORE_MED")
    var highScore_hard = UserDefaults().integer(forKey: "HIGHSCORE_HARD")
    
    var gScore:Int = 0
    
    var textris_timer:Timer? = nil
    
    var time_timer:Timer? = nil
    
    var str:String = ""
    var title2:String = ""
    
    var aud : AVAudioPlayer! //INTRO MUSIC
    var aud2 : AVAudioPlayer! //GAME PLAY MUSIC
    var aud3 : AVAudioPlayer! //GOT WORD SOUND/
    var aud4 : AVAudioPlayer! //END OF GAME MUSIC
    var aud5 : AVAudioPlayer! //20 SECONDS LEFT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Gestures
        
        /*
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
         */
        
        //let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        //swipeDown.direction = UISwipeGestureRecognizerDirection.down
        //self.view.addGestureRecognizer(swipeDown)
        
        let panSwipe = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view.addGestureRecognizer(panSwipe)
        NSLog("Begin")
        //NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "HIGHSCORE")
        root = self
        
        
        
        self.bg_lbl = UILabel(frame: CGRect(x: 0, y: 0, width: m.screenSize.width, height: m.screenSize.height))
        self.bg_lbl.center = CGPoint(x : m.screenSize.width/2,  y: m.screenSize.height/2)
        self.bg_lbl.backgroundColor = UIColor(red:255.0/255,green:255.0/255,blue:230.0/255,alpha: 1.0)
        self.bg_lbl.textAlignment = .center
        root.view.addSubview(bg_lbl)
        
        //LEVELS////////////////////////////////////////////////////////
        self.title_btn = UIButton(frame: CGRect(x: 0, y: 0, width: m.screenSize.width/2, height: m.screenSize.height/20))
        self.title_btn.center = CGPoint(x : m.screenSize.width/2,  y: m.screenSize.height/16*3)
        self.title_btn.setTitle("EASY", for: .normal)
        self.title_btn.setTitleColor(UIColor(red:50.0/255,green:150.0/255,blue:255.0/255,alpha: 1.0), for: .normal)
        self.title_btn.titleLabel?.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/30)
        self.title_btn.addTarget(self, action: #selector(self.button_press(_:)), for: .touchUpInside)
        self.title_btn.layer.cornerRadius = self.title_btn.frame.height/3
        self.title_btn.layer.backgroundColor = UIColor(red:50.0/255,green:150.0/255,blue:255.0/255,alpha: 0.25).cgColor
        self.title_btn.showsTouchWhenHighlighted = true
        root.view.addSubview(title_btn)
        
        self.med_btn = UIButton(frame: CGRect(x: 0, y: 0, width: m.screenSize.width/2, height: m.screenSize.height/20))
        self.med_btn.center = CGPoint(x : m.screenSize.width/2,  y: m.screenSize.height/16*4)
        self.med_btn.setTitle("MEDIUM", for: .normal)
        self.med_btn.setTitleColor(UIColor(red:255.0/255,green:180.0/255,blue:80.0/255,alpha: 1.0), for: .normal)
        self.med_btn.titleLabel?.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/30)
        self.med_btn.addTarget(self, action: #selector(self.button_press(_:)), for: .touchUpInside)
        self.med_btn.layer.cornerRadius = self.med_btn.frame.height/3
        self.med_btn.layer.backgroundColor = UIColor(red:255.0/255,green:180.0/255,blue:80.0/255,alpha: 0.25).cgColor
        self.med_btn.showsTouchWhenHighlighted = true
        root.view.addSubview(med_btn)
        
        self.hard_btn = UIButton(frame: CGRect(x: 0, y: 0, width: m.screenSize.width/2, height: m.screenSize.height/20))
        self.hard_btn.center = CGPoint(x : m.screenSize.width/2,  y: m.screenSize.height/16*5)
        self.hard_btn.setTitle("HARD", for: .normal)
        self.hard_btn.setTitleColor(UIColor(red:20.0/255,green:200.0/255,blue:20.0/255,alpha: 1.0), for: .normal)
        self.hard_btn.titleLabel?.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/30)
        self.hard_btn.addTarget(self, action: #selector(self.button_press(_:)), for: .touchUpInside)
        self.hard_btn.layer.cornerRadius = self.hard_btn.frame.height/3
        self.hard_btn.layer.backgroundColor = UIColor(red:20.0/255,green:200.0/255,blue:20.0/255,alpha: 0.25).cgColor
        self.hard_btn.showsTouchWhenHighlighted = true
        root.view.addSubview(hard_btn)
        ////////////////////////////////////////////////////////////////////
        self.again_btn = UIButton(frame: CGRect(x: 0, y: 0, width: m.screenSize.width/2, height: m.screenSize.height/20))
        self.again_btn.center = CGPoint(x : m.screenSize.width/2,  y: m.screenSize.height/16*11.5+m.screenSize.height/2)
        self.again_btn.setTitle("PLAY AGAIN", for: .normal)
        self.again_btn.setTitleColor(UIColor(red:50.0/255,green:150.0/255,blue:255.0/255,alpha: 1.0), for: .normal)
        self.again_btn.titleLabel?.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/30)
        self.again_btn.addTarget(self, action: #selector(self.button_press(_:)), for: .touchUpInside)
        self.again_btn.layer.cornerRadius = self.again_btn.frame.height/3
        self.again_btn.layer.backgroundColor = UIColor(red:50.0/255,green:150.0/255,blue:255.0/255,alpha: 0.25).cgColor
        self.again_btn.showsTouchWhenHighlighted = true
        root.view.addSubview(again_btn)
        
        self.about_btn = UIButton(frame: CGRect(x: 0, y: 0, width: m.screenSize.width/2, height: m.screenSize.height/20))
        self.about_btn.center = CGPoint(x : m.screenSize.width/2,  y: m.screenSize.height/16*14)
        self.about_btn.setTitle("INSTRUCTIONS", for: .normal)
        self.about_btn.setTitleColor(UIColor(red:50.0/255,green:150.0/255,blue:255.0/255,alpha: 1.0), for: .normal)
        self.about_btn.titleLabel?.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/40)
        self.about_btn.addTarget(self, action: #selector(self.about), for: .touchUpInside)
        self.about_btn.layer.cornerRadius = self.title_btn.frame.height/3
        self.about_btn.layer.backgroundColor = UIColor(red:50.0/255,green:150.0/255,blue:255.0/255,alpha: 0.25).cgColor
        self.about_btn.showsTouchWhenHighlighted = true
        root.view.addSubview(about_btn)
        
        self.score_lbl = UILabel(frame: CGRect(x: 0, y: 0, width: m.screenSize.width/1.5, height: m.screenSize.height/3))
        self.score_lbl.layer.cornerRadius = self.score_lbl.frame.height/4
        self.score_lbl.center = CGPoint(x : m.screenSize.width/2,  y: m.screenSize.height/2+m.screenSize.height)
        //self.score_lbl.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/20)
        self.score_lbl.textColor = UIColor(red:50.0/255,green:150.0/255,blue:255.0/255,alpha: 1.0)//UIColor(red:220.0/255,green:20.0/255,blue:60.0/255,alpha: 1.0)
        //self.score_lbl.text = str
        self.setScore_lbl()
        self.score_lbl.textAlignment = .center
        self.score_lbl.layer.backgroundColor = UIColor.white.cgColor//UIColor(red:50.0/255,green:150.0/255,blue:255.0/255,alpha: 0.25).CGColor
        self.score_lbl.layer.borderColor = UIColor(red:100.0/255,green:100.0/255,blue:100.0/255,alpha: 1.0).cgColor
        self.score_lbl.layer.borderWidth = m.screenSize.width/100
        self.score_lbl.numberOfLines = 4
        self.score_lbl.alpha = 1.0
        self.score_lbl.transform = CGAffineTransform(scaleX: 1/4.0, y: 1/4.0)
        root.view.addSubview(score_lbl)
        
        /*
        self.badge_lbl = UILabel(frame: CGRect(x: 0, y: 0, width: m.screenSize.width/4, height: m.screenSize.width/4))
        self.badge_lbl.center = CGPoint(x : m.screenSize.width/2+self.score_lbl.bounds.size.width/2,  y: m.screenSize.height/16*3)
        self.badge_lbl.font = UIFont(name: "Avenir-BlackOblique", size: m.screenSize.height/40)
        self.badge_lbl.textColor = UIColor(red:90.0/255,green:215.0/255,blue:140.0/255,alpha: 1.0)
        self.badge_lbl.textAlignment = .Center
        self.badge_lbl.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/6))
        self.badge_lbl.text = "NEW"
        self.badge_lbl.layer.borderWidth = 2
        self.badge_lbl.layer.cornerRadius = self.badge_lbl.bounds.size.width
        self.badge_lbl.alpha = 0
        root.view.addSubview(badge_lbl)*/
        
        self.play_lbl = UILabel(frame: CGRect(x: 0, y: 0, width: m.screenSize.width/1.5, height: m.screenSize.height/5))
        self.play_lbl.center = CGPoint(x : m.screenSize.width/2,  y: m.screenSize.height/16*11)
        self.play_lbl.font = UIFont(name: "Avenir-Oblique", size: m.screenSize.height/30)
        self.play_lbl.textColor = UIColor(red:50.0/255,green:150.0/255,blue:255.0/255,alpha: 1.0)
        self.play_lbl.text = "HOW TO PLAY\nSWIPE LEFT\nSWIPE RIGHT\nMAKE WORDS"
        self.play_lbl.textAlignment = .center
        self.play_lbl.numberOfLines = 4
        root.view.addSubview(play_lbl)
        
        
        self.gCenter_btn = UIButton(frame: CGRect(x: 0, y: 0, width: m.screenSize.width/2, height: m.screenSize.height/20))
        
        self.gCenter_btn.center = CGPoint(x : m.screenSize.width/2,  y: m.screenSize.height/16*15)
        self.gCenter_btn.setTitle("LEADERBOARD", for: .normal)
        self.gCenter_btn.setTitleColor(UIColor(red:50.0/255,green:150.0/255,blue:255.0/255,alpha: 1.0), for: .normal)
        self.gCenter_btn.titleLabel?.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/40)
        self.gCenter_btn.addTarget(self, action: #selector(self.gCenter_press(_:)), for: .touchUpInside)
        self.gCenter_btn.layer.cornerRadius = self.gCenter_btn.frame.height/3
        self.gCenter_btn.layer.backgroundColor = UIColor(red:50.0/255,green:150.0/255,blue:255.0/255,alpha: 0.25).cgColor
        self.gCenter_btn.showsTouchWhenHighlighted = true
        
        root.view.addSubview(gCenter_btn)
        
        self.time_lbl = UILabel(frame: CGRect(x: 0, y: 0, width: m.screenSize.width, height: m.screenSize.height/20))
        self.time_lbl.center = CGPoint(x : m.screenSize.width/2,  y: m.screenSize.height/16*3)
        self.time_lbl.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/30)
        self.time_lbl.textAlignment = .center
        self.time_lbl.text = String(format: "%02d:%02d", 0,0)
        self.time_lbl.alpha = 0
        root.view.addSubview(time_lbl)
        
        //ani_shiftVertical(self.title_btn,vert: +m.screenSize.height/8)
        
        //ani_shiftVertical(self.gCenter_btn,vert: -m.screenSize.height/8)
        //addBlock()
        //updateCounter()
        ani.set_avail_blocks()
        m.set_avail_blocks()
        self.fadeViewIn(view: self.title_btn)
        self.fadeViewIn(view: self.med_btn)
        self.fadeViewIn(view: self.hard_btn)
        self.fadeViewIn(view: self.gCenter_btn)
        self.fadeViewIn(view: self.about_btn)
        self.fadeViewIn(view: self.play_lbl)
        
        self.str = "ADBFKJQ"//"TRXIEST"//"ADBFKJQ"
        self.title2 = "TEXTRIS"
        ani.changeSize(len: 3, wid: str.count)
        self.textris()
        root.view.bringSubview(toFront: score_lbl)
        root.view.bringSubview(toFront: title_btn)
        root.view.bringSubview(toFront: again_btn)
        
        
        authPlayer()
        
        
        //var audFilePath = Bundle.main.path(forResource: "textris intro", ofType: "m4a")
        
        let path = Bundle.main.path(forResource: "textris intro 2", ofType: "m4a")
        
        
        if path != nil{
            let url = URL(fileURLWithPath: path!)
            do{
                try aud = AVAudioPlayer(contentsOf: url)
                aud.numberOfLoops = -1
                aud.play()
            }catch{
                print(error)
            } 
        }
        let path2 = Bundle.main.path(forResource: "textris game music 3", ofType: "m4a")
        if path2 != nil{
            let url = URL(fileURLWithPath: path2!)
            do{
                try aud2 = AVAudioPlayer(contentsOf: url)
                aud2.numberOfLoops = -1
                
            }catch{
                print(error)
            }
        }
        let path3 = Bundle.main.path(forResource: "textris made word", ofType: "m4a")
        if path3 != nil{
            let url = URL(fileURLWithPath: path3!)
            do{
                try aud3 = AVAudioPlayer(contentsOf: url)
                
            }catch{
                print(error)
            }
        }
        let path4 = Bundle.main.path(forResource: "textris end of game", ofType: "m4a")
        if path4 != nil{
            let url = URL(fileURLWithPath: path4!)
            do{
                try aud4 = AVAudioPlayer(contentsOf: url)
                aud4.numberOfLoops = -1
                
            }catch{
                print(error)
            }
        }
        let path5 = Bundle.main.path(forResource: "textris 20 seconds", ofType: "m4a")
        if path5 != nil{
            let url = URL(fileURLWithPath: path5!)
            do{
                try aud5 = AVAudioPlayer(contentsOf: url)
                
            }catch{
                print(error)
            }
        }
    }
    
    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func back(){
        score_view.dismiss(animated: true, completion: nil)
        //self.presentViewController(root, animated: true, completion: nil)
        //self.presentViewController(self, animated: true, completion: nil)
    }
    @objc func about(){
        self.present(score_view, animated: true, completion: nil)
    }
    func getCurHighscore()->Int{
        switch m.minWordLen{
        case 4:
            return UserDefaults().integer(forKey: "HIGHSCORE_MED")
        case 5:
            return UserDefaults().integer(forKey: "HIGHSCORE_HARD")
        default:
            return UserDefaults().integer(forKey: "HIGHSCORE")
        }
    }
    func setScore_lbl(){
        let high = self.getCurHighscore()
        //print(high)
        var temp0 = ""
        switch m.minWordLen{
        case 4:
            temp0 = "MEDIUM"
        case 5:
            temp0 = "HARD"
        default:
            temp0 = "EASY"
        }
        temp0 = "(\(temp0))"
        let temp1 = "\(m.score)"
        let temp2 = "\(high)"//"\(UserDefaults().integer(forKey: "HIGHSCORE"))"
        var temp3 = ""
        if high == m.score{
            temp3 = "NEW "
        }
        let str = "\(temp0)\nSCORE\n\(temp1)\n\(temp3)BEST\n\(temp2)"
        var mutStr = NSMutableAttributedString()
        
        //HOLE STRING BOLD
        //AvenirNext-Heavy
        
        mutStr = NSMutableAttributedString(string: str, attributes: [NSAttributedStringKey.font:UIFont(name: "ChalkboardSE-Bold", size: m.screenSize.height/20)!])
        //MODE FONT
        mutStr.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Avenir-Light", size: m.screenSize.height/40)!, range: NSRange(location:0,length:temp0.count))
        //MODE COLOUR
        mutStr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red:100.0/255,green:100.0/255,blue:100.0/255,alpha: 1.0), range: NSRange(location:0,length:temp0.count))
        //NUMBERS FONT
        mutStr.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Menlo-BoldItalic", size: m.screenSize.height/20)!, range: NSRange(location:7+temp0.count,length:temp1.count))
        mutStr.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Menlo-BoldItalic", size: m.screenSize.height/20)!, range: NSRange(location:13+temp0.count+temp1.count+temp3.count,length:temp2.count))
        //'NEW' FONT
        //mutStr.addAttribute(NSFontAttributeName, value: UIFont(name: "ChalkboardSE-Bold", size: m.screenSize.height/20)!, range: NSRange(location:8+temp0.count+temp1.count,length:temp3.count))
        //'NEW' COLOUR
        //mutStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:255.0/255,green:150.0/255,blue:200.0/255,alpha: 1.0), range: NSRange(location:8+temp0.count+temp1.count,length:temp3.count))
        //'NEW'
        //mutStr.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(value: 1), range: NSRange(location:8+temp0.count+temp1.count,length:temp3.count))
        //NUMBER COLOUR
        mutStr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red:255.0/255,green:180.0/255,blue:60.0/255,alpha: 1.0), range: NSRange(location:7+temp0.count,length:temp1.count))
        mutStr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red:255.0/255,green:180.0/255,blue:60.0/255,alpha: 1.0), range: NSRange(location:13+temp0.count+temp1.count+temp3.count,length:temp2.count))
        
        //mutStr.addAttribute(NSStrokeColorAttributeName, value: UIColor(red:100.0/255,green:100.0/255,blue:100.0/255,alpha: 0.25), range: NSRange(location:0,length:str.count))
        mutStr.addAttribute(NSAttributedStringKey.strokeWidth, value: -4.0, range: NSRange(location:0,length:str.count))
        self.score_lbl.numberOfLines = 5
        self.score_lbl.attributedText = mutStr
        
        //ORANGE UIColor(red:255.0/255,green:120.0/255,blue:100.0/255,alpha: 1.0)
        //RED UIColor(red:220.0/255,green:20.0/255,blue:60.0/255,alpha: 1.0)
    }
    func freshCoord(){
        self.gCenter_btn.center = CGPoint(x : m.screenSize.width/2,  y: m.screenSize.height*15/16)
    }
    func ani_shiftVertical(label:UIView,vert:CGFloat){
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveLinear, animations: { () -> Void in
            label.center.y += vert
            }, completion: nil)
    }
    func ani_shiftHorizontal(label:UIView,hor:CGFloat){
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveLinear, animations: { () -> Void in
            label.center.x += hor
            }, completion: nil)
    }
    func textris(){
        
        
        let name = self.title2
        var count = 0.0
        
        
        var inc = 0.0
        for char in str{
            let tempBlock = ani.newBlock(char: char)
            tempBlock.l.alpha = 1.0
            tempBlock.l.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/30)
            //textris_timer = NSTimer.scheduledTimerWithTimeInterval(count, target:self, selector: #selector(self.animation), userInfo: tempBlock, repeats: false)
            tempBlock.l.center.y = m.screenSize.height*1.5
            UIView.animate(withDuration: 2, delay: inc, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .curveLinear, animations: { () -> Void in
                tempBlock.l.center.y = m.screenSize.height/2
                }, completion: nil)
            let points = m.wordPoints(word: String(tempBlock.letter))
            tempBlock.setColor(points: points)
            let index = name.index (name.startIndex, offsetBy: Int(inc*4))
            tempBlock.l.text = String(name[index])
            count += 0.1
            inc += 0.25
        }
        
        
    }
    func reverseTextris(){
        var time = 0.0
        for x in 0...ani.sizeW-1{
            let block = ani.data[0][x]
            
            if block != nil{
                UIView.animate(withDuration: 1, delay: time, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .curveLinear, animations: { () -> Void in
                    block?.l.center.y += m.screenSize.height
                }, completion: nil)
                time += 0.1
            }
            
        }
    }
    func animation(timer2:Timer){
        if self.isPlay{
            return
        }
        //let char = Character(timer2.userInfo as! String)
        //let tempBlock = ani.newBlock(char)
        let tempBlock = timer2.userInfo as! Block
        self.fadeViewIn(view: tempBlock.l)
        
        //let timer3 = NSTimer.scheduledTimerWithTimeInterval(1.5, target:ani, selector: #selector(ani.shiftDown_timer_stage2), userInfo: tempBlock, repeats: true)
        
    }
    func fadeViewIn(view : UIView) {
        //self.showUI(view)
        let animationDuration = m.dropDelay*3
        view.alpha = 0.0
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseIn, animations: {
            view.alpha = 1.0
            }, completion: {
                finished in
                
                if finished {
                    //Once the label is completely invisible, set the text and fade it back in
                    
                    // Fade in
                    //UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseIn, animations: {
                        //view.alpha = 1.0
                        //}, completion: nil)
                }
        })
    }
    func fadeViewOut(view : UIView) {
        
        let animationDuration = m.dropDelay*3
        view.alpha = 1
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseInOut, animations: { () -> Void in
            view.alpha = 0
            },completion: {finished in
                // the code you put here will be executed when your animation finishes, therefore
                // call your function here
        })
        /*
        NSTimer.scheduledTimerWithTimeInterval(animationDuration,
                                               target: NSBlockOperation(block: {view.removeFromSuperview()}),
                                               selector: #selector(NSOperation.main),
                                               userInfo: nil,
                                               repeats: true)*/
    }
    //GAME CENTER STUFF////////////////////////////////
    func authPlayer(){
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            (view,error) in
            if view != nil{
                self.present(view!, animated: true, completion: nil)
            }
            else{
                //print(GKLocalPlayer.localPlayer().isAuthenticated)
                
            }
        }
    }
    func gSaveScore(number:Int){
        if GKLocalPlayer.localPlayer().isAuthenticated{
            
            var scoreReporter : GKScore
            switch m.minWordLen{
            case 4:
                scoreReporter = GKScore(leaderboardIdentifier: "textris.leaderboard.medium")
            case 5:
                scoreReporter = GKScore(leaderboardIdentifier: "textris.leaderboard.hard")
            default:
                scoreReporter = GKScore(leaderboardIdentifier: "textris.leaderboard.easy")
            }
            
            scoreReporter.value = Int64(number)
            
            let scoreArray:[GKScore] = [scoreReporter]
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
    }
    @objc func gCenter_press(_ sender:UIButton!){
        let VC = self.view.window?.rootViewController
        
        let GCVC = GKGameCenterViewController()
        GCVC.gameCenterDelegate = self
        
        VC?.present(GCVC, animated: true, completion: nil)
    }
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    func getGScore()->GKScore?{
        if (GKLocalPlayer.localPlayer().isAuthenticated){
            var scores1:[GKScore] = []
            GKLeaderboard.loadLeaderboards(completionHandler: {objects, error in
                if let e:Error = Error.self as? Error{
                    //print(e)
                }
                else{
                    let leaderboards = objects! as [GKLeaderboard]
                    
                    for leaderboard in leaderboards{
                        leaderboard.loadScores() { scores, error in
                            if error == nil {
                                scores1.append(leaderboard.localPlayerScore!)
                            }
                        }
                    }
                    
                }
            })
            
            let index = m.minWordLen - 3
            if scores1.count > index{
                return scores1[index]
            }
            
        }
        return nil
    }
    func resetLeaderboard(){
        for i in 3...3{
            m.minWordLen = i
            self.gSaveScore(number: 0)
        }
    }
    //////////////////////////////////////////////////
    func finish(){
        self.isPlay = false
        m.logic_timer?.invalidate()
        timer.invalidate()
        if m.score > self.getCurHighscore(){//UserDefaults().integer(forKey: "HIGHSCORE"){
            self.saveHighScore()
        }
    }
    func scale(view:UIView,val:CGFloat){
        UIView.animate(withDuration: m.dropDelay, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveLinear, animations: { () -> Void in
            view.transform = CGAffineTransform(scaleX: val, y: val)
            
        }, completion: nil)
    }
    func resetScale(view:UIView){
        UIView.animate(withDuration: m.dropDelay, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveLinear, animations: { () -> Void in
            view.transform = .identity
            
        }, completion: nil)
    }
    @objc func button_press(_ sender:UIButton!){
        switch sender.titleLabel!.text! as String{
            case "PLAY","EASY","MEDIUM","HARD": //HOME PAGE
                if sender.titleLabel!.text! as String == "MEDIUM"{
                    m.minWordLen = 4
                }
                else if sender.titleLabel!.text! as String == "HARD"{
                    m.minWordLen = 5
                }
                else{
                    m.minWordLen = 3
                }
                self.time_lbl.transform = .identity
                self.isPlay = true
                self.title_btn.setTitle("HOME", for: .normal)
                //m.flipLabels()
                m.clearScore()
                root.reverseTextris()
                ani.clearBlocks()
                self.textris_timer?.invalidate()
                self.time_timer?.invalidate()
                self.time_lbl.textColor = UIColor.black
                //self.addBlock()
                
                //ani = Matrix()
                m.main()
                /*
                addBlock()
                updateCounter()
                */
                ani_shiftVertical(label: self.gCenter_btn,vert: +m.screenSize.height/8)
                ani_shiftVertical(label: self.about_btn,vert: +m.screenSize.height/4)
                ani_shiftVertical(label: self.play_lbl,vert: +m.screenSize.height)
                ani_shiftVertical(label: self.title_btn,vert: -m.screenSize.height/16*2)
                ani_shiftVertical(label: self.med_btn,vert: -m.screenSize.height/16*3)
                ani_shiftVertical(label: self.hard_btn,vert: -m.screenSize.height/16*4)
                fadeViewOut(view: self.med_btn)
                fadeViewOut(view: self.hard_btn)
                fadeViewIn(view: m.scoreShelf)
                fadeViewIn(view: m.wordShelf)
                fadeViewIn(view: self.time_lbl)
                
                let time = m.time
                self.time_lbl.text = String(format: "%02d:%02d", Int(time/60),(time-Int(time/60)*60))
                self.time_lbl.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/30)
                self.time_timer = Timer.scheduledTimer(timeInterval: 0, target:self, selector: #selector(self.game_time), userInfo: time, repeats: false)
            
                root.aud.stop()
                root.aud2.currentTime = 0
                root.aud2.play()
 
            case "HOME":  //GAME PAGE
                root.aud2.stop()
                root.aud4.stop()
                root.aud.currentTime = 0
                root.aud.play()
                m.clearBlocks()
                //m.flipLabels()
                
                self.title_btn.setTitle("EASY", for: .normal)
                textris()
                m.logic_timer?.invalidate()
                
                ani_shiftVertical(label: self.gCenter_btn,vert: -m.screenSize.height/8)
                ani_shiftVertical(label: self.about_btn,vert: -m.screenSize.height/4)
                ani_shiftVertical(label: self.play_lbl,vert: -m.screenSize.height)
                
                fadeViewOut(view: m.scoreShelf)
                fadeViewOut(view: m.wordShelf)
                fadeViewOut(view: self.time_lbl)
                
                ani_shiftVertical(label: self.title_btn,vert: +m.screenSize.height/16*2)
                ani_shiftVertical(label: self.med_btn,vert: +m.screenSize.height/16*3)
                ani_shiftVertical(label: self.hard_btn,vert: +m.screenSize.height/16*4)
                fadeViewIn(view: self.med_btn)
                fadeViewIn(view: self.hard_btn)
                
                if self.score_lbl.center.y < m.screenSize.height{//self.score_lbl.alpha == 1{
                    self.ani_shiftVertical(label: self.score_lbl, vert: m.screenSize.height)
                    self.scale(view: self.score_lbl, val: 1/4.0)
                    self.ani_shiftVertical(label: self.again_btn, vert: m.screenSize.height/2)
                }
                else{
                    self.finish()
                    self.resetScale(view: self.time_lbl)
                }
            case "PLAY AGAIN":
                self.ani_shiftVertical(label: self.score_lbl, vert: m.screenSize.height)
                self.scale(view: self.score_lbl, val: 1/4.0)
                self.ani_shiftVertical(label: self.again_btn, vert: m.screenSize.height/2)
                root.aud2.currentTime = 0
                root.aud2.play()
                root.aud4.stop()
                m.clearBlocks()
                m.clearScore()
                m.logic_timer?.invalidate()
                self.time_lbl.textColor = UIColor.black
                self.resetScale(view: self.time_lbl)
            
                let temp_timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(self.play_again_timer), userInfo: nil, repeats: false)
            default:
                print("NO SUCH COMMAND!")
        }
    }
    @objc func play_again_timer(timer:Timer){
        let time = m.time
        self.time_lbl.text = String(format: "%02d:%02d", Int(time/60),(time-Int(time/60)*60))
        self.time_lbl.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/30)
        self.time_timer = Timer.scheduledTimer(timeInterval: 0, target:self, selector: #selector(self.game_time), userInfo: time, repeats: false)
        self.isPlay = true
        m.main()
    }
    @objc func game_time(timer:Timer){
        let time = self.time_timer!.userInfo as! Int
        self.time_lbl.text = String(format: "%02d:%02d", Int(time/60),(time-Int(time/60)*60))       
        
        
        if time <= 20{
            if time == 20{
                aud5.currentTime = 0
                aud5.play()
            }
            
            
            UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseIn, animations: {
                self.time_lbl.textColor = UIColor(red:255.0/255,green:180.0/255,blue:60.0/255,alpha: 1.0)//UIColor(red:220.0/255,green:20.0/255,blue:60.0/255,alpha: 1.0)
                //self.time_lbl.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/20)
                self.time_lbl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }, completion: { finished in
                    if finished {
                        //Once the label is completely invisible, set the text and fade it back in
                        
                        // Fade in
                        //UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseIn, animations: {
                        //view.alpha = 1.0
                        //}, completion: nil)
                    }
            })
            
            
            
            }
        if time == 0{
            gameEnd()
            
            
        }
        else if self.isPlay{
            self.time_timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(self.game_time), userInfo: time-1, repeats: false)
        }
    }
    func gameEnd(){
        self.timer.invalidate()
        aud2.stop()
        aud4.currentTime = 0
        aud4.play()
        root.finish()
        self.isPlay = false
        if m.score > self.getCurHighscore(){
            self.saveHighScore()
        }
        root.setScore_lbl()
        self.ani_shiftVertical(label: self.score_lbl, vert: -m.screenSize.height)
        self.scale(view: self.score_lbl, val: 1.0)
        self.ani_shiftVertical(label: self.again_btn, vert: -m.screenSize.height/2)
    }
    
    func saveHighScore(){
        switch m.minWordLen{
        case 4:
            UserDefaults.standard.set(m.score, forKey: "HIGHSCORE_MED")
        case 5:
            UserDefaults.standard.set(m.score, forKey: "HIGHSCORE_HARD")
        default:
            UserDefaults.standard.set(m.score, forKey: "HIGHSCORE")
        }
        
        root.score_lbl.text = "HIGHSCORE = \(self.getCurHighscore())"
        self.gSaveScore(number: m.score)
    }
    func showUI(label:UIView){
        self.view.addSubview(label)
    }
    func hideUI(label:UIView){
        label.removeFromSuperview()
    }
    func addBlock()->Bool{
        if m.avail_blocks.count == 0{
            return false
        }
        
        someBlock = m.avail_blocks[0]//Block(letter0:"B")
        m.avail_blocks.removeFirst()
        //someBlock!.setLetter()
        m.setLetter(b: someBlock!)
        someBlock!.defaultLetter()
        let able = m.insert(letter: someBlock!)
        if !able{
            return able
        }
        //self.view.addSubview(someBlock.l)
        someBlock?.l.center.y = CGFloat(-1*(someBlock?.width)!/2)
        someBlock?.l.center.x = 0//m.screenSize.width/2
        someBlock?.l.alpha = 1.0
        m.updateBlockLoc_gui(someBlock: someBlock!)
        
        let points = m.wordPoints(word: String(someBlock!.letter))
        someBlock!.setColor(points: points)
        someBlock!.l.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/30)
        //root.view.addSubview(someBlock.l)
        //self.fadeViewIn(view: someBlock!.l)
        
        
        
        //print(someBlock.letter)
        return able
    }
    func updateCounter() {
        
        timer = Timer.scheduledTimer(timeInterval: m.dropDelay, target:m, selector: #selector(m.shiftDown_timer), userInfo: someBlock, repeats: true)
        
        //print(someBlock.letter)
        
        //m.completeShift(someBlock)
        
        //let data_removal = m.computeBoard()
        
        
        //m.compute_shiftboardShift()
    
        //m.cout()
        
    }
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if someBlock == nil || m.swipeDown == 1{return}
        
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: self.view)
            
            if gestureRecognizer.state == .began{
                m.panCurrent = someBlock!.x
            }
            let xChangeFromOriginal = Int((translation.x/CGFloat(m.incrementX)))//CGFloat(m.incrementX))
 
            let curX = Int((Double(someBlock!.l.center.x)/m.incrementX))//m.panCurrent
            var newX = m.panCurrent + xChangeFromOriginal
            
            if newX < 0{
                newX = 0
            }
            else if newX >= m.sizeW{
                newX = m.sizeW - 1
            }
            
            var diff = 0
            if newX < curX{
                diff = -1
            }
            if newX > curX{
                diff = +1
            }
            //someBlock!.l.center.x = CGFloat(Double(newX)*m.incrementX + m.incrementX/2)
            if newX - curX > 1{
            }
            if diff != 0{
                //print(diff,newX,xChangeFromOriginal,translation)
                
                let swiped = m.shiftLR(letter: someBlock!, direction: diff)
                if swiped{
                    UIView.animate(withDuration: m.dropDelay, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveLinear, animations: { () -> Void in
                        self.someBlock!.l.center.x = self.someBlock!.l.center.x + CGFloat(Double(diff)*m.incrementX)//CGFloat(Double(newX)*m.incrementX + m.incrementX/2)
                        
                    }, completion: nil)
                    
                    
                }
 
                
            }
            else if diff == 0 && round(Double(translation.y)/m.incrementY) > 1{
                m.swipeDown = 1
            }
            
 
            
            
        }
            /*
            if someBlock != nil{
                let incX = round(translation.x/CGFloat(m.incrementX))*CGFloat(m.incrementX)
                var diff = 0
                if incX > 0{
                    diff = 1
                }
                else if incX < 0{
                    diff = -1
                }
                if diff != 0{
                    let swiped = m.shiftLR(letter: someBlock!,direction: diff)
                
                    if swiped{
                        UIView.animate(withDuration: m.dropDelay*4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: .curveLinear, animations: { () -> Void in
                            self.someBlock?.l.center.x = (self.someBlock?.l.center.x)! + incX - CGFloat(m.panCurrent)
                            m.panCurrent = Double(incX)
                            
                        }, completion: nil)
                    }
                }
            }
            
            let incX = Double(translation.x)
            let incY = Double(translation.y)
            if incX == 0{
                m.panCurrent = 0
            }
            var diff = 0
            
            var transX = Int(incX/m.incrementX)
            
            //print(transX, m.panCurrent)
            //print(transX - m.panCurrent)
            diff = transX - m.panCurrent
            m.panCurrent = transX
            print(diff)
            if diff != 0 && someBlock != nil{
                let swiped = m.shiftLR(letter: someBlock!,direction: diff)
                //m.updateBlockLoc_gui(someBlock)
                if swiped{
                    root.ani_shiftHorizontal(label: someBlock!.l, hor:  CGFloat(Int(m.incrementX)*diff))
                }
            }
            
            if transX == 0 && abs(Int(incY/m.incrementY)) > 0{
                m.swipeDown = 1
            }
            */
    }

    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        //print("we dit it agin")
        if someBlock == nil{
            return
        }
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                //print("Swiped right")
                let swiped = m.shiftLR(letter: someBlock!,direction: +1)
                //m.updateBlockLoc_gui(someBlock)
                if swiped{
                    root.ani_shiftHorizontal(label: someBlock!.l, hor:  CGFloat(Int(m.screenSize.width)/m.sizeW))
                }
            case UISwipeGestureRecognizerDirection.left:
                //print("Swiped left")
                let swiped = m.shiftLR(letter: someBlock!,direction: -1)
                //m.updateBlockLoc_gui(someBlock)
                if swiped{
                    root.ani_shiftHorizontal(label: someBlock!.l, hor:  -CGFloat(Int(m.screenSize.width)/m.sizeW))
                }
            case UISwipeGestureRecognizerDirection.down:
                m.swipeDown = 1
            default:
                break
            }
        }
    }


}

class Block{
    var letter: Character
    var x:Int
    var y:Int
    var l:UILabel
    var width:Int
    var height :Int
    var shiftX:Int
    var shiftY:Int
    
    
    init(letter0: Character){
        self.letter = letter0
        self.x = 0
        self.y = 0
        self.width = Int(UIScreen.main.bounds.height/17)//Int(m.screenSize.height/20)
        self.height = self.width//Int(m.screenSize.height/20)
        self.shiftX = 50
        self.shiftY = 50
        self.l = UILabel(frame: CGRect(x: self.x, y: self.y, width: self.width, height: self.height))
        self.l.center = CGPoint(x : self.x,y : self.y)
        self.l.textAlignment = NSTextAlignment.center
        self.l.layer.borderWidth = 2
        self.l.text = String(self.letter).uppercased()
        self.l.textColor = UIColor.white
        
        self.l.layer.cornerRadius = 0.33 * self.l.bounds.size.width
        self.l.textAlignment = .center
        
        
    }
    func setLetter()->Int{
        //SET THE PROBABILITIES
        let beta_points:[Double] = [0.09,0.02,0.02,0.04,0.12,0.02,0.03,0.02,0.09,0.01,0.01,0.04,0.02,0.06,0.08,0.02,0.01,0.06,0.04,0.06,0.04,0.02,0.02,0.02,0.02,0.01]
            
            /*[0.0813,0.0149,0.0271,0.0432,
                                    0.1202,0.023,0.0203,0.0592,
                                    0.0731,0.001,0.0069,0.0398,
                                    0.0261,0.0695,0.0768,0.0182,
                                    0.0011,0.0602,0.0628,0.091,
                                    0.0288,0.0111,0.0209,0.0017,
                                    0.0211,0.0007]*/
        let sum = beta_points.reduce(0, +)
        let rnd = sum * Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)
        
        var accum = 0.0
        for (i, p) in beta_points.enumerated(){
            accum += p
            if rnd < accum {
                self.letter = self.letterFromNum(by: i)
                self.l.text = String(self.letter).uppercased()
                return 1
            }
        }
        
        return 0
    }
    func setColor(points:Int)->[CGFloat]{
        var r:Double = 0.0
        var g:Double = 0.0
        var b:Double = 0.0
        switch points{
        
        case 2:
            
            r = 20
            g = 200
            b = 20
            /*
            r = 255
            g = 120
            b = 100*/
            
        case 3:
            
            r = 20
            g = 190
            b = 160
            
        case 4:
            
            r = 50
            g = 150
            b = 220
            /*
            r = 90
            g = 215
            b = 140*/
            
        case 5:
            
            r = 255
            g = 150
            b = 200
        case 8:
            
            r = 175
            g = 120
            b = 200
            /*
             r = 220
             g = 20
             b = 60*/
            
        case 10:
            
            r = 255
            g = 120
            b = 65
            
        default:
            r = 255
            g = 180
            b = 80
            /*
            r = 100
            g = 100
            b = 100*/
        }
        self.l.layer.backgroundColor = UIColor(red:CGFloat(r)/255,green:CGFloat(g)/255,blue:CGFloat(b)/255,alpha: 1.0).cgColor
        self.l.layer.borderColor = UIColor(red:CGFloat(r)/255,green:CGFloat(g)/255,blue:CGFloat(b)/255,alpha: 1.0).cgColor
        //self.l.shadowColor = UIColor.blackColor()//UIColor(red:CGFloat(r)/255,green:CGFloat(g)/255,blue:CGFloat(b)/255,alpha: 1.0)
        
        return [CGFloat(r),CGFloat(g),CGFloat(b)]
        
    }
    func letterFromNum(by num:Int)->Character{
        //THIS FUNCTION INPUTS AN INDEX AND RETURNS A CHARACTER
        let string:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let stringList = Array(string)
        //let stringList = string.components(separatedBy: "")//[Character](string.characters)
        return stringList[num]
        
    }
    func defaultLetter(){
        self.l.frame = CGRect(x: Double(self.l.center.x), y: Double(self.l.center.y), width: Double(self.width), height: Double(self.height))
        self.x = 0
        self.y = 0
    }
    
}

class Matrix{
    let screenSize: CGRect = UIScreen.main.bounds
    var sizeL:Int = 7
    var sizeW:Int = 5
    var incrementY:Double
    var incrementX: Double
    
    var panCurrent:Int = 0
    
    var data:[[Block?]] = []
    var minWordLen:Int
    var size:Int
    var capacity:Int
    var basis:Block
    var nextStage:Int = 0
    
    var scoreShelf:UILabel
    var wordShelf:UILabel
    
    
    var time:Int = 120
    var score:Int
    
    var swipeDown = 0
    var dropDelay:Double = 0.375//0.2//0.375
    
    var avail_blocks:[Block] = []
    
    var logic_timer:Timer? = nil
    
    var betaPoints = ["a":1, "b":3, "c":3, "d":2, "e":1, "f":4, "g":2, "h":4, "i":1,"j":8,"k":5, "l":1,"m":3, "n":1, "o":1, "p":3, "q":10, "r":1, "s":1,"t":1, "u":1, "v":4, "w":4, "x":8, "y":4, "z":10]
    
    init(){
        //self.sizeL = 7
        
        //self.sizeW = 7
        incrementY = Double(screenSize.height)*2.0/3.0/Double(sizeL)
        incrementX = Double(screenSize.width)/Double(self.sizeW)
        
        self.basis = Block(letter0:"7")
        self.data = [[Block?]](repeating: [Block?](repeating: nil, count: self.sizeW), count: self.sizeL)//self.basis))
        self.minWordLen = 3
        self.size = 0
        self.capacity = self.sizeL*self.sizeW
        
        self.score = 0
        
        self.wordShelf = UILabel(frame: CGRect(x: 0, y: 0, width: self.screenSize.width/3*2-self.screenSize.height/80, height: self.screenSize.height/20))
        self.wordShelf.center = CGPoint(x : screenSize.width/3,  y: screenSize.height/8)
        self.wordShelf.text = ""
        root.view.addSubview(self.wordShelf)
        
        self.scoreShelf = UILabel(frame: CGRect(x: 0, y: 0, width: self.screenSize.width/3-screenSize.height/80, height: self.screenSize.height/20))
        self.scoreShelf.center = CGPoint(x : screenSize.width*5/6,  y: screenSize.height/8)
        self.scoreShelf.text = "\(self.score)"
        root.view.addSubview(self.scoreShelf)
        
        self.label_format(label: self.scoreShelf)
        self.label_format(label: self.wordShelf)
        
        self.flipLabels()
        //self.set_avail_blocks()
    }
    func coordForCoord(x: Int,y:Int)->[CGFloat]{
        let incX = self.screenSize.width/CGFloat(self.sizeW)
        return [incX*CGFloat(x)+incX/2,CGFloat(incrementY)*CGFloat(y)+CGFloat(incrementY)/2+self.screenSize.height/3.0]
    }
    func makeGrid(){
        for x in 0...self.sizeW-1{
            for y in 0...self.sizeL-1{
                let b = Block(letter0: "A")
                b.l.text = ""
                b.x = x
                b.y = y
                let coords = self.coordForCoord(x: x, y: y)
                b.l.center.x = coords[0]
                b.l.center.y = coords[1]
                b.l.layer.backgroundColor = UIColor(red:100.0/255,green:100.0/255,blue:100.0/255,alpha: 0.25).cgColor
                b.l.layer.borderColor = UIColor(red:100.0/255,green:100.0/255,blue:100.0/255,alpha: 0.25).cgColor
                root.view.addSubview(b.l)
                
            }
        }
    }
    func set_avail_blocks(){
        let count = self.sizeL*self.sizeW
        
        if count < 1{
            return
        }
        
        for val in 0...count-1{
            let b = Block(letter0: "A")
            root.view.addSubview(b.l)
            b.l.alpha = 0
            
            
            self.avail_blocks.append(b)
            
            
            
        }
    }
    func newBlock(char:Character)->Block{
        
        let tempBlock = self.avail_blocks[0]//Block(letter0:char)
        self.avail_blocks.removeFirst()
        tempBlock.letter = char
        tempBlock.l.text = String(char)
        self.insert_original(letter: tempBlock)
        //root.showUI(tempBlock.l)
        self.updateBlockLoc_gui(someBlock: tempBlock)
        return tempBlock
    }
    func changeSize(len:Int,wid:Int){
        self.sizeL = len
        self.sizeW = wid
        self.capacity = self.sizeL*self.sizeW
        self.data = [[Block?]](repeating: [Block?](repeating: nil, count: self.sizeW), count: self.sizeL)//self.basis))
        
        self.reset_avail_blocks()
        
    }
    func reset_avail_blocks(){
        let count = self.avail_blocks.count
        let target = self.sizeL*self.sizeW
        if count - target == 0{
            return
        }
        for a in 1...abs(count-target){
            if count>target{
                self.avail_blocks.removeFirst()
            }
            else{
                let b = Block(letter0: "A")
                root.view.addSubview(b.l)
                b.l.alpha = 0
                self.avail_blocks.append(b)
            }
        }
        
    }
    func clearBlocks(){
        //CLEAR BLOCKS
        for row in 0...self.sizeL-1{
            for col in 0...self.sizeW-1{
                if self.data[row][col] != nil{//self.data[row][col].letter != self.basis.letter{
                    //root.fadeViewOut(self.data[row][col]!.l)
                    self.remove(letter: self.data[row][col]!)
                }
            }
        }
        self.removeAlpha()
    }
    func removeAlpha(){
        for a in self.avail_blocks{
            if a.l.alpha == 1{
                root.fadeViewOut(view: a.l)
            }
        }
    }
    @objc func addString(timer:Timer){//s:String, shiftDown:Bool){
        let p = timer.userInfo! as! NSDictionary
        let s = p["A"] as! String
        let shiftDown = p["B"] as! Bool
        
        var count:Double = 0.0
        for char in s{
            let tempBlock = self.newBlock(char: char)
            tempBlock.l.alpha = 0
            tempBlock.l.font = UIFont(name: "Avenir-Black", size: m.screenSize.height/30)
            root.textris_timer = Timer.scheduledTimer(timeInterval: count, target:self, selector: #selector(self.addString_animation), userInfo: ["A":tempBlock,"B":shiftDown], repeats: false)
            
            let points = m.wordPoints(word: String(tempBlock.letter))
            tempBlock.setColor(points: points)
            count += 0.1
        }
        
    }
    @objc func addString_animation(timer2:Timer){
        if root.isPlay{
            return
        }
        //let char = Character(timer2.userInfo as! String)
        //let tempBlock = ani.newBlock(char)
        let p = timer2.userInfo! as! NSDictionary
        let tempBlock = p["A"] as! Block
        let shift = p["B"] as! Bool
        root.fadeViewIn(view: tempBlock.l)
        
        if shift{
            let timer3 = Timer.scheduledTimer(timeInterval: 1.5, target:ani, selector: #selector(ani.shiftDown_timer_stage2), userInfo: tempBlock, repeats: true)
        }
        
        
    }
    func setLetter(b:Block)->Int{
        var beta_points:[Double] = [9,2,2,4,12,2,3,2,9,1,1,4,2,6,8,2,1,6,4,6,4,2,2,1,2,1]
        var sum = beta_points.reduce(0, +)
        
        let alpha = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        
        for i in 0...26-1{
            let num = self.getNumOfLettersFromLetter(letter: alpha[i])
            beta_points[i] -= num
            sum -= num
        }
        beta_points.enumerated().forEach({index, value in beta_points[index] = value/sum })
        sum = beta_points.reduce(0, +)
        let rnd = sum * Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)
        var accum = 0.0
        for (i, p) in beta_points.enumerated(){
            accum += p
            if rnd < accum {
                
                b.letter = b.letterFromNum(by: i)
                b.l.text = String(b.letter).uppercased()
                return 1
            }
        }
        
        return 0
    }
    func getNumOfLettersFromLetter(letter:Character)->Double{
        var num:Double = 0
        for x in 0...self.sizeW-1{
            for y in 0...self.sizeL-1{
                let block = self.data[y][x]
                if block != nil{
                    if block!.letter == letter{
                        num += 1
                    }
                }
            }
        }
        return num
    }
    //THE LOGIC///////////////////////////////////
    func main(){
        
        if !root.isPlay{
            return
        }
        self.swipeDown = 0
        let able = root.addBlock()
        
        if !able{
            //self.cout()
            root.gameEnd()
            return
        }
        m.panCurrent = ((root.someBlock?.x)!)
        self.logic_timer = Timer.scheduledTimer(timeInterval: self.dropDelay*4, target:self, selector: #selector(self.shiftDownBlock), userInfo: root.someBlock, repeats: false)
    }
    @objc func shiftDownBlock(timer:Timer){
        let someBlock = timer.userInfo as! Block
        let done = self.shiftDown(letter: someBlock)

        if done{
            if self.swipeDown == 1{
                self.shiftToBottom(someBlock: someBlock)
                root.someBlock = nil
                self.swipeDown = 0
                self.logic_timer = Timer.scheduledTimer(timeInterval: self.dropDelay, target:self, selector: #selector(self.beforeAnalyze), userInfo: nil, repeats: false)
                //self.analyzeBoard()
            }
            else{
                root.ani_shiftVertical(label: someBlock.l, vert: CGFloat(incrementY))
                self.logic_timer = Timer.scheduledTimer(timeInterval: m.dropDelay, target:self, selector: #selector(self.shiftDownBlock), userInfo: someBlock, repeats: false)
            }
        }
        else{
            self.analyzeBoard()
        }
    }
    func analyzeBoard(){
        let words = self.computeBoard()
        if words == [[]]{
            //self.logic_timer = NSTimer.scheduledTimerWithTimeInterval(self.dropDelay, target:self, selector: #selector(self.beforeMain), userInfo: nil, repeats: false)
            root.someBlock = nil
            main()
        }
        else{
            root.aud3.currentTime = 0
            root.aud3.play()
            self.removeBlocks(data_remove: words)
            self.shiftDownBlocks()
        }
    }
    func shiftDownBlocks(){
        
        //self.nextStage = 0
        var keyBlock = self.basis
        for row in (0...self.sizeL-1).reversed(){
            for col in (0...self.sizeW-1).reversed(){
                let ob = self.data[row][col]
                if ob != nil{//ob.letter != self.basis.letter && self.canShiftDown(ob){
                    if self.canShiftDown(someBlock: ob!){
                        keyBlock = ob!
                    }
                    
                }
            }
        }
        
        var shifted = 0
        for row in (0...self.sizeL-1).reversed(){
            for col in (0...self.sizeW-1).reversed(){
                let ob = self.data[row][col]
                if ob != nil{//self.basis.letter{
                    self.logic_timer = Timer.scheduledTimer(timeInterval: self.dropDelay, target:self, selector: #selector(self.shiftBlock_series), userInfo: ["a":ob!,"b":ob! === keyBlock], repeats: false)
                    shifted += 1
                }
            }
        }
        if shifted == 0 || keyBlock.letter == self.basis.letter{
            analyzeBoard()
            //self.logic_timer = NSTimer.scheduledTimerWithTimeInterval(self.dropDelay*5, target:self, selector: #selector(self.beforeMain), userInfo: nil, repeats: false)
            //root.someBlock = nil
            //main()
        }
        
    }
    @objc func shiftBlock_series(timer:Timer){
        let p = timer.userInfo! as! NSDictionary
        let someBlock = p["a"] as! Block
        let eq = p["b"] as! Bool
        let done = self.shiftDown(letter: someBlock)
        if done{
            root.ani_shiftVertical(label: someBlock.l, vert: CGFloat(Int(self.incrementY)))
            self.logic_timer = Timer.scheduledTimer(timeInterval: self.dropDelay, target:self, selector: #selector(self.shiftBlock_series), userInfo: ["a":someBlock,"b":eq], repeats: false)
        }
        else{
            if eq{//self.nextStage == 0{
                //self.nextStage = 1
                self.analyzeBoard()
            }
        }
    }
    @objc func beforeMain(){
        main()
    }
    @objc func beforeAnalyze(){
        self.analyzeBoard()
    }
    func shiftToBottom(someBlock:Block){
        var count:Double = 1
        while self.shiftDown(letter: someBlock){
            count += 1
        }
        let incrementY:Double = self.incrementY//Double(self.screenSize.height)*2.0/3.0/Double(self.sizeL)
        root.ani_shiftVertical(label: someBlock.l, vert: CGFloat(count*incrementY))
    }
    /////////////////////////////////////
    func canShiftDown(someBlock:Block)->Bool{
        let col = someBlock.x
        
        if someBlock.y > self.sizeL-1{
            return false
        }
        
        for row in someBlock.y...self.sizeL-1{
            let tempBlock = self.data[row][col]
            if tempBlock == nil{//self.basis.letter{
                return true
            }
        }
        return false
    }
    func clearScore(){
        //CLEAR SCORE AND CLEAR LABELS
        self.score = 0
        self.scoreShelf.text = "\(self.score)"
        self.wordShelf.text = ""
    }
    func flipLabels(){
        //CLEAR GENERAL LABELS
        //self.wordShelf.hidden = !self.wordShelf.hidden
        //self.scoreShelf.hidden = !self.scoreShelf.hidden
        self.wordShelf.alpha = 0
        self.scoreShelf.alpha = 0
        
        
    }
    func label_format(label:UILabel){
        label.textAlignment = .center
        label.layer.backgroundColor = UIColor(red:50.0/255,green:150.0/255,blue:255.0/255,alpha: 0.25).cgColor
        label.layer.cornerRadius = label.frame.height/3
        label.textColor = UIColor(red:50.0/255,green:150.0/255,blue:255.0/255,alpha: 1.0)//UIColor.whiteColor()
        label.font = UIFont(name: "Avenir-Medium", size: self.screenSize.height/30)
        label.layer.zPosition = 1
        
        
        
    }
    func updateBlockLoc_gui(someBlock:Block)->Bool{
        let incX = Double(screenSize.width)/Double(self.sizeW)
        let x = Double(someBlock.x)*incX+incX/2
        let y = Double(someBlock.y)*incrementY+incrementY/2+Double(self.screenSize.height)/3
        
        /*
        someBlock.l.center = CGPoint(x: x, y: y)
        
        let screenWidth:Double = Double(screenSize.width)
        let incrementX:Double = (screenWidth)/Double(self.sizeW)
        let posX:Double = Double(someBlock.x)*incrementX+incrementX/2
        let screenHeight:Double = Double(screenSize.height)
        let posY:Double = someBlock.y*incrementY+incrementY/2.0+screenHeight/3.0
        //someBlock.l.center = CGPoint(x : posX,  y: posY)
        */
        UIView.animate(withDuration: m.dropDelay*4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: .curveLinear, animations: { () -> Void in
            someBlock.l.center = CGPoint(x : x,  y: y)
            
        }, completion: nil)
 
        return true
    }
    
    func cout()->Bool{
        for row in 0...self.sizeL-1{
            for col in 0...self.sizeW-1{
                let ob = self.data[row][col]
                if ob == nil{//self.basis.letter{
                    //print(ob.x,ob.y,terminator:" ,")
                    print("_",terminator:" ,")
                }
                else{
                    print(ob!.letter,terminator:" ,")
                    //print(ob.x,ob.y,terminator: " ,")
                    //ob.l.text = String(ob.letter).uppercaseString
                    
                    //ob.l.center = CGPoint(x : col*ob.shiftX + 50,y : row*ob.shiftY+100)
                }
            }
            print()
        }
        print()
        return true
    }
    func validIdx(index1:Int,index2:Int)->Bool{
        if index1 < self.sizeW && index1 >= 0 && index2 < self.sizeL && index2 >= 0{
            return true
        }
        return false
    }
    
    func findValue(index1:Int,index2:Int)->Block{
        if self.validIdx(index1: index1, index2: index2){
            return self.data[index2][index1]!
        }
        return self.basis
    }
    func shiftLR(letter:Block,direction:Int)->Bool{
        if !self.validIdx(index1: letter.x+direction, index2: letter.y){
            return false
        }
        if self.data[letter.y][letter.x+direction] == nil{//self.basis.letter{
            self.data[letter.y][letter.x+direction] = self.data[letter.y][letter.x]
            self.data[letter.y][letter.x] = nil//self.basis
            letter.x += direction
            return true
        }
        return false
    }
    
    func shiftDown(letter:Block)->Bool
    {
        
        if !self.validIdx(index1: letter.x, index2: letter.y+1){
            return false
        }
        if self.data[letter.y+1][letter.x] == nil{//self.basis.letter{
            
            self.data[letter.y+1][letter.x] = self.data[letter.y][letter.x]
            self.data[letter.y][letter.x] = nil//self.basis
            letter.y += 1
            
            //self.cout()
            return true
            
        }
        return false
    }
    func insert(letter:Block)->Bool{
        
        var multiple = -1
        var increment = 0
        let row = 0
        let col = Int(round(Double(self.sizeW)/2.0)-1)
        var c = col + increment*multiple
        while self.validIdx(index1: c, index2: row){
            let b = data[row][c]
                
            if b == nil{//self.basis.letter{
                self.data[row][c] = letter
                letter.x = c
                self.size += 1
                return true
            }
            if multiple == -1{
                increment += 1
            }
            multiple = multiple * -1
            c = col + increment*multiple
        }
        return false
    }
    func insert_original(letter:Block)->Bool{
        //DIFFERENT ANIMATION
        
        for a in 0...self.sizeW-1{
            if self.data[0][a] == nil{//self.basis.letter{
                self.data[0][a] = letter
                letter.x = a
                self.size += 1
                return true
            }
        }
        return false
        
    }
    func remove(letter:Block)->Bool{
        self.size -= 1
        self.data[letter.y][letter.x] = nil//self.basis
        //letter.l.hidden = !letter.l.hidden
        root.fadeViewOut(view: letter.l)
        self.avail_blocks.append(letter)
        
        //letter.l.removeFromSuperview()
        //root.view.removeSubview(letter.l)
        return true
    }
    func completeShift(letter:Block)->Bool{
        //print(letter.letter)
        //let timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target:self, selector: #selector(self.shiftDown_timer), userInfo: letter, repeats: true)
        
        
        
        while self.shiftDown(letter: letter){
            self.updateBlockLoc_gui(someBlock: letter)
        }
        return true
    }
    @objc func shiftDown_timer(timer:Timer)
    {
        /*
        let letter = timer.userInfo as! Block
        let done = self.shiftDown(letter: letter)
        //self.updateBlockLoc_gui(letter)
        
        
        
        if !done && root.isPlay{
            
            timer.invalidate()
            let str = String(letter.letter)
            
            if self.size != (m.sizeL*m.sizeW){
                
                var data_removal = self.computeBoard()
                
                
                if data_removal != [[]] {//&& self.cout(){
                    //self.cout()
                    let time = dispatch_time(dispatch_time_t(DispatchTime.now()), 0 * Int64(NSEC_PER_SEC))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        //put your code which should be executed with a delay here
                        self.removeBlocks(data_removal)
                        self.shiftBlock_stage2()
                        data_removal = self.computeBoard()
                    }
                    
                    
                }
                root.addBlock()
                root.updateCounter()
                /*
                else{
                    root.addBlock()
                    root.updateCounter()
                }*/
                
                
            }
            
        }
        else{
            root.ani_shiftVertical(label: letter.l, vert: CGFloat(Int(m.screenSize.height*2/3)/self.sizeL))
        }*/
    }
    func shiftBlock_stage2(){
        self.nextStage = 1
        var someBlock:Block
        
        var shifted:Int = 0
        for row in (0...self.sizeL-1).reversed(){
            for col in (0...self.sizeW-1).reversed(){
                if self.data[row][col] != nil{//self.basis.letter{
                    someBlock = self.data[row][col]!
                    let timer = Timer.scheduledTimer(timeInterval: m.dropDelay, target:self, selector: #selector(self.shiftDown_timer_stage2), userInfo: someBlock, repeats: true)
                    shifted += 1
                }
                
            }
        }
        /*
        if shifted == 0{
            self.nextStage = 0
            root.addBlock()
            root.updateCounter()
        }
         */
    }
    @objc func shiftDown_timer_stage2(timer:Timer)
    {
        let letter = timer.userInfo as! Block
        let done = self.shiftDown(letter: letter)
        //self.updateBlockLoc_gui(letter)
        if !done{
            timer.invalidate()
            
            
            
            if self.nextStage == 1{
                //print("finished")
                self.nextStage = 0
                /*
                
                let data_removal = self.computeBoard()
                //self.cout()
                if data_removal != [[]]{
                    self.removeBlocks(data_removal)
                    self.shiftBlock_stage2()
                }
                else{
                    root.addBlock()
                    root.updateCounter()
                    
                }
                */
            }
        }
        else{
            root.ani_shiftVertical(label: letter.l, vert: CGFloat(Int(self.incrementY)))
        }
    }
    
    
    func isWord(word:String,language:String = "en")->Bool{
        let word = word.lowercased()
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: language)
        return misspelledRange.location == NSNotFound
    }
    func wordPoints(word:String)->Int{
        //let betaPoints = ["a":1, "b":3, "c":3, "d":2, "e":1, "f":4, "g":2, "h":4, "i":1,"j":8,"k":5, "l":1,"m":3, "n":1, "o":1, "p":3, "q":10, "r":1, "s":1,"t":1, "u":1, "v":4, "w":4, "x":8, "y":4, "z":10]
        var points = 0
        let word = word.lowercased()
        for i in word{
            points += Int(self.betaPoints[String(i)]!)
        }
        return points
    }
    func highest_row_word(row:Int)->([[Int]],Int,String){
        var highestPoints = 0
        var highestWord = ""
        var colIndex:Int = 0
        var row_str = ""
        
        for col in 0...self.sizeW-1{
            if self.data[row][col] == nil{
                row_str = row_str + String(self.basis.letter)
            }
            else{
                row_str = row_str + String(self.data[row][col]!.letter)
            }
            
        }
        var row_list = row_str.components(separatedBy: String(self.basis.letter))
        row_list = row_list.filter{$0 != ""}
        for word in row_list{
            if word.count >= self.minWordLen{
                for subset in self.minWordLen...word.count{
                    var head = 0
                    for z in 0...word.count-subset{
                        var tempWord = word as NSString
                        tempWord = tempWord.substring(with: NSRange(location:head,length:subset)) as NSString
                        head += 1
                        if self.isWord(word: tempWord as String){
                            if self.wordPoints(word: tempWord as String) > highestPoints{
                                highestPoints = self.wordPoints(word: tempWord as String)
                                highestWord = tempWord as String
                                
                                colIndex = self.indexWordInWord(inner: highestWord, outer: row_str)
                            }
                            
                        }
                    }
                }
            }
        }
        if highestPoints == 0 {
            return ([],0,"")
        }
        //print(highestWord)
        
        var simplifyBoard = [[Int]](repeating: [Int](repeating: 0, count: self.sizeW), count: self.sizeL)
        
        for col in colIndex...colIndex+highestWord.count-1{
            simplifyBoard[row][col] = 1
        }
        return (simplifyBoard,highestPoints,highestWord)
        
    }
    func highest_col_word(col:Int)->([[Int]],Int,String){
        var highestPoints = 0
        var highestWord = ""
        var rowIndex:Int = 0
        var col_str = ""
        
        for row in 0...self.sizeL-1{
            if self.data[row][col] == nil{
                col_str = col_str + String(self.basis.letter)
            }
            else{
                col_str = col_str + String(self.data[row][col]!.letter)
            }
        }
        
        var col_list = col_str.components(separatedBy: String(self.basis.letter))
        col_list = col_list.filter{$0 != ""}
        
        for word in col_list{
            if word.count >= self.minWordLen{
                for subset in self.minWordLen...word.count{
                    var head = 0
                    
                    for z in 0...word.count-subset{
                        var tempWord = word as NSString
                        tempWord = tempWord.substring(with: NSRange(location:head,length:subset)) as NSString
                        head += 1
                        if self.isWord(word: tempWord as String){
                            if self.wordPoints(word: tempWord as String) > highestPoints{
                                highestPoints = self.wordPoints(word: tempWord as String)
                                highestWord = tempWord as String
                                
                                rowIndex = self.indexWordInWord(inner: highestWord, outer: col_str)
                            }
                            
                        }
                    }
                }
            }
        }
        if highestPoints == 0 {
            return ([],0,"")
        }
        //print(highestWord)
        var simplifyBoard = [[Int]](repeating: [Int](repeating: 0, count: self.sizeW), count: self.sizeL)
        
        for row in rowIndex...rowIndex+highestWord.count-1{
            simplifyBoard[row][col] = 1
        }
        return (simplifyBoard,highestPoints,highestWord)
    }
    func indexWordInWord(inner:String,outer:String)->Int{
        let inner = Array(inner)
        let outer = Array(outer)
        
        for a in 0...outer.count-1{
            var count = 0
            for b in 0...inner.count-1{
                if inner[b] == outer[a+b]{
                    count += 1
                }
            }
            if count == inner.count{
                return a
            }
        }
        
        return -1
    }
    func computeBoard()->[[Int]]{
        var data_checkPoints:[[Int]] = []
        var highestPoints = 0
        var highestWord:String =  ""
        for row in 0...self.sizeL-1{
            var data_row: [[Int]]
            var points:Int
            var tempWord:String
            (data_row,points,tempWord) = self.highest_row_word(row: row)
            if data_row != [] && points > highestPoints{
                highestPoints = points
                data_checkPoints = data_row
                highestWord = tempWord
                
            }
        }
        
        for col in 0...self.sizeW-1{
            var data_col: [[Int]]
            var points:Int
            var tempWord:String
            (data_col,points,tempWord) = self.highest_col_word(col: col)
            
            if data_col != [] && points > highestPoints{
                highestPoints = points
                data_checkPoints = data_col
                highestWord = tempWord
            }
        }
        
        
        
        if data_checkPoints == []{
            return [[]]
        }
        //if (highestWord.lowercaseString.rangeOfString(String(root.someBlock!.letter).lowercaseString) != nil){
        //}
        self.score += highestPoints
        self.scoreShelf.text = "\(self.score)"
        self.wordShelf.text = "'\(highestWord)'  +\(highestPoints)"
        return data_checkPoints
    }
    func removeBlocks(data_remove:[[Int]])->Bool{
        for row in 0...self.sizeL-1{
            for col in 0...self.sizeW-1{
                
                if data_remove[row][col] == 1{
                    let b = self.data[row][col]!
                    UIView.animate(withDuration: self.dropDelay*4, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveLinear, animations: { () -> Void in
                        //self.data[row][col].l.center = CGPoint(x: self.wordShelf.center.x,y:self.wordShelf.center.y)
                        //b.l.font = UIFont(name: "Avenir-Black", size: self.screenSize.height/10)
                        b.l.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
                        
                        b.l.frame = CGRect(x: Double(b.l.center.x)-Double(b.width), y: Double(b.l.center.y)-Double(b.height), width: Double(b.width)*2, height: Double(b.height)*2)
                        //b.l.sizeToFit()
                        
                    }, completion: {finished in
                        // the code you put here will be executed when your animation finishes, therefore
                        // call your function here
                        b.l.transform = .identity
                    })
                    self.remove(letter: b)
                    
                }
            }
        }
        return true
    }
    func compute_shiftboardShift()->Bool{
        if self.size == self.capacity{
            return false
        }
        for row in (0...self.sizeL-1).reversed(){
            for col in (0...self.sizeW-1).reversed(){
                if self.data[row][col] != nil{//self.basis.letter{
                    self.completeShift(letter: self.data[row][col]!)
                }
            }
        }
        return true
    }
    func swipe(sender:UISwipeGestureRecognizer){
        print("ih")
    }
    
}
