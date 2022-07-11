
import UIKit
import RealmSwift
import AVFoundation

class MemoAndPlayViewController: UIViewController,AVAudioPlayerDelegate{

    var dataItems: Results<Data>!
    var myTimer: Timer!
    var indexPathOfRow = 0
    var audioPlayer : AVAudioPlayer!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var seakVar: UISlider!
    @IBOutlet weak var speedMeterLabel: UILabel!
    @IBOutlet weak var audioButton: UIButton!
    
    
    @IBAction func audioStopButton(_ sender: UIButton) {
        if audioPlayer.isPlaying{
            audioPlayer.pause()
            sender.setTitle("▶️", for: .normal)
        }else{
            audioPlayer.play()
            sender.setTitle("⏸", for: .normal)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag{
            audioButton.setTitle("▶️", for: .normal)
            seakVar.value = 0.0
        }
    }
    
    @IBAction func seekVarSlider(_ sender: UISlider) {
        audioPlayer.currentTime = Double(sender.value)
    }
    
    
    @IBAction func speedAdjust(_ sender: UISlider) {
        speedMeterLabel.text = String(format: "%.1f", sender.value)
        audioPlayer.rate = sender.value
    }
    
    @IBAction func tenSecoundsSkipButton(_ sender: UIButton) {
        audioPlayer.currentTime += 10.0
        seakVar.value = Float(audioPlayer.currentTime)
    }
    
    @IBAction func tenSecoundsBackButton(_ sender: UIButton) {
        audioPlayer.currentTime -= 10.0
        seakVar.value = Float(audioPlayer.currentTime)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        seakVar.maximumValue = Float(audioPlayer.duration)
        myTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
    }
    
    func setting(){
        let realm = try! Realm()
        dataItems = realm.objects(Data.self)
        let memo = dataItems[indexPathOfRow]
        textView.text = memo.textMemo
        titleText.text = memo.title
        let url = URL(string: memo.url)
        
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.delegate = self
        audioPlayer.volume = 1.0
        audioPlayer.pan = 0.0
        audioPlayer.enableRate = true
        audioPlayer.play()
    }
    
    
    @objc func updateSlider(){
            
        let time = Float(audioPlayer.currentTime)
        seakVar.value = time
        let min = time / 60
        let sec = String(format: "%02d",Int(time) % 60)
        timer.text = "\(Int(min)):\(sec)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayer.stop()
        myTimer.invalidate()
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        let realm = try! Realm()
        let memo = dataItems[indexPathOfRow]
        
        try! realm.write{
            memo.textMemo = (textView?.text)!
            memo.title = titleText.text!
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
