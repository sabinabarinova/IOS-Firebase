
import UIKit
import FirebaseAuth
import Firebase

class login: UIViewController {
    
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var go: UIButton!
    @IBOutlet weak var alert: UILabel!
    @IBOutlet weak var logOut: UIButton!
    
    var gradientLayer: CAGradientLayer!

    
    override func viewDidLoad() {
        
        createGradientLayer()
        
        alert.isHidden = true
        logOut.isHidden = true
        
        super.viewDidLoad()
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            
            alert.textColor = UIColor.white
            alert.text = "If you want, you can"
            alert.isHidden = false
            logOut.isHidden = false
            
            login.isHidden = true
            email.isHidden = true
            password.isHidden = true
            go.isHidden =  true
        }
    }
    
    @IBAction func LogOutPressed(_ sender: UIButton) {
        
        do {
            try FirebaseAuth.Auth.auth().signOut()
            
            alert.isHidden = true
            
            login.isHidden = false
            email.isHidden = false
            password.isHidden = false
            go.isHidden =  false
            
            logOut.removeFromSuperview()
        }
        catch {
            
            alert.textColor = UIColor.red
            alert.text = "Something went wrong..."
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            
            email.becomeFirstResponder()
        }
    }
    func createGradientLayer() {
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.locations = [0.3, 1.0]
        gradientLayer.colors = [UIColor.cyan.cgColor, UIColor.darkGray.cgColor]

        self.view.layer.insertSublayer((gradientLayer), at: 0)
    }
    


    @IBAction func GoTapped(_ sender: UIButton) {
        
        guard let email = email.text, !email.isEmpty,
              let password = password.text, !password.isEmpty else {
                  
                  alert.textColor = UIColor.red
                  alert.text = "Please, fill each field!"
                  alert.isHidden = false
                  return
                  
              }
    
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] result, error in
            
            guard let strongSelf = self else {
                
                return
            }
            
            guard error == nil else {
                
                strongSelf.createAnAccount(email: email, password: password)
                return
            }
            
            strongSelf.alert.textColor = UIColor.white
            strongSelf.alert.text = "Welcome back!"
            strongSelf.alert.isHidden = false
            
            strongSelf.login.isHidden = true
            strongSelf.email.isHidden = true
            strongSelf.password.isHidden = true
            strongSelf.go.isHidden =  true
            
            strongSelf.email.resignFirstResponder()
            strongSelf.password.resignFirstResponder()
        })
    }
    
    func createAnAccount(email: String, password: String) {
        
        let alert = UIAlertController(title: "Registration", message: "Would you like to register?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self] result, error in
                
                guard let strongSelf = self else {
                    
                    return
                }
                
                guard error == nil else {
                    
                    strongSelf.alert.textColor = UIColor.red
                    strongSelf.alert.text = "Account creation failed!"
                    strongSelf.alert.isHidden = false
                    
                    strongSelf.login.isHidden = true
                    strongSelf.email.isHidden = true
                    strongSelf.password.isHidden = true
                    strongSelf.go.isHidden =  true
                    
                    return
                }
                
                strongSelf.alert.textColor = UIColor.white
                strongSelf.alert.text = "Welcome!"
                strongSelf.alert.isHidden = false
                
                strongSelf.login.isHidden = true
                strongSelf.email.isHidden = true
                strongSelf.password.isHidden = true
                strongSelf.go.isHidden =  true
                
                strongSelf.email.resignFirstResponder()
                strongSelf.password.resignFirstResponder()
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in}))
        
        present(alert, animated: true)

    }
}
