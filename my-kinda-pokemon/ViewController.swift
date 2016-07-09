//
//  ViewController.swift
//  my-kinda-pokemon
//
//  Created by Hien Tran on 7/07/2016.
//  Copyright © 2016 HienTran. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg: Enemy1!
    @IBOutlet weak var monster2Img: Enemy2!
    @IBOutlet weak var heart4Monster: DragImage!
    @IBOutlet weak var food4Monster: DragImage!
    @IBOutlet weak var clock4Monster: DragImage!
    
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    
    @IBOutlet weak var restartBtn: UIButton!
    
    let DIM_ALPHA: CGFloat = 0.2 //opaque 1 is full
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES: Int = 3
    var penalties:Int = 0
    var currentItem: UInt32 = 0
    var monster1Select:Bool = false;

    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    var timer: Timer!
    
    var monsterHappy:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSound()
        initData()
    }
    
    @IBAction func restartGame(_ sender: AnyObject) {
        initData()
    }
    
    func initData() {
        musicPlayer.play()
        
        monsterImg.isHidden = !monster1Select
        
        monster2Img.isHidden = monster1Select
        
        penalties = 0
        currentItem = 0
        
        showRestartBtn(on: false)
        showInteractItem(show: true)
        
        switch monster1Select {
        case true:
            monsterImg.playStandingAnimation()
        default:
            monster2Img.playStandingAnimation()
        }
        reAllocateImage()
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        //    NotificationCenter.default().addObserver(self, selector: Selector("itemDroppedOnCharacter"), name: "onTargetDropped", object: nil)
        NotificationCenter.default().addObserver(self, selector: #selector(itemDroppedOnCharacter), name: "onTargetDropped" as NSNotification.Name, object: nil)
        
        startTimer()
    }
    
    func reAllocateImage() {
        //print("Here------------")
        switch monster1Select {
        case true:
            food4Monster.dropTarget = monsterImg
            heart4Monster.dropTarget = monsterImg
            clock4Monster.dropTarget = monsterImg
        default:
            food4Monster.dropTarget = monster2Img
            heart4Monster.dropTarget = monster2Img
            clock4Monster.dropTarget = monster2Img
        }
    }
    
    func loadSound(){
        do {
            try musicPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main().pathForResource("bite", ofType: "wav")!))

            try sfxHeart = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main().pathForResource("heart", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main().pathForResource("skull", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main().pathForResource("death", ofType: "wav")!))
            
            musicPlayer.numberOfLoops = -1
            musicPlayer.prepareToPlay()
            
            sfxBite.prepareToPlay()
            
            sfxHeart.prepareToPlay()
            
            sfxSkull.prepareToPlay()
            
            sfxDeath.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func showInteractItem(show: Bool) {
        
        var alpha: CGFloat!
        switch show {
        case true:
            alpha = OPAQUE
        default:
            alpha = DIM_ALPHA
            
        }
        print("show --- \(show)")
        heart4Monster.alpha = alpha
        heart4Monster.isUserInteractionEnabled = show
        food4Monster.alpha = alpha
        food4Monster.isUserInteractionEnabled = show
        clock4Monster.alpha = alpha
        clock4Monster.isUserInteractionEnabled = show
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        print("Item dropped on character")
        
        showInteractItem(show: false)
        monsterHappy = true
        
        startTimer()
        
        switch currentItem {
        case 1:
            sfxBite.play()
        default:
            sfxHeart.play()
        }

        //showRestartBtn(on: false)
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !monsterHappy {
            penalties += 1
            sfxSkull.play()
            switch penalties {
            case 1:
                penalty1Img.alpha = OPAQUE
            case 2:
                penalty2Img.alpha = OPAQUE
            case 3:
                penalty3Img.alpha = OPAQUE
            default:
                penalty1Img.alpha = DIM_ALPHA
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
                //code
            }
            
            if penalties >= MAX_PENALTIES {
                
                gameOver()
            }
        }
        let rand = arc4random_uniform(3) // 0 or 1
        switch rand {
        case 0:
            food4Monster.alpha = DIM_ALPHA
            food4Monster.isUserInteractionEnabled = false
            
            heart4Monster.isUserInteractionEnabled = true
            heart4Monster.alpha = OPAQUE
            
            clock4Monster.isUserInteractionEnabled = false
            clock4Monster.alpha = DIM_ALPHA
        case 1:
            food4Monster.alpha = OPAQUE
            food4Monster.isUserInteractionEnabled = true
            
            heart4Monster.isUserInteractionEnabled = false
            heart4Monster.alpha = DIM_ALPHA
            
            clock4Monster.isUserInteractionEnabled = false
            clock4Monster.alpha = DIM_ALPHA
        default:
            food4Monster.alpha = DIM_ALPHA
            food4Monster.isUserInteractionEnabled = false
            
            heart4Monster.isUserInteractionEnabled = false
            heart4Monster.alpha = DIM_ALPHA
            
            clock4Monster.isUserInteractionEnabled = true
            clock4Monster.alpha = OPAQUE
        }
        currentItem = rand
        monsterHappy = false
    }
    
    func callShowBtn(timer: Timer) {
        
        var setting = timer.userInfo as! Bool
        showRestartBtn(on: setting)
    }
    
    func showRestartBtn(on: Bool) {
        print("HERE----HERE")
        if on {
            restartBtn.isHidden = false
            showInteractItem(show: false)
        }
        else {
            restartBtn.isHidden = true
        }
    }
    
    func gameOver() {
        //monsterImg.stopAnimating()
        sfxDeath.play()
        timer.invalidate()
        switch monster1Select {
        case true:
            monsterImg.playDeadAnimation()
        default:
            monster2Img.playDeadAnimation()
        }
        musicPlayer.stop()
        Timer.scheduledTimer(timeInterval: sfxDeath.duration, target: self, selector: #selector(callShowBtn), userInfo: true, repeats: false)
    }
}

