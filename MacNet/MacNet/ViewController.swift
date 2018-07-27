//
//  ViewController.swift
//  MacNet
//
//  Created by Samuel Miserendino on 7/26/18.
//  Copyright © 2018 Samuel Miserendino. All rights reserved.
//

import UIKit

var termBlink = Timer()
var termState = true;
let greenString: String = "pkg app -init core.xkcl"
var counter = 0
var blinkCount = 0

var textWrite = Timer()

class ViewController: UIViewController {
    @IBOutlet weak var appStart: UILabel!
    @IBOutlet weak var greenText: UILabel!
    @IBOutlet weak var termBar: UILabel!
    
    
    
    @objc func controlFlash(){
            blinkCount += 1
        
            if (blinkCount >= 9){
                
                UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseIn], animations: { () -> Void in
                        self.appStart.frame.origin.y -= 400
                        self.appStart.layer.opacity = 0
                }, completion: { (success) -> Void in
                    termBlink.invalidate()
                })
                
                UIView.animate(withDuration: 0.8, delay: 0.1, options: [.curveEaseIn], animations: { () -> Void in
                    self.greenText.frame.origin.y += 600
                    self.termBar.frame.origin.y += 600
                     self.greenText.layer.opacity = 0
                    self.termBar.layer.opacity = 0
                }, completion: { (success) -> Void in
                    termBlink.invalidate()
                    self.performSegue(withIdentifier: "tonext", sender: nil)
                })
                
            }
        
            UIView.animate(withDuration: 0.45, animations: { () -> Void in
                self.termBar.layer.opacity = termState ? 0 : 1
                termState = !termState
            })
        
        }
    
    @objc func textMove() {
        DispatchQueue.main.async {
            self.greenText.text = String(greenString.prefix(counter))
            self.greenText.sizeToFit()
            self.greenText.frame.size.width += 35
            self.termBar.frame.origin.x = self.greenText.frame.size.width + self.greenText.frame.origin.x - 15
            counter += 1
        }
        
        if (counter == greenString.count){
            textWrite.invalidate()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        termBlink = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(controlFlash), userInfo: nil, repeats: true)
        
        textWrite = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(textMove), userInfo: nil, repeats: true)
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [], animations: { () -> Void in
            self.appStart.layer.opacity = 1
            self.termBar.layer.opacity = 1
            self.greenText.layer.opacity = 1
            
        }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

