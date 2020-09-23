# graveyard
Unfinished or abandoned projects


If, for whatever reason; you're trying to clone this, make sure you have `git-lfs`[https://git-lfs.github.com/] insttalled before you do so. 

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

* [QuietModemDemo](https://github.com/narner/graveyard/tree/master/QuietModem-Demo) - I was playing around with the [QuietModemKit](https://github.com/quiet/QuietModemKit), a data-over-sound framewwork. I was trying to see if I could make a modern version of a previous app I worked on, 
[Whistlr] (https://nickarner.com/projects_and_work/whistlr/). The framework was pretty limited - could only send short character strings between mobile devices 
(though it could send pictures between a mobile device and a website), and the "ultrasonic" mode stil emitted a rather unpleasant audible tone. 

* [Emotion Recognition + ARKit](https://github.com/narner/graveyard/tree/master/EmotionRecognition%2BARKit%20Demo) - This was an experiment to see if it would be
possible to have simultaneous raw camera frame bufffer capture from both the front and rear facing cameras in an ARKit session. I wanted to perform emotion 
recognition of a user via the front facing camera while simultaneously creating an world-centric AR scene. The idea was to have the detected emotions drive 
the emotions of virtual characters in the AR scene.

Sadly, iOS doesn't allow for the sort of raw frame capture of multiple cameras if one of them performing an AR session. 

* [I started to write up](https://github.com/narner/graveyard/tree/master/Affective%20Computing%20and%20ARKit%20Apps%20(Blog%20Post%20Draft)) about how this could 
allow for affective computing + AR interface paradigms, but struggled to finish it in a clear manner. 


[GPT-3 Scrying Keyboard](https://github.com/narner/graveyard/tree/master/GPT-3_ScryingKeyboard) - I was super excited to get access to the GPT-3 API, and had a 
somewhat vague idea to build a project inspired by [Andy Matuschak](https://twitter.com/andy_matuschak)'s [scrying-pen project](https://github.com/andymatuschak/scrying-pen).

Basically, I wanted to see what the GPT-3 API would send back as I was typing...to see how each character I entered affected what the API was doing. Didn't really
work well in practice; you could only process a few tokens at a time before the API would become slower in returning results (and creating a very long feedback 
loop). 
