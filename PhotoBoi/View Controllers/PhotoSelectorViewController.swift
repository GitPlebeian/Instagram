//
//  PhotoSelectorViewController.swift
//  PhotoBoi
//
//  Created by Jackson Tubbs on 8/28/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

protocol PhotoSelectorViewControllerDelegate: class {
    func photoSelectorViewControllerSelected(image: UIImage)
}

class PhotoSelectorViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var selectedPhotoImageView: UIImageView!
    
    // MARK: - Properties
    
    weak var delegate: PhotoSelectorViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        selectedPhotoImageView.image = nil
    }
    
    // MARK: - Actions
    
    @IBAction func selectImageButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
} // End Of Class

// MARK: - Extensions

extension PhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedPhotoImageView.image = pickedImage
            delegate?.photoSelectorViewControllerSelected(image: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
