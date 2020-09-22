
//
//  ReceiveViewController.swift
//  QueitModem-Demo
//
//  Created by Nick Arner on 9/4/20.
//  Copyright © 2020 nfa. All rights reserved.
//

import UIKit

class ReceiveViewController: UIViewController {
    
    var rx: QMFrameReceiver?

    @IBOutlet weak var receivedMessageView: UIImageView!
    @IBOutlet weak var receivedMessageTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
          if granted {
            if self.rx == nil {
              let rxConf: QMReceiverConfig = QMReceiverConfig(key:"ultrasonic-experimental");
              self.rx = QMFrameReceiver(config: rxConf);
              self.rx?.setReceiveCallback(self.receiveCallback);
            }
          } else {
            print("Permission to record not granted")
          }
        })

    }

    func receiveCallback(frame: Data?) {
       let msg = String(data: frame ?? Data(), encoding: String.Encoding.utf8) ?? "data could not be decoded";
        receivedMessageTextView.text = msg
     }

}
