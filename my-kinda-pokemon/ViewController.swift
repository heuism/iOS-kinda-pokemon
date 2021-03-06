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
    
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var heart4Monster: DragImage!
    @IBOutlet weak var food4Monster: DragImage!
    
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2 //opaque 1 is full
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES: Int = 3
    var penalties:Int = 0
    var currentItem: UInt32 = 0
    
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
        
        reAllocateImage()
    
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
    //    NotificationCenter.default().addObserver(self, selector: Selector("itemDroppedOnCharacter"), name: "onTargetDropped", object: nil)
        NotificationCenter.default().addObserver(self, selector: #selector(itemDroppedOnCharacter), name: "onTargetDropped" as NSNotification.Name, object: nil)
       //NotificationCenter.default().addObserver(self, selector: #selector(reAllocateImage), name: "changeRotation" as NSNotification.Name, object: nil)

        startTimer()
    }
    
    func reAllocateImage() {
        //print("Here------------")
        food4Monster.dropTarget = monsterImg
        heart4Monster.dropTarget = monsterImg
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
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            
            sfxHeart.prepareToPlay()
            
            sfxSkull.prepareToPlay()
            
            sfxDeath.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        print("Item dropped on character")
        
        monsterHappy = true
        
        startTimer()
        
        switch currentItem {
        case 0:
            sfxHeart.play()
        default:
            sfxBite.play()
        }

        heart4Monster.alpha = DIM_ALPHA
        heart4Monster.isUserInteractionEnabled = false
        food4Monster.alpha = DIM_ALPHA
        food4Monster.isUserInteractionEnabled = false
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
        let rand = arc4random_uniform(2) // 0 or 1
        switch rand {
        case 1:
            food4Monster.alpha = OPAQUE
            food4Monster.isUserInteractionEnabled = true
            
            heart4Monster.isUserInteractionEnabled = false
            heart4Monster.alpha = DIM_ALPHA
        default:
            food4Monster.alpha = DIM_ALPHA
            food4Monster.isUserInteractionEnabled = false
            
            heart4Monster.isUserInteractionEnabled = true
            heart4Monster.alpha = OPAQUE
        }
        currentItem = rand
        monsterHappy = false
    }
    
    func gameOver() {
        sfxDeath.play()
        timer.invalidate()
        monsterImg.playDeadAnimation()
        musicPlayer.stop()
    }
}

