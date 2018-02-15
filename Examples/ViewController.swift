//  Copyright (c) 2018 Uppercut
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Christian Floisand on 2018-02-13.
//

import UIKit


class ViewController: UIViewController {
    private var _visiblePopovers: [UCPopoverBubble] = []
    
    
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
        button.topAnchor.constraint(equalTo: button.superview!.topAnchor, constant: 40.0).isActive = true
        
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
        
        lastButton = button
        
        button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Popover with OK button", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(__showPopover(_:)), for: .touchUpInside)
        button.tag = 2
        
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: button.superview!.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: lastButton.bottomAnchor, constant: 8.0).isActive = true
        
        lastButton = button
        
        button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Mini popover with arrow", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(__showPopover(_:)), for: .touchUpInside)
        button.tag = 3
        
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: button.superview!.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: lastButton.bottomAnchor, constant: 8.0).isActive = true
        
        lastButton = button
        
        button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Popover with up arrow and two buttons", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(__showPopover(_:)), for: .touchUpInside)
        button.tag = 4
        
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: button.superview!.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: lastButton.bottomAnchor, constant: 8.0).isActive = true
        
        lastButton = button
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(__dismissPopovers(_:)))
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
        } else if button.tag == 2 {
            popover = UCOkPopover(withText: "This is a popover with an OK button.\nTry pressing it!")
            popover.buttonHandler = { po, index in
                print("Pressed OK")
                po.dismiss(animated: true)
            }
            popover.present(animated: true)
        } else if button.tag == 3 {
            popover = UCPopoverBubble.uc_miniPopover(withText: "Mini popover #1", arrowDirection: .right)
            popover.present(at: CGPoint(x: view.frame.width - 20.0, y: view.center.y), animted: true)
        } else if button.tag == 4 {
            popover = UCPopoverBubble(withText: "There are two buttons on this popover for you to press.\nTry it now!", buttonTitles: ["Button one", "Button two"], arrowDirection: .up)
            popover.font = UIFont(name: "HelveticaNeue-Bold", size: 22.0)!
            popover.buttonFont = UIFont(name: "HelveticaNeue", size: 20.0)
            popover.buttonHandler = { po, index in
                print("Pressed button \(index)")
                po.dismiss(animated: true)
            }
            popover.present(at: CGPoint(x: view.center.x, y: 20.0), animted: true)
        }
        
        _visiblePopovers.append(popover)
    }

    @objc private func __dismissPopovers(_ sender: Any?) {
        _visiblePopovers.forEach { po in
            po.dismiss(animated: true, completion: nil)
        }
        _visiblePopovers.removeAll()
    }
    
}
