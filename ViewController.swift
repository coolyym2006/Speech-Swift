//
//  ViewController.swift
//  Speech-Swift
//
//  Created by coolyym on 2016/11/16.
//  Copyright © 2016年 sooyie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        let noteView =   NoteBackGround.NoteBackGroundInstandce()
        
        noteView.frame = CGRect(x:20,y:20,width:view.frame.width-40,height:view.bounds.height-40)
    
    
        view.addSubview(noteView)
      
    }

 

}

