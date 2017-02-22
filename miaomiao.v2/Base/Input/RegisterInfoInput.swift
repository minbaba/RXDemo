//
//  RegisterInfoInput.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/6/2.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift

class RegisterInfoInput: UIView {

    @IBOutlet var pickerView: UIView!
    @IBOutlet weak var picker: UIDatePicker!
    
    @IBOutlet var feelingView: UIView!
    @IBOutlet weak var singleButton: UIButton!
    @IBOutlet weak var lovingButton: UIButton!
    @IBOutlet weak var marriedButton: UIButton!
    
    var currentIndex: Int! {
        didSet {
            
            let buttons = [singleButton, lovingButton, marriedButton]
            for ind in 0..<buttons.count {
                let button = buttons[ind]
                button.selected = ind == currentIndex
                button.mq_setBorderColor(ColorConf.Text.SecondTextColor.toColor() , width: (ind == currentIndex) ? 0: 0.5)
            }
            rx_feelingStatus.onNext(currentIndex + 1)
        }
    }
    
    var rx_feelingStatus = PublishSubject<Int>()
    
    
    dynamic var currentDate: NSDate! {
        didSet {
            
            self.picker.setDate(currentDate, animated: false)
        }
    }
    
    
    
    
    
    let disposeBag = DisposeBag()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        NSBundle.mainBundle().loadNibNamed("RegisterInfoInput", owner: self, options: nil)
        
        self.pickerView.frame = self.bounds
        self.addSubview(pickerView)
        self.picker.maximumDate = NSDate()
        
        picker.rx_date.distinctUntilChanged().subscribeNext {[weak self] (date) in
            self?.currentDate = date
        }.addDisposableTo(disposeBag)
        
        
        self.feelingView.frame = self.bounds
        self.addSubview(feelingView)
        
        let buttons = [singleButton, lovingButton, marriedButton]
        for button in buttons {
            button.mq_setCornerRadius(2.5)
            button.setBackgroundImage(UIImage.colorImage(color: ColorConf.Text.SelectedBlue.toColor()), forState: .Selected)
            button.setBackgroundImage(UIImage.colorImage(color: ColorConf.Text.White.toColor()), forState: .Normal)
        }
        
        mqRxBindButton(singleButton, lovingButton, marriedButton).subscribeNext {[weak self] (index) in
            self?.currentIndex = index
        }.addDisposableTo(disposeBag)
        
        
    }
    
    func show(index: Int) {
        bringSubviewToFront([pickerView, feelingView][index])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
