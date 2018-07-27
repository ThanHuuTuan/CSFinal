//
//  specialViewController.swift
//  MacNet
//
//  Created by Samuel Miserendino on 7/26/18.
//  Copyright © 2018 Samuel Miserendino. All rights reserved.
//

import UIKit
var idcounter = 0

var disabled = false;

class specialViewController: UIViewController {

    @IBOutlet weak var cursorImg: UIImageView!
    @IBOutlet weak var controlMouse: UIView!
    @IBOutlet weak var cancelbtn: UIButton!
    @IBOutlet weak var shutdownbtn: UIButton!
    
    @IBOutlet weak var openurl: UITextField!
    @IBOutlet weak var createalert: UITextField!
    @IBOutlet weak var execute: UITextField!
 
    @IBAction func svalchange(_ sender: Any) {
       let vol = Int((sender as! UISlider).value*100)
        sendMessage("https://macnetback-nylr.c9users.io/uvol", type: "4", content: String(vol))
        
    }
    
    @IBAction func sleepPush(_ sender: Any) {
    sendMessage("https://macnetback-nylr.c9users.io/", type: "6", content: "dosleep")
    }
    
    @IBAction func disableToggle(_ sender: Any) {
        disabled = !disabled
        let senobj = sender as! UIButton
        senobj.setTitle((disabled ? "Enable" : "Disable") , for: .normal)
        sendMessage("https://macnetback-nylr.c9users.io/", type: "5", content: String(disabled))
        
    }
    
    func sendMessage(_ requestURL: String, type: String, content: String){
        idcounter += 1
        let url = URL(string: requestURL)
        var urlreq = URLRequest(url: url!)
        urlreq.httpMethod = "POST"
        let myData: [String: String] = ["message": content, "type": type, "id": String(idcounter), "source": "mobile"]
        var dataString = ""
        for (key, value) in myData {
            dataString += "\(key)=\(value)&"
        }
        urlreq.httpBody = dataString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: urlreq){ (data, response, error) in
            
        }
        task.resume()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        controlMouse.layer.masksToBounds = true
        controlMouse.layer.cornerRadius = 13
        
        for domelement in [openurl, createalert, execute] {
            (domelement as! UIView).frame.size.height *= 1.3
        }
        
//        controlMouse.layer.borderColor = UIColor.black.cgColor
//        controlMouse.layer.borderWidth = 1

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goPressed(_ sender: UIButton) {
        if sender.tag == 1 {
        sendMessage("https://macnetback-nylr.c9users.io/", type: String(sender.tag), content: openurl.text!)
        } else if sender.tag == 2 {
        sendMessage("https://macnetback-nylr.c9users.io/", type: String(sender.tag), content: createalert.text!)
        } else if sender.tag == 3 {
        sendMessage("https://macnetback-nylr.c9users.io/", type: String(sender.tag), content: execute.text!)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first!
        let location = touch.location(in: controlMouse)
        if location.x >= 0 && location.y <= controlMouse.frame.size.width {
            if location.y >= 0 && location.y <= controlMouse.frame.size.height {
                let xfac: CGFloat = location.x/controlMouse.frame.size.width
                let yfac: CGFloat = location.y/controlMouse.frame.size.height
                let diffx = location.x - cursorImg.frame.origin.x + cursorImg.frame.size.width/2
                let diffy = location.y - cursorImg.frame.origin.y + cursorImg.frame.size.height/2
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2, animations: { () -> Void in
                            self.cursorImg.frame.origin.x += diffx
                            self.cursorImg.frame.origin.y += diffy
                        var expframes: [clickAnimation] = []
                        
                        let expFrame = clickAnimation(frame: CGRect(x: location.x-50, y: location.y-50, width: 150, height: 150))
                        expFrame.backgroundColor = .clear
                        self.controlMouse.addSubview(expFrame)
                        (expFrame.layer as! coreExpandLayer).expand()
                        expframes.append(expFrame)
                        self.sendMessage("https://macnetback-nylr.c9users.io/volandpos", type: "0", content: "\(xfac):\(yfac)")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { () -> Void in
                            
                            let expFrame = clickAnimation(frame: CGRect(x: location.x-50, y: location.y-50, width: 150, height: 150))
                            expFrame.backgroundColor = .clear
                            self.controlMouse.addSubview(expFrame)
                            (expFrame.layer as! coreExpandLayer).expand()
                            expframes.append(expFrame)
                            
                        })
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: { () -> Void in
                            
                            let expFrame = clickAnimation(frame: CGRect(x: location.x-50, y: location.y-50, width: 150, height: 150))
                            expFrame.backgroundColor = .clear
                            self.controlMouse.addSubview(expFrame)
                            (expFrame.layer as! coreExpandLayer).expand()
                            
                            expframes.append(expFrame)
                        })
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { () -> Void in
                                print("Cleaning up objects...")
                            for element in expframes {
                                element.removeFromSuperview()
                            }
                            
                            
                        })
                        
                    })
                }
                
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
