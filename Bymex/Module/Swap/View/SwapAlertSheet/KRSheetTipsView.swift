//
//  KRSheetTipsView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/23.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

enum KRTipsDirection {
    case topLeft(_ left : CGFloat,_ top: CGFloat)
    case topRight(_ right : CGFloat,_ top: CGFloat)
    case bottomLeft(_ left : CGFloat,_ bottom: CGFloat)
    case bottomRight(_ right : CGFloat,_ bottom: CGFloat)
}

class KRSheetTipsView: UIView {
    
    lazy var tipsLabel: KRSpaceLabel = {
        let object = KRSpaceLabel.init(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        object.numberOfLines = 0
        object.backgroundColor = UIColor.ThemeView.seperator
        object.textInsets = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        return object
    }()
    lazy var arrowImg : UIImageView = {
        let object = UIImageView()
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([arrowImg,tipsLabel])
        arrowImg.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10).offset(20)
            make.height.equalTo(10)
            make.width.equalTo(20)
        }
        tipsLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(arrowImg.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showTips(_ tips:String, _ direction : KRTipsDirection) {
        tipsLabel.text = tips
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 4
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12),
                          NSAttributedString.Key.paragraphStyle: paraph]
        tipsLabel.attributedText = NSAttributedString(string: tips, attributes: attributes)
        switch direction {
        case .topLeft(let left,let top):
            arrowImg.image = UIImage.themeImageNamed(imageName: "swap_arrow_up")
            arrowImg.snp.remakeConstraints { (make) in
                make.left.equalTo(left)
                make.top.equalToSuperview().offset(top)
                make.height.equalTo(6)
                make.width.equalTo(12)
            }
            tipsLabel.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(arrowImg.snp.bottom)
            }
            break
        case .topRight(let right,let top):
            arrowImg.image = UIImage.themeImageNamed(imageName: "swap_arrow_up")
            arrowImg.snp.remakeConstraints { (make) in
                make.right.equalTo(-right)
                make.top.equalToSuperview().offset(top)
                make.height.equalTo(6)
                make.width.equalTo(12)
            }
            tipsLabel.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(arrowImg.snp.bottom)
            }
            break
        case .bottomLeft(let left,let bottom):
            arrowImg.image = UIImage.themeImageNamed(imageName: "swap_arrow_down")
            arrowImg.snp.remakeConstraints { (make) in
                make.left.equalTo(left)
                make.bottom.equalTo(-bottom).offset(-20)
                make.height.equalTo(6)
                make.width.equalTo(12)
            }
            tipsLabel.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(arrowImg.snp.top)
            }
            break
        case .bottomRight(let right,let bottom):
            arrowImg.image = UIImage.themeImageNamed(imageName: "swap_arrow_down")
            arrowImg.snp.remakeConstraints { (make) in
                make.right.equalTo(-right)
                make.bottom.equalToSuperview().offset(-bottom)
                make.height.equalTo(6)
                make.width.equalTo(12)
            }
            tipsLabel.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(arrowImg.snp.top)
            }
            break
        }
    }
    
    func addTap() {
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        self.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: {[weak self] recognizer in
            self?.isHidden = true
        }).disposed(by: disposeBag)
    }
}
