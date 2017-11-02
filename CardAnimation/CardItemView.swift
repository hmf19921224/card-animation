//
//  CardItemView.swift
//  project
//
//  Created by 亚派 on 2017/8/10.
//  Copyright © 2017年 亚派. All rights reserved.
//

import UIKit




let  KScreenWidth = UIScreen.main.bounds.size.width
let KScreenHeight = UIScreen.main.bounds.size.height


class CardItemView: UIView {

    
    var overlyImage :UIImageView = {
        
        let image =  UIImageView()
        image.layer.cornerRadius = 10
        image.contentMode = .scaleToFill
        
        return image
        
    }()
    
    var showimageView:UIImageView = {
        
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.isUserInteractionEnabled = true
        image.layer.masksToBounds = true
        
        return image
        
    }()

    var  _frame:CGRect{
        
        set{
            self.showimageView.frame = CGRect.init(x: 0, y: 0, width: newValue.size.width, height: newValue.size.height-20)
            
           overlyImage.frame =   CGRect.init(x: 0, y: 0, width: newValue.size.width, height: newValue.size.height-20)
                
            overlyImage.alpha = 0

            frame = newValue
            
        }
        
        get{
        
        return frame
        }
        
    }
    
    var model:Direction{
        
        set{
            
            if newValue == .Left {
                
                overlyImage.image = UIImage.init(named: "negativeRed")
                
            }else
            {
                overlyImage.image = UIImage.init(named: "positiveRed")
                
            }
        }
        
        
        get{
            
            return .Default
            
        }
        
    }
    
    
    
    
    /** 偏移量 -100 ～ 0 之间 默认不偏移 越靠近负值 越向下方偏移，并缩小*/
   
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        stupView()
        
        self.addSubview(showimageView)
        
        self.addSubview(overlyImage)
        defaultStyle()

    }
    
    func  stupView(){
        
        backgroundColor = UIColor.white
    
    }
    
    func updateOverlay(distance:CGFloat)
    {
        
    if distance > 0 {
        
    model = .Right
        
    } else {
        
    model = .Left
    }
    
    overlyImage.alpha = min(fabs(distance)/100, 0.4)
        
    
    }
    func defaultStyle() {
    
    self.isUserInteractionEnabled = true
    self.layer.masksToBounds = true
    self.layer.cornerRadius  = 10.0
    self.layer.shouldRasterize = true
    self.layer.rasterizationScale = UIScreen.main.scale
    
    let  scaleBackgroud:CGFloat = 245.0/255.0
    self.backgroundColor = UIColor.init(red: scaleBackgroud, green: scaleBackgroud, blue: scaleBackgroud, alpha: 1)
    
        let scaleBorder:CGFloat = 176.0 / 255.0
        self.layer.borderWidth = 0.45
        self.layer.borderColor = UIColor.init(red: scaleBorder, green: scaleBorder, blue: scaleBorder, alpha: 1).cgColor
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   

}












