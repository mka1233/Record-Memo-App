
import UIKit
import RealmSwift
import AVFoundation

extension UIViewController {
    private final class StatusBarView: UIView { }

    func setStatusBarBackgroundColor(_ color: UIColor?) {
        for subView in self.view.subviews where subView is StatusBarView {
            subView.removeFromSuperview()
        }
        guard let color = color else {
            return
        }
        let statusBarView = StatusBarView()
        statusBarView.backgroundColor = color
        self.view.addSubview(statusBarView)
        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        statusBarView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        statusBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        statusBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        statusBarView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
}

class RecordViewController: UIViewController {
    var audioRecorder : AVAudioRecorder!
    var dataItems: Results<Data>!
    var myTimer: Timer!
    var urlNum : URL?
    var dt = ""
    @IBOutlet weak var RecordTimer: UILabel!
    
    @IBAction func stopButton(_ sender: UIButton) {
        audioRecorder.stop()
        let realm = try! Realm()
        let data = Data()
        data.title = String(dt)
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
        self.navigationItem.hidesBackButton = true
        configreView()
        navigationItem.title = "録音中..."
    }
    
    func configreView() {
        setStatusBarBackgroundColor(.red)
    }
    
    func setRecorder(){
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playAndRecord, options: [.defaultToSpeaker,
                                                           .allowAirPlay,
                                                           .allowBluetoothA2DP])
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
        let url = docsDirect.appendingPathComponent("recording \(dt).m4a")
        return url
    }
    }
    


