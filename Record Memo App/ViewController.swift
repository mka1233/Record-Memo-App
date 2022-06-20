
import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    var num = 0
    var dataItems: Results<Data>!
    @IBOutlet weak var table: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.dataSource = self
        table.delegate = self

        let realm = try! Realm()
        dataItems = realm.objects(Data.self)

        table.reloadData()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let object = dataItems[indexPath.row]
        cell.textLabel?.text = object.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextView = self.storyboard?.instantiateViewController(withIdentifier: "Next") as! MemoAndPlayViewController
        nextView.indexPathOfRow = indexPath.row
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    
    @IBAction func RecordButton(_ sender: UIBarButtonItem) {
        let nextView2 = self.storyboard?.instantiateViewController(withIdentifier: "Next2") as! RecordViewController
        num += 1
        nextView2.num = num
        self.navigationController?.pushViewController(nextView2, animated: true)
    }
    

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCell(at:indexPath.row)
            table.reloadData()
        }
    }

    func deleteCell(at index: Int) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(dataItems[index])
        }
    }

}
