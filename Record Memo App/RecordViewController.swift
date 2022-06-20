
import UIKit
import RealmSwift
import AVFoundation

class RecordViewController: UIViewController {
    var audioRecorder : AVAudioRecorder!
    var dataItems: Results<Data>!
    var urlNum : URL?
    var num = 0
    
    @IBAction func stopButton(_ sender: UIButton) {
        audioRecorder.stop()
        let realm = try! Realm()
        let data = Data()
        data.title = String(num)
        data.url = urlNum?.absoluteString ?? ""
        try! realm.write {
            realm.add(data)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        dataItems = realm.objects(Data.self)
        setRecorder()
    }
    
    func setRecorder(){
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playAndRecord, mode: .default)
        try! session.setActive(true)
        
        let settings = [
            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey : 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        urlNum = getURL()
        audioRecorder = try! AVAudioRecorder(url: urlNum!, settings: settings)
        audioRecorder.record()
    }

    func getURL() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent("recording\(num).m4a")
        return url
    }
    }
    


