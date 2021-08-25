//
//  ViewController.swift
//  TrashApp
//
//  Created by Paratthakorn Sribunyong on 25/8/2564 BE.
//

import UIKit



class ViewController: UIViewController {

    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var chooseButton: UIButton!
    
    private var targetImageView = UIImageView()
    private var manager: ImageManager?
    
    var picker = UIImagePickerController();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cameraButton.addTarget(self, action: #selector(didTapCamera), for: .touchUpInside)
        chooseButton.addTarget(self, action: #selector(didTapChoose), for: .touchUpInside)
        picker.delegate = self
        
    }
    
    
    @objc private func didTapCamera() {
        let cameraVC = CameraViewController()
        navigationController?.pushViewController(cameraVC, animated: true)
    }
    
    @objc private func didTapChoose() {
        openGallery()
    }
    
    func openGallery(){
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[UIImagePickerController.InfoKey.originalImage] != nil, let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            targetImageView.image = originalImage
            print("Png data : \((self.targetImageView.image?.pngData())!)")
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
