//
//  GradientView.swift
//  Monami
//
//  Created by abc on 20/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit
@IBDesignable
class GradientViewUpToDown: UIView {
    
    @IBInspectable var FirstColor:UIColor = UIColor.clear{
        didSet{
           updateView()
        }
    }
    
    @IBInspectable var SecondColor:UIColor = UIColor.clear{
        didSet{
            updateView()
        }
    }
    
    
    override class var layerClass: AnyClass{
        get{
            return CAGradientLayer.self
        }
    }
    
    func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor,SecondColor.cgColor]
    }
    
    
}
