//
//  ViewController.swift
//  UCPopoverBubble
//
//  Created by Christian Floisand on 2018-02-13.
//  Copyright © 2018 Uppercut. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    private var _visiblePopover: UCPopoverBubble?
    
    
    override func loadView() {
        let theView = UIView()
        theView.translatesAutoresizingMaskIntoConstraints = true
        theView.frame = UIScreen.main.bounds
        theView.backgroundColor = UIColor.white
        self.view = theView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Basic popover", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(__showPopover(_:)), for: .touchUpInside)
        button.tag = 0
        
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: button.superview!.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: button.superview!.topAnchor, constant: 80.0).isActive = true
        
        var lastButton = button
        
        button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Popover with down arrow", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(__showPopover(_:)), for: .touchUpInside)
        button.tag = 1
        
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: button.superview!.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: lastButton.bottomAnchor, constant: 8.0).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(__dismissPopover(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func __showPopover(_ sender: Any?) {
        let button = sender as! UIButton
        var popover: UCPopoverBubble!
        
        if button.tag == 0 {
            popover = UCPopoverBubble(withText: "Here is some text for the popover!")
            popover.present(animated: true)
        } else if button.tag == 1 {
            popover = UCPopoverBubble(withText: "Look here!", arrowDirection: .down)
            popover.present(at: CGPoint(x: 40.0, y: view.frame.height - 60.0), animted: true)
        }
        
        _visiblePopover = popover
    }

    @objc private func __dismissPopover(_ sender: Any?) {
        _visiblePopover?.dismiss(animated: true)
    }
    
}
