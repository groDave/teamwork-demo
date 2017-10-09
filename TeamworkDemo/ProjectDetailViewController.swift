//
//  ProjectDetailViewController.swift
//  TeamworkDemo
//
//  Created by Dave Hannan on 09/10/2017.
//  Copyright © 2017 Gro. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UIViewController {
    
    var twProject : TWProject?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = twProject?.name
        self.view.backgroundColor = UIColor.hexToUIColor(hex: "#26282f")
        navigationController?.navigationBar.isTranslucent = false
        
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupViews()
    {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
