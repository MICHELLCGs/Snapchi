//
//  RegistrarseViewController.swift
//  GodoySnapchat
//
//  Created by Kael Dexx on 1/06/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegistrarseViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var buttonregistrarse: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
 
    
    @IBAction func registrarTapped(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print("Se presentó el siguiente error al crear el usuario: \(error)")
            } else {
                print("El usuario fue creado exitosamente")
                Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                
                let alerta = UIAlertController(title: "Creación de Usuario", message: "Usuario: \(self.emailTextField.text!) se creó correctamente.", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default) { (UIAlertAction) in
                    self.performSegue (withIdentifier: "RegistradoSegue", sender: nil)
                }
                alerta.addAction(btnOK)
                self.present(alerta, animated: true, completion: nil)
            }
        }
    }
}
