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
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {self.animation()})
 

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var LogoImageView: UIImageView!
    
    
   
    
    
    func animation(){
        
        let animator = UIViewPropertyAnimator(duration: 1.0, curve: .linear)
        
        animator.addAnimations {
            self.LogoImageView.alpha=0
            self.LogoImageView.transform = CGAffineTransform(scaleX: 3, y: 3)
        }
        
        
        animator.addCompletion { end in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier:"TodoListTableViewController") as! TodoListTableViewController
            let NavController = UINavigationController(rootViewController: controller)
//            NavController.navigationBar.barTintColor = UIColor.lightGray
            NavController.modalTransitionStyle = .crossDissolve
            NavController.modalPresentationStyle = .fullScreen
            self.present(NavController, animated: true)
        }


        
        
        
//        let animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 1, options: .curveLinear) {
//            animateWith()
//
//        } completion: { end in
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier:"TodoListTableViewController") as! TodoListTableViewController
//            let NavController = UINavigationController(rootViewController: controller)
//            NavController.navigationBar.barTintColor = UIColor.lightGray
//            NavController.modalTransitionStyle = .crossDissolve
//            NavController.modalPresentationStyle = .fullScreen
//            self.present(NavController, animated: true)
//        }

        
        animator.startAnimation()

    }
}
