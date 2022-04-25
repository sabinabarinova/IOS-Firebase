
import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var AppName: UILabel!
    @IBOutlet weak var line: UIImageView!
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func LoginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showLogin", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLogin" {
            _ = segue.destination as! login
        }
    
    }
    

}

