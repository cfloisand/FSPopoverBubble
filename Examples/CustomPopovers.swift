//  Copyright (c) 2018 Flyingsand
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


class FSOkPopover: FSPopoverBubble {
    init(withText text: String) {
        let okButton = UIButton()
        okButton.setTitle("OK", for: .normal)
        okButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 22.0)
        okButton.backgroundColor = UIColor(red: 9.0/255.0, green: 106.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        okButton.widthAnchor.constraint(equalToConstant: 68.0).isActive = true
        okButton.heightAnchor.constraint(equalToConstant: 42.0).isActive = true
        okButton.layer.cornerRadius = 4.0
        
        super.init(withText: text, buttons: [okButton], arrowDirection: .none)
        
        color = UIColor(red: 14.0/255.0, green: 42.0/255.0, blue: 71.0/255.0, alpha: 0.81)
        textFont = UIFont(name: "HelveticaNeue", size: 24.0)!
        dismissesOnTap = false
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FSPopoverBubble {
    class func fs_miniPopover(withText text: String, arrowDirection: FSPopoverArrowDirection) -> FSPopoverBubble {
        let popover = FSPopoverBubble(withText: text, arrowDirection: arrowDirection)
        popover.color = UIColor(red: 114.0/255.0, green: 107.0/255.0, blue: 53.0/255.0, alpha: 0.7)
        popover.textFont = UIFont(name: "HelveticaNeue-Thin", size: 16.0)!
        popover.textColor = UIColor.black
        
        return popover
    }
}

