import UIKit
import CallKit
import AVFoundation
import MediaPlayer
import Foundation

class ViewController: UIViewController, CXProviderDelegate {
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        
        let provider = CXProvider(configuration: CXProviderConfiguration(localizedName: "My App"))
        provider.setDelegate(self, queue: nil)
        let controller = CXCallController()
        let transaction = CXTransaction(action: CXStartCallAction(call: UUID(), handle: CXHandle(type: .generic, value: "Pete Za")))
        controller.request(transaction, completion: { error in })
        
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 5) {
            provider.reportOutgoingCall(with: controller.callObserver.calls[0].uuid, connectedAt: nil)
        }
        //            self.startRingtoneIfOutgoing(ringtoneName: "call_audio_calling.mp3")
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
            try audioSession.overrideOutputAudioPort(.speaker)
            self.startRingtoneIfOutgoing(ringtoneName: "linkit_sound.wav")
        } catch {
        }
    }

    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
    }

    
    func startRingtoneIfOutgoing(ringtoneName: String) {
        let soundURL = Bundle.main.url(forResource: ringtoneName, withExtension: nil)!
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            self.audioPlayer!.numberOfLoops = -1
            self.audioPlayer!.play()
        } catch {
            print("[VoIP] Can't start ringstone")
        }
    }

}
