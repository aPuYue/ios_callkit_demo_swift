import UIKit
import CallKit
import AVFoundation
import MediaPlayer
import Foundation

class ViewController: UIViewController, CXProviderDelegate {
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        
        configureAudioSession()
        
        let provider = CXProvider(configuration: CXProviderConfiguration(localizedName: "My App"))
        provider.setDelegate(self, queue: nil)
        let controller = CXCallController()
        let transaction = CXTransaction(action: CXStartCallAction(call: UUID(), handle: CXHandle(type: .generic, value: "Pete Za")))
        controller.request(transaction, completion: { error in })
        
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 5) {
            provider.reportOutgoingCall(with: controller.callObserver.calls[0].uuid, connectedAt: nil)
        }
    }
    
    func providerDidReset(_ provider: CXProvider) {
        
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        action.fulfill() // Disable button
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        action.fail()
    }
    
    func provider(_ provider: CXProvider, perform action: CXPlayDTMFCallAction) {
        action.fail()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetGroupCallAction) {
        action.fail()
    }
    
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        action.fail()
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        do {
            self.startRingtoneIfOutgoing()
        } catch {
            print("error")
        }
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeVoiceChat, options: [.defaultToSpeaker])
            self.audioPlayer = try AVAudioPlayer(contentsOf:  Bundle.main.url(forResource: "call_audio_calling.mp3", withExtension: nil)!)
            self.audioPlayer!.numberOfLoops = -1
            self.audioPlayer!.play()
        } catch {
        }
    }
    
    func startRingtoneIfOutgoing() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient, mode: AVAudioSessionModeDefault)
            try AVAudioSession.sharedInstance().setActive(true)
            self.audioPlayer = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "linkit_sound.wav", withExtension: nil)!)
            self.audioPlayer!.numberOfLoops = -1
            self.audioPlayer!.play()
        } catch {
            print("[VoIP] Can't start ringstone")
        }
    }
}
