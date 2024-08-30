//
//  ShowImageVC.swift
//  Monami
//
//  Created by abc on 18/12/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit
import SDWebImage


class ShowImageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    //MARK: - Outlets
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var viewImage: UIImageView!
    //MARK: - Variable
    var imageUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }

    /////////////////////////////////////////////////////
    
    // MARK: - Actions, gestures
    

    // TODO: Actions
    
    @IBAction func btnNavigationTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveToGallaryTapped(_ sender: UIButton) {
        downloadImageInGallary()
    }

}

//MARK: - Extension Methods
extension ShowImageVC{
    func initialSetup(){
        viewImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "user_signup"))
        scroll.delegate = self
    }
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    
    func downloadImageInGallary(){
        let yourImageURLString = imageUrl
        
        guard let yourImageURL = URL(string: yourImageURLString) else { return }
        
        getDataFromUrl(url: yourImageURL) { (data, response, error) in
            
            guard let data = data, let imageFromData = UIImage(data: data) else { return }
            
            DispatchQueue.main.async() {
                UIImageWriteToSavedPhotosAlbum(imageFromData, nil, nil, nil)
                self.viewImage.image = imageFromData
                
                let alert = UIAlertController(title: "Saved".localized(), message: "Your image has been saved".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok".localized(), style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
        }
    }

    
}

//MARK: - Scroll view extension
extension ShowImageVC:UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return viewImage
    }
}


