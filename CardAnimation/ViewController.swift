//
//  ViewController.swift
//  project
//
//  Created by 亚派 on 2017/8/17.
//  Copyright © 2017年 亚派. All rights reserved.
//

import UIKit

let   CCWidth = UIScreen.main.bounds.size.width
let  CCHeight =  UIScreen.main.bounds.size.height


class ViewController: UIViewController,TanTanDataSource,TanTanDelegate {
    
    lazy var   slidingView:Swift_Card = {
        
        let  slidingView = Swift_Card.init(frame:CGRect.init(x: 0, y:  64, width:KScreenWidth, height: KScreenWidth))
        slidingView.CarddataSource = self
        slidingView.Carddelegate = self
        return slidingView
        
    }()
    
    
    func numberOfItemInTanTan(tantan: Swift_Card) -> NSInteger {
        
        return 100
    }
    
    
    func tantan(tantan: Swift_Card, viewForItemAtIndex index: NSInteger) -> CardItemView? {
        
        
        let  item = CardItemView.init(frame: tantan.bounds)
        
        if index % 2 == 0 {
            
            item.showimageView.image = UIImage.init(named:"image_1")
            
        }else{
            item.showimageView.image = UIImage.init(named:"image_2")
            
        }
        
        return item
        
    }
    
    func tantan(tantan: Swift_Card, didRemovedItemAtIndex index: NSInteger,direction:Direction) {
        if direction == .Left {
            print("左划走的是第\(index)个")

        }else{
            
            print("右划走的是第\(index)个")

            
        }
        
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(slidingView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
