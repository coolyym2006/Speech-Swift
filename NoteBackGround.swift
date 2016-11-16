//
//  NoteBackGround.swift
//  FocusOnMyWorld
//
//  Created by coolyym on 2016/10/3.
//  Copyright © 2016年 YYM. All rights reserved.
//

import UIKit

import Speech


class NoteBackGround: UIView {
    
    var recognitionTask : SFSpeechRecognitionTask?
    var inputNode : AVAudioInputNode?
    var audioEngine : AVAudioEngine?
    var AudioRecognitionRequest : SFSpeechAudioBufferRecognitionRequest?
 
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textViewToContent: UITextView!
    
  
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        audioEngine = AVAudioEngine()
        
    }
    
    override func layoutSubviews() {
        
    }
    
    
    override func awakeFromNib() {
        
        
        
        SFSpeechRecognizer.requestAuthorization({ (status :SFSpeechRecognizerAuthorizationStatus) in
            if status == SFSpeechRecognizerAuthorizationStatus.authorized
            {
                
                print("《--------开启成功-———————》")
                
            }
            
            
        })

     
        layer.shadowColor = UIColor.black.cgColor;
        
        layer.shadowOffset = CGSize(width:4, height:20.0)
        
        layer.shadowOpacity = 0.5;
        
        layer.masksToBounds = true;
        
        layer.cornerRadius = 15;
        
        
              
       
    }
    
    
    func  startRecording()  {
        
        if recognitionTask != nil
        {
            recognitionTask?.cancel()
            recognitionTask = nil
            
        }
        
        let session = AVAudioSession.sharedInstance()
        
        if #available(iOS 10.0, *) {
            
            do {
                
                try session.setCategory(AVAudioSessionCategoryRecord, mode:AVAudioSessionModeMeasurement, options:AVAudioSessionCategoryOptions.defaultToSpeaker)
                
                try session.setActive(true, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
            } catch  {}
            
        }
        
        inputNode = audioEngine?.inputNode
        
        let AudioBuRecignitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        AudioBuRecignitionRequest.shouldReportPartialResults = false
        
        let format = inputNode?.outputFormat(forBus: 0)
        
         AudioRecognitionRequest  = AudioBuRecignitionRequest
        
        inputNode?.installTap(onBus: 0, bufferSize: 1024, format: format, block: { (buffer : AVAudioPCMBuffer, _) in
            AudioBuRecignitionRequest.append(buffer)
            
        })
        
        audioEngine?.prepare()
        
        do {
            try audioEngine?.start()
        } catch  {}
        
        
        
    }
    //  [AURemoteIO::IOThread] >avae> AVAudioEngineGraph.mm:2707: InputAvailab
    
    func VoiceAcitonEnd() {
         SVProgressHUD.show(withStatus: "正在识别")
        if (audioEngine?.isRunning)!
        {
            if #available(iOS 10.0, *) {
                
                weak var weakSelf  = self
                recognitionTask = speechRecignizer.recognitionTask(with: AudioRecognitionRequest!, resultHandler: { ( result : SFSpeechRecognitionResult? , _) in
                    
                
                    if result != nil {
                        
                        if(result?.isFinal)!
                        {
                        weakSelf?.textViewToContent.text =   (weakSelf?.textViewToContent.text)! + (result?.bestTranscription.formattedString)!
                            SVProgressHUD.dismiss()
                        
                        }
                        
                    }
                    else {
                        weakSelf?.audioEngine?.stop()
                        weakSelf?.recognitionTask = nil
                        weakSelf?.AudioRecognitionRequest = nil
                    }
                    
                    
                })
                
            }
            
            inputNode?.removeTap(onBus: 0)
            audioEngine?.stop()
            AudioRecognitionRequest?.endAudio()
            SVProgressHUD.dismiss()
            
            return
            
        }
        
        
        
        
        
    }

    
    
    
    @available(iOS 10.0, *)
    private  lazy var speechRecignizer : SFSpeechRecognizer = {
        
        
        let  locale = NSLocale.init(localeIdentifier : "zh-cn")
        
        let speechRecignizer = SFSpeechRecognizer.init(locale : locale as Locale )
        
        return speechRecignizer!
        
        
    }()
    
   

    


    
    
    
    
    @IBAction func SaveButton(_ sender: AnyObject) {
        
        VoiceAcitonEnd()
        
      
     
    }
    
    @IBAction func touchStart(_ sender: AnyObject) {
        
        startRecording()

        
        SVProgressHUD.show(withStatus: "请讲话")
    }
    
    
    class func NoteBackGroundInstandce() -> NoteBackGround
    {
        
        
        let NoteView  = (Bundle.main.loadNibNamed("NoteBackGround", owner: nil, options: nil)?.first as? NoteBackGround)!
        
        return NoteView
        
        
    }

}
