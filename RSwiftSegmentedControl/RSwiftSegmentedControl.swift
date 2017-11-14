//
//  RSwiftSegmentedControl.swift
//  RSwiftSegmentedControl
//
//  Created by Somlea Felix-Bogdan on 11/7/17.
//  Copyright © 2017 Somlea Felix-Bogdan. All rights reserved.
//

import UIKit

class RSwiftSegmentedControl: UIView {

    enum SegmentedControlState: Int {
        case normal = 0, selected
    };


    //Public Properties
    public var titles: [String]! = []
    open var defaultStateTextColor: UIColor = .white
    open var defaultStateBackgroundColor: UIColor = .black
    open var selectedStateTextColor: UIColor = .black
    open var selectedStateBackgroundColor: UIColor = .white
    open var defaultFont = UIFont.boldSystemFont(ofSize: 15)
    open var selectedFont = UIFont.boldSystemFont(ofSize: 16)
    open var selectedIndex: Int = 0
    open var spacing: CGFloat = 1
    open var buttonTextSpacing: CGFloat = 40
    open var target: AnyObject?
    open var action: Selector?


    //Private Properties
    private var buttonsSet: NSMutableOrderedSet = NSMutableOrderedSet()
    private var widthSet: NSMutableOrderedSet = NSMutableOrderedSet()
    private var scrollView: UIScrollView = UIScrollView()
    private var buttons: [UIButton] = []


    //Class Initializers
    public init(titles: [String]!) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.titles = titles
        self.setupScrollView()
        self.createSegmentObjects()
        self.selectedIndex = 0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }



    open func set(textColor: UIColor, backgroundColor: UIColor, forState state: SegmentedControlState) {
        if state == .normal {
            self.defaultStateTextColor = textColor
            self.defaultStateBackgroundColor = backgroundColor
        } else if state == .selected {
            self.selectedStateTextColor = textColor
            self.selectedStateBackgroundColor = backgroundColor
        }
    }

    private func setupScrollView() {
        self.scrollView.scrollsToTop = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.frame.size.height)
        self.scrollView.bounces = false
        self.addSubview(self.scrollView)
    }

    private func createSegmentObjects() {
        if self.titles.count < 1 {
            return;
        }
        for (_, element) in self.titles.enumerated() {
            let btn = UIButton(type: .custom)
            btn.setTitle(element, for: .normal)
            self.scrollView.addSubview(btn)
            self.buttons.append(btn)
            btn.backgroundColor = self.defaultStateBackgroundColor
            btn.titleLabel?.textColor = self.defaultStateTextColor
            btn.titleLabel?.font = self.defaultFont
            btn.addTarget(self, action: #selector(self.selectButton), for: .touchUpInside)
            buttonsSet.add(btn)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let selfFrame = self.frame

        if buttonsSet.count == 0 {
            return
        }

        var inset = self.spacing
        var multiplicationFactor: CGFloat = -1
        let fullWidth: CGFloat = self.calculateFullWidth()
        let controlWidth = self.frame.size.width - ((CGFloat(self.titles.count + 1)) * self.spacing)
        if fullWidth < controlWidth {
            multiplicationFactor = controlWidth / fullWidth
            self.scrollView.frame = CGRect(x: 0, y: 0, width: selfFrame.size.width, height: selfFrame.size.height)
            self.scrollView.contentSize = CGSize(width: selfFrame.width, height: selfFrame.height)
        } else {
            self.scrollView.frame = CGRect(x: 0, y: 0, width: selfFrame.size.width, height: selfFrame.size.height)
        }

        for (index, element) in self.buttonsSet.enumerated() {
            let btn = element as! UIButton
            var objFrame = CGRect.zero
            let objSize: CGSize = self.frame(forText: (btn.titleLabel?.text)!, withState: .normal)
            var width = objSize.width
            if (multiplicationFactor > 0) { width = multiplicationFactor * width }
            let height = selfFrame.size.height

            if index == self.selectedIndex {
                btn.setTitleColor(self.selectedStateTextColor, for: .normal)
                btn.backgroundColor = self.selectedStateBackgroundColor
                btn.titleLabel?.font = self.selectedFont
            } else {
                btn.setTitleColor(self.defaultStateTextColor, for: .normal)
                btn.backgroundColor = self.defaultStateBackgroundColor
                btn.titleLabel?.font = self.defaultFont
            }
            objFrame = CGRect(x: inset, y: 0, width: width, height: height)
            inset = inset + width + self.spacing
            btn.frame = objFrame
        }
        self.scrollView.contentSize = CGSize(width: inset, height: selfFrame.size.height)
    }

    private func calculateFullWidth() -> CGFloat {
        var width: CGFloat = 0
        for str in self.titles {
            let size = self.frame(forText: str, withState: .normal)
            width = width + ceil(size.width)
            width = width + 2 * self.spacing
        }
        return ceil(width)
    }

    private func frame(forText text: String, withState controlState: SegmentedControlState) -> CGSize {
        var size: CGSize = CGSize.zero
        if controlState == .normal {
            size = self.getSize(forText: text, withFont: self.defaultFont)
        } else if controlState == .selected {
            size = self.getSize(forText: text, withFont: self.selectedFont)
        }
        return size
    }

    private func getSize(forText text: String!, withFont font: UIFont!) -> CGSize {
        var result = NSString(string: text).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                                                         options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                         attributes: [NSAttributedStringKey.font : font],
                                                         context: nil).size
        result.width = ceil(result.width) + self.buttonTextSpacing;
        result.height = ceil(result.height);
        return result
    }

    private func checkAndScrollToFrameOf(button: UIButton) {
        if self.isVisible(button: button) {
            return
        }
        var btnFrame = CGRect.zero
        if (self.buttonsSet.firstObject as! UIButton) == button || (self.buttonsSet.lastObject as! UIButton) == button {
            btnFrame = button.frame
        } else if (button.frame.origin.x + button.frame.size.width) > self.scrollView.contentOffset.x + self.frame.size.width {
            btnFrame = CGRect(x: button.frame.origin.x, y: button.frame.origin.y, width: button.frame.size.width + 20, height: button.frame.size.height)
        } else if (self.scrollView.contentSize.width - self.frame.size.width > button.frame.origin.x) {
            btnFrame = CGRect(x: button.frame.origin.x - 20, y: button.frame.origin.y, width: button.frame.size.width, height: button.frame.size.height)
        }

        self.scrollView.scrollRectToVisible(btnFrame, animated: true)
    }

    private func isVisible(button: UIButton) -> Bool {
        if (button.frame.origin.x > self.scrollView.contentOffset.x),
            (button.frame.origin.x + button.frame.size.width < self.scrollView.contentOffset.x + self.frame.size.width) {
            return true
        }
        return false
    }

    @objc private func selectButton(sender: UIButton) {
        let selectedIndex = self.buttonsSet.index(of: sender)
        self.selectedIndex = selectedIndex
        self.checkAndScrollToFrameOf(button: sender)
        if self.target != nil,
            self.action != nil {
            if self.target!.responds(to: self.action) {
                let _ = self.target!.perform(self.action!, with: self, afterDelay: 0.0)
            }
        }
        self.setNeedsLayout()
    }

    open func addTarget(target: AnyObject!, action: Selector!) {
        self.target = target
        self.action = action
    }

}
