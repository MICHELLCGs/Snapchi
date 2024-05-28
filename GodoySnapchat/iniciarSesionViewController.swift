//
//  iniciarSesionViewController.swift
//  GodoySnapchat
//
//  Created by Belen Godoy on 20/05/24.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class iniciarSesionViewController: UIViewController {
    
    
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var errorMessage: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        print("MICHE:" ,emailTextField.text!, " MIXHE2:" , passwordTextField.text! )
        
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            print("Intentando Iniciar Sesion")
            if error != nil{
                print ("Se presento el siguient error: \(error)")
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion:{(user, error) in print("Intentando crear un usuario")
                    if error != nil{
                    print("Se presentó el siguiente error al crear el usuario: \(error)")
                    }else{
                        print("El usuario fue creado exitosamente")
                        self.performSegue (withIdentifier: "iniciarsesionsegue", sender: nil)
                    }
                })
                
            }else{
                print ("Inicio de sesion exitoso")
                
                self.performSegue (withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
    }
    @IBAction func googleAction(_ sender: Any) {
            Task {
                let success = await signInWithGoogle()
                if success {
                    print("Sign-in successful")
                } else {
                    if let errorMessage = errorMessage {
                        print("Error: \(errorMessage)")
                    }
                }
            }
        }
        
        // Custom error type for authentication errors
        enum AuthenticationError: Error {
            case tokenError(message: String)
        }

        func signInWithGoogle() async -> Bool {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let rootViewController = window.rootViewController else {
                print("No rootViewController")
                return false
            }
            do {
                let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                let user = userAuthentication.user
                guard let idToken = user.idToken else {
                    throw AuthenticationError.tokenError(message: "ID token missing")
                }
                let accessToken = user.accessToken
                let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
                let result  = try await Auth.auth().signIn(with: credential)
                let firebaseUser = result.user
                print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
                return true
            } catch {
                print(error.localizedDescription)
                errorMessage = error.localizedDescription
                return false
            }
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
