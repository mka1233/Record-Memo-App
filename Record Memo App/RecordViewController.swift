
import UIKit
import RealmSwift
import AVFoundation

class RecordViewController: UIViewController {
    var audioRecorder : AVAudioRecorder!
    var dataItems: Results<Data>!
    var myTimer: Timer!
    var urlNum : URL?
    var num = 0
    @IBOutlet weak var RecordTimer: UILabel!
    
    @IBAction func stopButton(_ sender: UIButton) {
        audioRecorder.stop()
        let realm = try! Realm()
        let data = Data()
        data.title = String(num)
        data.url = urlNum?.absoluteString ?? ""
        try! realm.write {
            realm.add(data)
        }
        myTimer.invalidate()
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
        myTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    @objc func update(){
        let time = audioRecorder.currentTime
        let min = Int(time / 60)
        let sec = String(format: "%02d",Int(time) % 60)
        RecordTimer.text = "\(min):\(sec)"
    }

    func getURL() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent("recording\(num).m4a")
        return url
    }
    }
    


