//
//  ImagenViewController.swift
//  GodoySnapchat
//
//  Created by Michell Condori on 27/05/24.
//

import UIKit
import FirebaseStorage

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var imagePicker = UIImagePickerController()
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present (imagePicker, animated: true, completion: nil)
    }
    @IBAction func descripcionTextField(_ sender: Any) {
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        performSegue(withIdentifier: "seleccionarContactoSegue", sender: nil)
    }
    
    
    @IBOutlet weak var elegirContactoBoton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            let imagenesFolder = Storage.storage ().reference().child("imagenes")

            let imagenData = imageView.image?.jpegData (compressionQuality: 0.50)

            imagenesFolder.child("imagenes.jpg").putData(imagenData!,metadata:

                                                            nil) { (metadata, error) in

                if error != nil {

                    print ("Ocurrio un error al subir imagen: \(error) ")

                }

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
}
