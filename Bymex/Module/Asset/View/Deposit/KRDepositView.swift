//
//  KRDepositView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/28.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

enum KRDepositType {
    case normal
    case eos
    case usdt
}

class KRDepositView: KRBaseV {
    
    var vType = KRDepositType.normal
    
    //MARK: - lazy
    lazy var headlabel : UILabel = {
        let object = UILabel.init(text: "asset_tips_deposit".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        object.numberOfLines = 0
        return object
    }()
    
    lazy var qrImgV : UIImageView = {
        let object = UIImageView()
        object.backgroundColor = UIColor.white
        return object
    }()
    
    lazy var saveLabel : UILabel = {
        let object = UILabel.init(text: "asset_action_saveQR".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorHighlight, alignment: .center)
        object.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        object.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: {[weak self] recognizer in
            // 保存图片
            self?.qrImgV.image?.saveImageToAlbum()
        }).disposed(by: disposeBag)
        return object
    }()
    
    lazy var addressView : KRDepositInfoView = {
        let object = KRDepositInfoView()
        object.titleLabel.text = "asset_text_walletAddress".localized()
        object.contentLabel.text = "--"
        return object
    }()
    
    lazy var viewBlockBtn : UIButton = {
        let object = UIButton()
        object.setImage(UIImage.themeImageNamed(imageName: "Asset_browser"), for: .normal)
        object.extSetTitle("asset_action_checkBlock".localized(), 14, UIColor.ThemeLabel.colorHighlight, .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            
        }).disposed(by: disposeBag)
        return object
    }()
    
    lazy var memoView : KRDepositInfoView = {
        let object = KRDepositInfoView()
        object.isHidden = true
        object.titleLabel.text = "asset_text_labelMemo".localized()
        object.contentLabel.text = "--"
        return object
    }()
    
    lazy var tipsV : KRTipsInfoView = {
        let object = KRTipsInfoView()
        object.isHidden = true
        object.setContent("asset_tips_labelmemo".localized())
        return object
    }()
    
    lazy var erc20Btn : KRFlatBtn = {
        let object = KRFlatBtn()
        object.extSetTitle("ERC20", 14, UIColor.ThemeLabel.colorHighlight, .selected)
        object.extSetTitle("ERC20", 14, UIColor.ThemeLabel.colorMedium, .normal)
        object.isHidden = true
        return object
    }()
    
    lazy var ominBtn : KRFlatBtn = {
        let object = KRFlatBtn()
        object.extSetTitle("OMNI", 14, UIColor.ThemeLabel.colorHighlight, .selected)
        object.extSetTitle("OMNI", 14, UIColor.ThemeLabel.colorMedium, .normal)
        object.isHidden = true
        return object
    }()
    
    public convenience init(_ type : KRDepositType) {
        self.init()
        self.vType = type
        initSubViewsLayout()
    }
    
    func initSubViewsLayout() {
        layer.cornerRadius = 10
        backgroundColor = UIColor.ThemeTab.bg
        addSubViews([headlabel,qrImgV,saveLabel,addressView,viewBlockBtn,memoView,tipsV,erc20Btn,ominBtn])
        headlabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(20)
        }
        erc20Btn.snp.makeConstraints { (make) in
            make.left.equalTo(headlabel)
            make.top.equalTo(headlabel.snp.bottom).offset(20)
            make.height.equalTo(32)
        }
        ominBtn.snp.makeConstraints { (make) in
            make.right.equalTo(headlabel)
            make.left.equalTo(erc20Btn.snp.right).offset(20)
            make.width.height.top.equalTo(erc20Btn)
        }
        if vType == .usdt {
            erc20Btn.isHidden = false
            ominBtn.isHidden = false
            qrImgV.snp.makeConstraints { (make) in
                make.top.equalTo(erc20Btn.snp.bottom).offset(28)
                make.width.height.equalTo(120)
                make.centerX.equalToSuperview()
            }
        } else {
            qrImgV.snp.makeConstraints { (make) in
                make.top.equalTo(headlabel.snp.bottom).offset(20)
                make.width.height.equalTo(120)
                make.centerX.equalToSuperview()
            }
        }
        saveLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(qrImgV.snp.bottom).offset(8)
            make.left.right.equalTo(headlabel)
        }
        addressView.snp.makeConstraints { (make) in
            make.left.right.equalTo(headlabel)
            make.top.equalTo(saveLabel.snp.bottom).offset(8)
        }
        viewBlockBtn.snp.makeConstraints { (make) in
            make.left.equalTo(headlabel)
            make.top.equalTo(addressView.snp.bottom).offset(24)
            make.height.equalTo(20)
        }
        memoView.snp.makeConstraints { (make) in
            make.right.left.equalTo(headlabel)
            make.top.equalTo(viewBlockBtn.snp.bottom).offset(24)
        }
        tipsV.snp.makeConstraints { (make) in
            make.left.right.equalTo(headlabel)
            make.top.equalTo( memoView.snp.bottom).offset(12)
            make.height.equalTo(36)
            make.bottom.equalToSuperview().offset(-20)
        }
        if vType == .eos {
            memoView.isHidden = false
            tipsV.isHidden = false
            tipsV.snp.remakeConstraints { (make) in
                make.left.right.equalTo(headlabel)
                make.top.equalTo( memoView.snp.bottom).offset(12)
                make.height.equalTo(36)
                make.bottom.equalToSuperview().offset(-20)
            }
        } else {
            viewBlockBtn.snp.remakeConstraints { (make) in
                make.left.equalTo(headlabel)
                make.top.equalTo(addressView.snp.bottom).offset(24)
                make.bottom.equalToSuperview().offset(-20)
            }
        }
    }
}

extension KRDepositView {
    
    func setEntity(_ entity: KRSettlesEntity) {
        headlabel.text = String(format: "asset_tips_deposit".localized(), entity.coin_code)
        qrImgV.image = QRCodeCreate().creteScancode(entity.deposit_address)
        addressView.contentLabel.text = entity.deposit_address
        if entity.coin_group == "USDT" {
            setVType(.usdt)
        } else if entity.coin_group == "EOS" {
            setVType(.eos)
            memoView.contentLabel.text = entity.memo
        } else {
            setVType(.normal)
        }
    }
    
    func setVType(_ type: KRDepositType) {
        vType = type
        if vType == .usdt {
            erc20Btn.isHidden = false
            ominBtn.isHidden = false
            qrImgV.snp.updateConstraints { (make) in
                make.top.equalTo(erc20Btn.snp.bottom).offset(28)
            }
        } else {
            erc20Btn.isHidden = true
            ominBtn.isHidden = true
            qrImgV.snp.remakeConstraints { (make) in
                make.top.equalTo(headlabel.snp.bottom).offset(20)
                make.width.height.equalTo(120)
                make.centerX.equalToSuperview()
            }
        }
        if vType == .eos {
            viewBlockBtn.snp.removeConstraints()
            viewBlockBtn.snp.makeConstraints { (make) in
                make.left.equalTo(headlabel)
                make.top.equalTo(addressView.snp.bottom).offset(24)
                make.height.equalTo(20)
            }
            memoView.isHidden = false
            tipsV.isHidden = false
            tipsV.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(-20)
            }
        } else {
            memoView.isHidden = true
            tipsV.isHidden = true
            viewBlockBtn.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(-20)
            }
        }
    }
}
