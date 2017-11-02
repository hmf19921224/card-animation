//
//  Swift_Card.swift
//  project
//
//  Created by 亚派 on 2017/8/10.
//  Copyright © 2017年 亚派. All rights reserved.
//


let kBoundaryRatio:CGFloat   = 0.8
let kSecondCardScale:CGFloat = 0.95
let kTherdCardScale:CGFloat  = 0.9

let kCardEdage:CGFloat = 15.0
let  kContainerEdage:CGFloat   = 15.0
let  kNavigationHeight:CGFloat = 64.0

enum Direction {
    
    case Default
    case Left
    case Right
}


import UIKit

class Swift_Card: UIView {
    
    
    weak var _CarddataSource:TanTanDataSource?

    
    weak var CarddataSource:TanTanDataSource?{
        
        set{
            _CarddataSource = newValue
            refreshData()
            originalLayout()
            
        }
        get{
            
            return _CarddataSource
        }
    }
    
    weak var Carddelegate:TanTanDelegate?
    //原始点
    var CardCenter:CGPoint!
    //储存itme的个数
    //选择的itemindex
    var LoadingIndex: NSInteger = 0
    
    var direction:Direction = .Default
    //复用View
    //展示的view
    var  firstCardFrame = CGRect.zero
    
    var  lastCardFrame = CGRect.zero
    
    var lastCardTransform:CGAffineTransform!
    

    var showmoving:Bool = false
    
    var showItemsNumber:NSInteger = 3
    
    lazy var  defaulttCardViewFrame:CGRect = {
    
    let s_width =  self.frame.width


    let s_height =  self.frame.height

    
    let c_height = s_height - kContainerEdage * 2 - kCardEdage * 2

        return  CGRect.init(x: kContainerEdage, y: (s_height - (c_height + kCardEdage * 2)) / 2, width:  s_width  - kContainerEdage * 2, height: c_height)
    }()
    
    
    
    var numberOfItem:NSInteger = 0
    
    var viewArray:[CardItemView] = []
    
    var canRemoveTopView:Bool = false
    //y轴的距离
    let cardInteritemSpacing: CGFloat = 15

    var xFromCenter:CGFloat = 0.0;
    var yFromCenter:CGFloat = 0.0;
    
    func refreshData(){
        
            if CarddataSource != nil {
                
                let totoalNum = CarddataSource!.numberOfItemInTanTan(tantan: self)
                
                if totoalNum > 0{
                    
                    if totoalNum < showItemsNumber {
                        
                        showItemsNumber = totoalNum;
                    }
                    
                    if  CarddataSource != nil  {
                        
                        for   _  in viewArray.count..<((showmoving ? (showItemsNumber + 1) : showItemsNumber)) {
                            

                        let card = self.CarddataSource?.tantan(tantan: self, viewForItemAtIndex: LoadingIndex)
                            
                            card?._frame = defaulttCardViewFrame

                            if self.LoadingIndex >= 3 {
                                
                                card?.frame = lastCardFrame
                                

                            }else{
                                
                        if  firstCardFrame.isEmpty {
                            
                        firstCardFrame = card!.frame
                        CardCenter = card?.center
                    }
                                
                }
                card!.tag = LoadingIndex

                LoadingIndex+=1

               card!.addGestureRecognizer(addPanGestureRecognizer())
                    self.addSubview(card!)
                  self.sendSubview(toBack: card!)
                  viewArray.append(card!)
             }
        }
                    
       }
    }
}
    func resetVisibleCards(){
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: [.curveEaseInOut,.allowUserInteraction], animations: {
            
           self.originalLayout()
            
        }) { (finished) in
            
        }
   
    }
    
    func originalLayout(){
    
        for  i  in 0..<self.viewArray.count{
            
            let cardView = self.viewArray[i]
            
            var Frame = firstCardFrame
            
            cardView.transform = CGAffineTransform.identity

            switch i{
                
            case 0:
                cardView.frame = Frame;
                break
                
            case 1:
                    Frame.origin.y = firstCardFrame.origin.y + kCardEdage;
                    cardView.frame = Frame

                cardView.transform = CGAffineTransform.identity.scaledBy(x: kSecondCardScale, y: 1)

                break
                
            case 2:
                 Frame.origin.y = firstCardFrame.origin.y + kCardEdage * 2;
                 
                 cardView.frame = Frame
              
                cardView.transform = CGAffineTransform.identity.scaledBy(x: kTherdCardScale, y: 1)
                
                if  self.lastCardFrame.isEmpty {
                    
                    self.lastCardFrame = cardView.frame;
                    self.lastCardTransform = cardView.transform
                }

                break

            default:
                break
            }
        }
    }
    
    func addPanGestureRecognizer()->UIPanGestureRecognizer{
        
     let  panGestureRecognizer = UIPanGestureRecognizer()

         panGestureRecognizer.addTarget(self, action: #selector(self.handlePan(gester:)))
        
        return panGestureRecognizer
    }
    
    func handlePan(gester:UIPanGestureRecognizer){
        
        let card =  gester.view as! CardItemView

        if  gester.state == .began {
            
        }
        if gester.state == .changed {
            let  translation = gester.translation(in: self)//平移获取相对坐标
            

            card.center = CGPoint.init(x: gester.view!.center.x + translation.x, y: gester.view!.center.y + translation.y)
            gester.setTranslation(CGPoint.zero, in: self)
            //旋转了一定的角度
           card.transform = CGAffineTransform.identity.rotated(by:(card.center.x - self.CardCenter.x) / self.CardCenter.x * CGFloat(Double.pi/4 / 12))
            
            let  widthRatio = (card.center.x - self.CardCenter!.x) / self.CardCenter!.x;
//            let  heightRatio = (gester.view!.center.y - self.CardCenter!.y) / self.CardCenter!.y;
            
            judgeMovingState(scale: widthRatio)
            
            if widthRatio > 0 {
            
                self.direction = .Right
            
            } else if  widthRatio < 0 {
                
                self.direction = .Left
                
            } else  {
                
                self.direction = .Default;
            }
        }
        
        if  gester.state == .ended ||  gester.state == .cancelled {
            
            let  widthRatio = (gester.view!.center.x - self.CardCenter.x) / self.CardCenter.x;
            let  moveWidth  = (gester.view!.center.x  - self.CardCenter.x);
            let  moveHeight = (gester.view!.center.y - self.CardCenter.y);
            finishedPanGesture(gesterView: gester.view!, direction: direction, scale:(moveWidth/moveHeight), diappear: fabs(widthRatio) > kBoundaryRatio)
         

        }
        
        card.updateOverlay(distance: gester.view!.center.x-self.CardCenter.x)

    }
    
    
    func finishedPanGesture(gesterView:UIView,  direction:Direction,scale:CGFloat,diappear:Bool){
        
        if !diappear {
          
                if self.showmoving && self.viewArray.count > showItemsNumber{
                   let lastView = self.viewArray.last
                    lastView?.removeFromSuperview()
                    LoadingIndex = lastView!.tag
                    self.viewArray.remove(at: viewArray.index(of: lastView!)!)
                }
            
               showmoving = false
            
              resetVisibleCards()
            
            } else {
            
            /*
             移除屏幕后
             1.删除移除屏幕的cardView
             2.重新布局剩下的cardViews
             */
            let  flag:CGFloat = direction == .Left ? -1.0 : 2.0
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear,.allowUserInteraction], animations: {
                
                gesterView.center = CGPoint.init(x: CCWidth * flag, y: CCWidth * flag / scale + self.CardCenter.y)

            }, completion: { (finished) in
                
                gesterView.removeFromSuperview()

            })
            
            Carddelegate?.tantan(tantan: self, didRemovedItemAtIndex: gesterView.tag + 1, direction:direction)
            
            self.viewArray.remove(at: self.viewArray.index(of: gesterView as! CardItemView)!)
            showmoving = false
           resetVisibleCards()
           
    }
}
    func   judgeMovingState(scale:CGFloat){
        
        if !showmoving {
            
            self.showmoving = true
            
            refreshData()
        } else {
            
            movingVisibleCards(scale: scale)
        }
    }
    /*
     图片在拖移时候的动画
     */
    func movingVisibleCards(scale:CGFloat){
        
        let  scales = fabs(scale) >= kBoundaryRatio ? kBoundaryRatio : fabs(scale)
        let  sPoor = kSecondCardScale - kTherdCardScale; // 相邻两个CardScale差值
        let tPoor = sPoor / (kBoundaryRatio / scales); // transform x值
        
        let yPoor = kCardEdage / (kBoundaryRatio / scales); // frame y差值
        for i  in  1..<self.viewArray.count{
            
           let cardView = self.viewArray[i]
            
            switch i {
                
            case 1:
               cardView.transform = CGAffineTransform.identity.scaledBy(x:tPoor + kSecondCardScale, y: 1)

             cardView.transform = transform.translatedBy(x: 0, y: -yPoor)// 改变frame
                
            break;
                
            case 2:
                
               let  transform = CGAffineTransform.identity.scaledBy(x: (tPoor + kTherdCardScale), y: 1)
                cardView.transform = transform.translatedBy(x: 0, y: -yPoor)// 改变frame
               
               
            break;
            case 3:
                
//                cardView.transform = self.lastCardTransform
                break;
            default:
                break;
            }
    }

}
   
}

protocol TanTanDataSource:NSObjectProtocol {
    
    func numberOfItemInTanTan(tantan:Swift_Card)->NSInteger
    
    func tantan(tantan:Swift_Card,viewForItemAtIndex index:NSInteger)->CardItemView?

    
}
protocol TanTanDelegate:NSObjectProtocol {
    
    func tantan(tantan:Swift_Card, didRemovedItemAtIndex index:NSInteger, direction:Direction)->Void
    
  
    
}



