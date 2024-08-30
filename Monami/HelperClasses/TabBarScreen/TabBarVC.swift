//
//  TabBarVC.swift
//  Tapitt
//
//  Created by Dacall soft on 25/10/17.
//  Copyright © 2017 Dacall soft. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController
{
    
    
    var controllerInstance4 =  UIViewController()
    
    let arrImageNormal : NSArray = ["home_un","home_chat_un","home_notification_un","home__prfl_un"]
    let arrImageSelected : NSArray = ["home_selected","home_chat_se","home_notification_se","home_prfl_se"]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        
        setTabBarSelectedImage(normalArr: arrImageNormal, selectedArr: arrImageSelected)
        
        UITabBar.appearance().barTintColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        
        
        UITabBar.appearance().tintColor = UIColor(red: 231.0/255, green: 122.0/255, blue: 155.0/255, alpha: 1.0)
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.darkGray
        
    }
   
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
    
    }
    
    
    override func viewWillLayoutSubviews()
    {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        var kBarHeight:CGFloat
        if screenHeight == 812 || screenHeight == 896 {
            kBarHeight = 94
        }else{
            kBarHeight = 64
            
        }
        var tabFrame: CGRect = tabBar.frame
        tabFrame.size.height = kBarHeight
        tabFrame.origin.y = view.frame.size.height - kBarHeight
        tabBar.frame = tabFrame
    }
    

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func setTabBarSelectedImage(normalArr: NSArray, selectedArr : NSArray)
    {
        
        for (index, _) in (self.tabBar.items?.enumerated())!
        {
            print(index)
            let tabItem2  = self.tabBar.items![index]
            tabItem2.selectedImage = UIImage(named:selectedArr.object(at: index) as! String )?.withRenderingMode(.alwaysOriginal)
            tabItem2.image=UIImage(named:normalArr.object(at: index) as! String )?.withRenderingMode(.alwaysOriginal)


        }
    }

}
