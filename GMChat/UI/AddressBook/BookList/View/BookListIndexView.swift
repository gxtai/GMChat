//
//  BookListIndexView.swift
//  GMChat
//
//  Created by GXT on 2019/6/21.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
import AudioToolbox

protocol BookListIndexViewDelegate: NSObjectProtocol {
    func touchTheChactor(index: Int, lastIndex: Int, charactor: String)
}

class BookListIndexView: UIView {
    
    let labH: CGFloat = 16.0
    let labW: CGFloat = 20.0
    let topDis: CGFloat = 10.0
    let bottomDis: CGFloat = 10.0
    var lastIndex = 0
    weak var delegate: BookListIndexViewDelegate?
    
    
    var charactorsArray: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func reloadIndex(charactorsArray: [String]) {
        
        self.charactorsArray = charactorsArray
        self.charactorsArray.insert("🔍", at: 0)
        let h = labH * CGFloat(self.charactorsArray.count) + topDis + bottomDis
        let y = (SCREEN_HEIGHT - kTopHeight - kTabBarHeight - h) / 2.0
        self.frame = CGRect(x: SCREEN_WIDTH - labW, y: y + kTopHeight, width: labW, height: h)
        
        setupViews()
    }
    
    func setupViews() {
        
        _ = subviews.map {
            $0.removeFromSuperview()
        }
        
        backgroundColor = UIColor.withRGBA(0, 0, 0, 0)
        
        popLab.snp_remakeConstraints { (make) in
            make.right.equalTo(self.snp_left).offset(0)
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.centerY.equalTo(self.snp_top).offset(0)
        }
        
        cornerBgView.snp_remakeConstraints { (make) in
            make.size.equalTo(CGSize(width: 10, height: 10))
            make.centerX.equalTo(self.snp_centerX).offset(0)
            make.centerY.equalTo(self.snp_top).offset(0)
        }
        
        for index in 0..<charactorsArray.count {
            let lab = UILabel()
            lab.text = charactorsArray[index]
            lab.font = FONT_Medium(8)
            lab.textColor = UIColor.withHex(hexString: "#333333")
            lab.tag = index + 1000
            lab.textAlignment = .center
            addSubview(lab)
            lab.snp_makeConstraints { (make) in
                make.top.equalTo(labH * CGFloat(index) + topDis)
                make.left.right.equalTo(0)
                make.height.equalTo(labH)
            }
        }
    }
    
    lazy var popLab: UILabel = {
        let popLab = UILabel()
        popLab.textColor = .white
        popLab.font = FONT_Medium(24)
        popLab.backgroundColor = UIColor.withRGBA(0, 0, 0, 0.5)
        popLab.layer.cornerRadius = 18
        popLab.layer.masksToBounds = true
        popLab.textAlignment = .center
        popLab.isHidden = true
        addSubview(popLab)
        return popLab
    }()
    
    lazy var cornerBgView: UIView = {
        let cornerBgView = UIView()
        cornerBgView.backgroundColor = UIColor.withHex(hexString: "#4a4c5b")
        cornerBgView.layer.cornerRadius = 5
        cornerBgView.isHidden = true
        addSubview(cornerBgView)
        return cornerBgView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BookListIndexView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dealTouch(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        dealTouch(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.popLab.alpha = 0
        }) { (_) in
            self.popLab.isHidden = true
        }
    }
    
    func dealTouch(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchView = touches.first else { return }
        
        let point = touchView.location(in: self)
        
        let index = Int(point.y / self.height * CGFloat(charactorsArray.count))
        
        if index > charactorsArray.count - 1 || index < 0 { return }

        let ch = charactorsArray[index]
        
        if lastIndex == index { return }
        
        AudioServicesPlaySystemSound(1519)
        
        delegate?.touchTheChactor(index: index, lastIndex: lastIndex,charactor: ch)
        
        let lastSelectedLab: UILabel = viewWithTag(1000 + lastIndex) as! UILabel
        lastSelectedLab.textColor = UIColor.withHex(hexString: "#333333")

        if index == 0 {
            popLab.isHidden = true
            cornerBgView.isHidden = true
            return
        }
        
        let selectedLab: UILabel = viewWithTag(1000 + index) as! UILabel
        selectedLab.textColor = .white
        
        lastIndex = index
        
        popLab.isHidden = false
        popLab.text = ch
        cornerBgView.isHidden = false
        
        let centerY = topDis + CGFloat(index) * labH + labH / 2
        popLab.snp_updateConstraints { (make) in
            make.centerY.equalTo(centerY)
        }
        cornerBgView.snp_updateConstraints { (make) in
            make.centerY.equalTo(centerY)
        }
        
        self.popLab.alpha = 1
        
    }
    
    
    func changeTheIndex(currentSelectedIndex: Int, lastSelectedIndex: Int) {
        
        let lastSelectedLab: UILabel = viewWithTag(1000 + lastSelectedIndex) as! UILabel
        lastSelectedLab.textColor = UIColor.withHex(hexString: "#333333")
        
        if currentSelectedIndex == 0 {
            cornerBgView.isHidden = true
            return
        }
        
        let selectedLab: UILabel = viewWithTag(1000 + currentSelectedIndex) as! UILabel
        selectedLab.textColor = .white
        
        lastIndex = currentSelectedIndex
        
        let centerY = topDis + CGFloat(currentSelectedIndex) * labH + labH / 2
        
        cornerBgView.snp_updateConstraints { (make) in
            make.centerY.equalTo(centerY)
        }
        
        cornerBgView.isHidden = false
    }
}
