//
//  TransmitViewController.swift
//  QueitModem-Demo
//
//  Created by Nick Arner on 9/4/20.
//  Copyright © 2020 nfa. All rights reserved.
//

import UIKit

class TransmitViewController: UIViewController {

    var tx: QMFrameTransmitter = {
      let txConf: QMTransmitterConfig = QMTransmitterConfig(key: "ultrasonic-experimental");
      let tx: QMFrameTransmitter = QMFrameTransmitter(config:txConf);
      return tx;
    }()

    @IBOutlet weak var transmitTextView: UITextView!
    
    var strBase64: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
            //Use image name from bundle to create NSData
            let image : UIImage = UIImage(named:"2.PNG")!
            //Now use image to create into NSData format
        let imageData:Data = image.pngData()!
    strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)

    }

    @IBAction func transmit(_ sender: Any) {
        let frame_str = "rz"
        let data = frame_str.data(using: .utf8)
        self.tx.send(data)
    }


}
