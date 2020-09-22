```
title: "Attempting to Build an Affective-Computing Enabled ARKit App"
date: 2020-19-07
```



### Overview  

Prior to writing this, my intention was to make an iOS demo that would showcase how CoreML + ARKit could be used to use camera-based emotion recognition to drive the user interactions in an ARKit app.  

Because a couple of roadblocks that I'll dis	cuss here, I wasn't able to complete the demo; but I wanted to outline what I found out while working on it, as well as offer a possibility of what these interactions may look like as Apple further develops the capabilities of ARKit, as well as possible new CoreML models are developed. 



### Accessing Frames from Multiple Cameras on iOS, and Current Limitations with ARKit

In iOS 13, [Apple made it possible to access the raw frames from multiple cameras on the iPhone](https://developer.apple.com/videos/play/wwdc2019/249/#:~:text=Menu%20Close%20Menu-,Introducing%20Multi%2DCamera%20Capture%20for%20iOS,and%20the%20latest%20iPad%20Pro.) at once by using an instance of [AVCaptureMultiCamSession](). This would allow developers to create apps that would let you take photos or videos using both cameras at the same time: 

![iOS-Multi-Camera](/Users/nickarner/Documents/MyWebsite/static/blog_assets/2020/iOS-Multi-Camera.png)



With iOS 13, it also became possible to leverage both the rear and front facing cameras while working with ARKit sessions. You can create a world-tracking `ARSession`, and enable face tracking at the same time:

```
let configuration = ARWorldTrackingConfiguration()

arView.session.delegate = self
configuration.userFaceTrackingEnabled = true
arView.session.run(configuration)

```

Apple's [example code for demoing this functionality](https://developer.apple.com/documentation/arkit/combining_user_face-tracking_and_world_tracking) creates a world-tracking AR session that displays a virtual robot head floating in the AR space created by the front-facing camera. The AR face tracking markers that are detected by the front facing camera allow you to control the facial expression of the robot head - whatever facial expression you make will be replicated in the facial expression of the robot character. 

In this scenario, it's possible to access the raw camera frames of the front-facing camera by accessing the `capturedImage` property of the `ARFrame` in the `didUpdate frame: ARFrame` delegate method: 

```
func session(_ session: ARSession, didUpdate frame: ARFrame) {        
	let frameImageBuffer: CVPixelBuffer = frame.capturedImage
}
```


However, it's *not* possible to simultaneously capture the frames of the back-facing camera - iOS will only allow you to capture the frames of one camera. 

From my research, it appears that it's not possible to access the raw camera frames from both cameras if you've created a world-tracking AR session with face-tracking enabled, even though both cameras are in use. 

* [Running simultaneous ARSession and AVSession](https://developer.apple.com/forums/thread/653255)

* [Is it possible to access multiple cameras from an ARFrame](https://developer.apple.com/forums/thread/653340)

* [Is it possible to access multiple cameras from ARFrame?](https://stackoverflow.com/questions/62784357/is-it-possible-to-access-multiple-cameras-from-arframe)

This is unfortunate, because if it were possible to process the frames of both cameras during an AR session, it would be possible to perform a vision-based emotional inference of a user while in an ARKit session - enabling developers to create affective computing applications in an AR-context. 



### What is Affective Computing?

Affective Computing is the computing paradigm in which computers are aware of their users' emotions, and/or able to illicit new emotions in their users. In this paradigm, computers are able to detect emotions and respond accordingly given the proper context. The term was coined by MIT Media Lab researcher [Rosalind Picard](http://web.media.mit.edu/~picard/), who wrote the seminally titled [paper](https://affect.media.mit.edu/pdfs/95.picard.pdf) and [book](https://mitpress.mit.edu/books/affective-computing) of the same name. 

Picard argues that emotions are a critical part of the way people engage with the world, and that in order for computers to be considered human, they have to be capable of interacting with people in a way that acknowledges and responds to emotion. Her argument is, essentially, that it's not enough for computers to provide logical answers to questions, or engage in a semantically and syntactically logical dialog with a human - they have to do so in a way that acknowledges the emotions of the person interacting with them, and be able to respond the person in a manner that's appropriate for the context.

Some possible application areas of Affective Computing include:

* Gaming

* Education

* Therapy

* Healthcare 	



### Affective Computting + ARKit

Augmented Reality and Affective Computing are both still in the very nascent stages in terms of what the real world applications will be, and commercially available apps that make use of these paradigms are even earlier still. 

There is a plethora of research available on how to measure human emotion across a variety of modalities, including [facial expressions](), [speech](https://cacm.acm.org/magazines/2018/5/227191-speech-emotion-recognition/fulltext), and even [gait](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/59c5054b-7509-45cc-b119-e82328f4a030/EyesPrescription-2020.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20200718%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20200718T165920Z&X-Amz-Expires=86400&X-Amz-Signature=307484da09fb151498b70e65eabf9e967b0368ba74d381e925cb12d2561c52ac&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22EyesPrescription-2020.pdf%22). 

For iOS-based ARKit apps, voice and vision offer a ckear path towards adopting Affecttive Computing. Voice based ML inference is still in the extremely early stages on iOS - there's still a lot to do in terms of developing ML models that are small enough that can handle audio-based Core-ML tasks on-device, without passing the data to a model running on a cloud instance. 

Vision-based Core-ML models are much further developed, and there is [at least one implementation of a Core-ML model]() that can recognize emotions. It's based off of *[Emotion Recognition in the Wild via Convolutional Neural Networks and Mapped Binary Patterns](https://talhassner.github.io/home/publication/2015_ICMI)*.

The model is supposed to be able to distinguish between seven different emotional states ([though, my own quick tests didn't seem like this was particularly accurate](https://twitter.com/nickarner/status/1284266112448819200?s=20)):

* Anger

* Disgust

* Happiness

* Sadness

* Surprise

* Fear 

* Neutral
  

![ModelTest](/Users/nickarner/Documents/MyWebsite/static/blog_assets/2020/ModelTest.png)



​													*The emotional label accuracy was not quite what I hoped this model would have...*



The author of the paper of the original model states on his website "...far less labeled data is typically available for training emotion classification systems." - presumably, a more accurate model would be possible if trained on a dataset specifically for emotion recognition (the model was trained on [ImageNet](http://www.image-net.org/), and then tuned for emotion detection).



### Closing Thoughts 

As I mentioned earlier, I wanted to build a prototype that would demonstrate how you could use Affective Computing to drive an AR interaction on an iOS device. The idea was to use the Core-ML model mentioned above to detect my emotions using the front facing camera, and trigger various animated 3D models displayed in the AR view based on what my detected emotional state. While it wasn't possible to build the demo as of right now given the limitations on camera frame access during ARKit sessions on iOS (and the need for further work on developing an accurate CoreML model for vision-based emotion recognition), assuming these advances are made, it will eventually be possible to build ARKit apps that are responsive to their user's emotions.

Apple's advances in machine-learning chips and the on-device ML software capabilities of iOS mean that its becoming possible to develop ever more sophisticated Core-ML models, including ones that are capable of detecting emotions.  ARKIt is becoming more and more powerful with each new iOS release, too. 

Additionally, the hardware and camera capabilities of iOS devices are advacning, too. It's now currently posssible access the raw fframes of multiple cameras on an iOS device. Hopefully, a future release of iOS will enable raw camera frames to be accessed while an AR session is occuring, so that an ML classifier could infer the emotional state of a user while they're engaged in an AR experience. This would enable developers the ability to bring Affective-Computing paradigms to Augmented-Reality apps, opening the door to a new class of applications that allow computers to be aware of and responsive to human emotional states. 

Of course, with tehse capabilitties comes the responsibilites to developers to be extremely mindful of the ethical considerations around the technology of emotion detection. Generally speaking, it's best if the data used to infer someone's emotions stays on the device and is not sent to a model running on a cloud instance, as well as the inferred emotional state of the user. This ensures that private user information (their image and emotional state) is kept, literally, in the hands of the user; and never leaves their personal device.