//
//  iniciarSesionViewController.swift
//  GodoySnapchat
//
//  Created by Belen Godoy on 20/05/24.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase

class iniciarSesionViewController: UIViewController {
    
    
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var btnregistro: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func btnRegistroTapped(_ sender: Any) {
        performSegue(withIdentifier: "RegistrarseSegue", sender: nil)
        }
    var errorMessage: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    if let error = error {
                        print("Error al iniciar sesión: \(error.localizedDescription)")
                        
                        let alerta = UIAlertController(title: "Error de inicio de sesión", message: "El usuario no existe. ¿Desea crear una cuenta?", preferredStyle: .alert)
                        let btnCrear = UIAlertAction(title: "Crear", style: .default) { (UIAlertAction) in
                            self.performSegue(withIdentifier: "RegistrarseSegue", sender: nil)
                        }
                        let btnCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                        
                        alerta.addAction(btnCrear)
                        alerta.addAction(btnCancelar)
                        
                        self.present(alerta, animated: true, completion: nil)
                    } else {
                        print("Inicio de sesión exitoso")
                        self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
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
