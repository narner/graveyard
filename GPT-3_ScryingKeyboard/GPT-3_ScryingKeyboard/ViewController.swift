//
//  ViewController.swift
//  GPT-3_ScryingKeyboard
//
//  Created by Nick Arner on 8/16/20.
//  Copyright © 2020 Nick Arner. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

class ViewController: NSViewController, NSTextFieldDelegate {
    
    @IBOutlet weak var inputTextField: NSTextField!
    @IBOutlet weak var responseTextView: NSScrollView!
    
    var promptText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField.delegate = self
        let textView : NSTextView? = self.responseTextView?.documentView as? NSTextView
        textView?.isEditable = false
    }
    
    
    func callGPT3(prompt: String) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": ""
        ]
        
        let parameters: Parameters = [
            "prompt": prompt,
            "max_tokens": 50
        ]
        
        let textView : NSTextView? = self.responseTextView?.documentView as? NSTextView
        
        AF.request("https://api.openai.com/v1/engines/curie/completions",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .responseJSON { response in
                
                if let value = response.value as? [String: AnyObject] {
                    let responseChoices:NSArray = value["choices"] as! NSArray
                    let d:NSDictionary = responseChoices[0] as! NSDictionary
                    if let text = d["text"] {
                        DispatchQueue.main.async {
                            textView?.string = text as! String
                        }
                    }
                }
        }
        
    }
    
    
    
    func controlTextDidChange(_ notification: Notification) {
        let textField = notification.object as? NSTextField
        callGPT3(prompt: textField!.stringValue)
    }
    
    func controlTextDidEndEditing(_ notification: Notification) {
        let textField = notification.object as? NSTextField
        
    }
    
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}

