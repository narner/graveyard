//
//  ViewController.swift
//  EmotionRecognition+ARKit Demo
//
//  Created by Nick Arner on 7/6/20.
//  Copyright © 2020 Nick Arner. All rights reserved.
//

import UIKit
import CoreML
import Vision
import RealityKit
import ARKit

var requests = [VNRequest]()

private let videoSize = CGSize(width: 1280, height: 720)
private let preferredFps: Int32 = 2

private var videoCapture: VideoCapture!
private let serialQueue = DispatchQueue(label: "com.shu223.coremlplayground.serialqueue")

private var cropAndScaleOption: VNImageCropAndScaleOption = .scaleFit
private var selectedVNModel: VNCoreMLModel?
private var selectedModel: MLModel?



class ViewController: UIViewController, ARSessionDelegate {
    @IBOutlet var arView: ARView!
    @IBOutlet weak var messageLabel: MessageLabel!
    @IBOutlet weak var restartButton: UIButton!

    @IBOutlet weak var testView: UIImageView!
//    let configuration = ARWorldTrackingConfiguration()
    let configuration = ARFaceTrackingConfiguration()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let spec = VideoSpec(fps: preferredFps, size: videoSize)
        let frameInterval = 1.0 / Double(preferredFps)
        
        videoCapture = VideoCapture(cameraType: .back,
                                    preferredSpec: spec,
                                    previewContainer: nil)
        videoCapture.imageBufferHandler = {[unowned self] (imageBuffer, timestamp, outputBuffer) in
            let delay = CACurrentMediaTime() - timestamp.seconds
            if delay > frameInterval {
                return
            }

            serialQueue.async {
                self.runModel(imageBuffer: imageBuffer)
            }
        }

        selectedModel = CNNEmotions().model
        selectedVNModel = try! VNCoreMLModel(for: selectedModel!)
        
        // Enable tracking the user's face during the world tracking session.
//        configuration.userFaceTrackingEnabled = true
        configuration.isWorldTrackingEnabled = true
        
        arView.session.delegate = self
        
        // We want to run a custom configuration.
        arView.automaticallyConfigureSession = false

        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        guard let videoCapture = videoCapture else {return}
//        videoCapture.startCapture()
        
        arView.session.run(configuration)

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
//        guard let videoCapture = videoCapture else {return}
//        videoCapture.stopCapture()
        super.viewWillDisappear(animated)
    }


    
      private func runModel(imageBuffer: CVPixelBuffer) {
        guard let model = selectedVNModel else { return }
        let handler = VNImageRequestHandler(cvPixelBuffer: imageBuffer)
        
        let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
               if let results = request.results as? [VNClassificationObservation] {
                   self.processClassificationObservations(results)
               }

           })
        
        request.preferBackgroundProcessing = true
        request.imageCropAndScaleOption = cropAndScaleOption
        
        do {
            try handler.perform([request])
        } catch {
            print("failed to perform")
        }
    }

    
    private func processClassificationObservations(_ results: [VNClassificationObservation]) {
        var firstResult = ""
        var others = ""
        for i in 0...10 {
            guard i < results.count else { break }
            let result = results[i]
            let confidence = String(format: "%.2f", result.confidence * 100)
            if i==0 {
                firstResult = "\(result.identifier) \(confidence)"
            } else {
                others += "\(result.identifier) \(confidence)\n"
            }
        }
        DispatchQueue.main.async(execute: {
            print(firstResult)
        })
    }
    
    
    @IBAction func restartButtonPressed(_ sender: Any) {
        resetTracking()
    }

    func resetTracking() {
        arView.scene.anchors.removeAll()
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        messageLabel.displayMessage("")
    }

    
    // MARK: - ARSessionDelegate

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        displayErrorMessage(for: error)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame){
        testView.image = UIImage(ciImage: CIImage(cvPixelBuffer: frame.capturedImage))

    }
    
 
    

    private func displayErrorMessage(for error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        // Remove optional error messages.
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            // Present an alert informing about the error that has occurred.
            let alertController = UIAlertController(title: "The AR session failed.", message: errorMessage, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
                self.resetTracking()
            }
            alertController.addAction(restartAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Overrides
    
    override var prefersStatusBarHidden: Bool {
        // If possible, hide the status bar to improve immersiveness of the AR experience.
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        // If possible, hide the home indicator to improve immersiveness of the AR experience.
        return true
    }

}


