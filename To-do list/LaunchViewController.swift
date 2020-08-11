//
//  LaunchViewController.swift
//  To-do list
//
//  Created by tantsunsin on 2020/8/10.
//  Copyright © 2020 tantsunsin. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {self.animation()})
 

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var LogoImageView: UIImageView!
    
    func animation(){
//        UIView.animate(withDuration: 1, animations: { //設定動畫時間1秒
//                   let size=self.view.frame.size.width*3 //設定變寬3倍
//                   let diffx=size - self.view.frame.size.width //設定x位置
//                   let diffy=self.view.frame.size.height-size //y位置
//
//                   self.LogoImageView.frame=CGRect(       //更新後imageView的尺寸
//                       x: -(diffx/2),  //使imageView保持在中心
//                       y: diffy/2,   //使imageView保持在中心
//                       width: size,
//                       height: size)
//               })
               
           UIView.animate(withDuration: 0.8, animations: {
                      
           self.LogoImageView.alpha=0
                                           
           },completion: {done in
               if done{
                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let controller = storyboard.instantiateViewController(withIdentifier:"TodoListTableViewController") as! TodoListTableViewController
                    let NavController = UINavigationController(rootViewController: controller)
                NavController.navigationBar.barTintColor = UIColor.lightGray
                   NavController.modalTransitionStyle = .crossDissolve
                   NavController.modalPresentationStyle = .fullScreen
                    self.present(NavController, animated: true)
                   
               }
           })

        
        

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
