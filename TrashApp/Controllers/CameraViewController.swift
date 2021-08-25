//
//  CameraViewController.swift
//  TrashApp
//
//  Created by Paratthakorn Sribunyong on 25/8/2564 BE.
//

import UIKit

class CameraViewController: UIViewController {

    
    private var targetImageView = UIImageView()
    var picker = UIImagePickerController()
    private var manager: ImageManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .red
        picker.delegate = self
        openCamera()
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        } else {
            let alertController: UIAlertController = {
                let controller = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { [weak self](_) in
                    self?.navigationController?.popViewController(animated: true)
                }
                controller.addAction(action)
                return controller
            }()
            present(alertController, animated: true)
        }
    }
        

}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[UIImagePickerController.InfoKey.originalImage] != nil, let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            targetImageView.image = originalImage
            self.manager?.uploadImage(data: (self.targetImageView.image?.pngData())!, completionHandler: { (response) in
                if !response.path.isEmpty {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Image", message: "Uploaded successfully", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true)
                    }
                }
            })
        }
        
        
        dismiss(animated: true, completion: nil)
    }
}
