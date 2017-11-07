//
//  ViewController.swift
//  RSwiftSegmentedControl
//
//  Created by Somlea Felix-Bogdan on 11/6/17.
//  Copyright © 2017 Somlea Felix-Bogdan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = .red
        let titles = ["ABC", "TEST", "TEST NUMBER 1", "SMALL", "THIS IS THE LOGEST TEST"]
        let scrollView = RSwiftSegmentedControl(titles: titles)
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        self.view.addSubview(scrollView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

