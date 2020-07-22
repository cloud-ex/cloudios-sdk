//
//  KRWithdrawV.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/1.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRWithdrawV: KRBaseV {
    
    var vType = KRWithdrawType.normal
    
    var inputTopH = 20.0
    
    lazy var erc20Btn : KRFlatBtn = {
        let object = KRFlatBtn()
        object.extSetTitle("ERC20", 14, UIColor.ThemeLabel.colorHighlight, .selected)
        object.extSetTitle("ERC20", 14, UIColor.ThemeLabel.colorMedium, .normal)
        object.isHidden = true
        object.isSelected = true
        return object
    }()
    
    lazy var ominBtn : KRFlatBtn = {
        let object = KRFlatBtn()
        object.extSetTitle("OMNI", 14, UIColor.ThemeLabel.colorHighlight, .selected)
        object.extSetTitle("OMNI", 14, UIColor.ThemeLabel.colorMedium, .normal)
        object.isHidden = true
        return object
    }()
    
    lazy var addressInput : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .endBtn)
        object.titleLabel.text = "提现地址".localized()
        object.setPlaceHolder(placeHolder: "请输入或粘贴地址".localized())
        object.endBtn.extSetImages([UIImage.themeImageNamed(imageName: "withdraw_scan")], controlStates: [.normal])
        object.endBtn.rx.tap.subscribe(onNext:{ [weak self] in
            
        }).disposed(by: disposeBag)
        return object
    }()
    
    lazy var memoInput : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .endBtn)
        object.titleLabel.text = "memo标签".localized()
        object.setPlaceHolder(placeHolder: "请输入或粘贴标签".localized())
        object.endBtn.extSetImages([UIImage.themeImageNamed(imageName: "withdraw_scan")], controlStates: [.normal])
        object.endBtn.rx.tap.subscribe(onNext:{ [weak self] in
            
        }).disposed(by: disposeBag)
        object.isHidden = true
        return object
    }()
    
    lazy var volumeInput : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .endBtn)
        object.titleLabel.text = "提现数量".localized()
        object.setPlaceHolder(placeHolder: "请输入提现数量".localized())
        object.endBtn.extSetTitle("全部", 14, UIColor.ThemeLabel.colorHighlight, .normal)
        object.endBtn.rx.tap.subscribe(onNext:{ [weak self] in
            
        }).disposed(by: disposeBag)
        return object
    }()
    
    lazy var balanceLabel : UILabel = {
        let object = UILabel.init(text: "余额：0.00USDT", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    
    lazy var assetPwdInput : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .endBtn)
        object.titleLabel.text = "资金密码".localized()
        object.setPlaceHolder(placeHolder: "请输入六位资金密码".localized())
        return object
    }()
    
    
    public convenience init(_ type : KRWithdrawType) {
        self.init()
        self.vType = type
        initSubViewsLayout()
    }
}

extension KRWithdrawV {
    func initSubViewsLayout() {
        backgroundColor = UIColor.ThemeTab.bg
        layer.cornerRadius = 10
        addSubViews([erc20Btn,ominBtn,addressInput,memoInput,volumeInput,balanceLabel,assetPwdInput])
        if vType == .usdt {
            inputTopH = 72.0
            erc20Btn.isHidden = false
            ominBtn.isHidden = false
            erc20Btn.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(16)
                make.top.equalToSuperview().offset(20)
                make.height.equalTo(32)
            }
            ominBtn.snp.makeConstraints { (make) in
                make.left.equalTo(erc20Btn.snp.right).offset(10)
                make.right.equalToSuperview().offset(-16)
                make.top.width.height.equalTo(erc20Btn)
            }
        }
        addressInput.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(56)
            make.top.equalToSuperview().offset(inputTopH)
        }
        
        if vType == .eos {
            memoInput.isHidden = false
            memoInput.snp.makeConstraints { (make) in
                make.top.equalTo(addressInput.snp.bottom).offset(20)
                make.left.right.height.equalTo(addressInput)
            }
            volumeInput.snp.makeConstraints { (make) in
                make.top.equalTo(memoInput.snp.bottom).offset(20)
                make.left.right.height.equalTo(addressInput)
            }
        } else {
            volumeInput.snp.makeConstraints { (make) in
                make.top.equalTo(addressInput.snp.bottom).offset(20)
                make.left.right.height.equalTo(addressInput)
            }
        }
        balanceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressInput)
            make.top.equalTo(volumeInput.snp.bottom).offset(5)
            make.height.equalTo(16)
        }
        assetPwdInput.snp.makeConstraints { (make) in
            make.top.equalTo(balanceLabel.snp.bottom).offset(20)
            make.left.right.height.equalTo(addressInput)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func setType(_ type : KRWithdrawType) {
        if type == .usdt {
            erc20Btn.isHidden = true
            ominBtn.isHidden = true
            inputTopH = 72.0
        } else {
            erc20Btn.isHidden = false
            ominBtn.isHidden = false
            inputTopH = 20.0
        }
        addressInput.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(inputTopH)
        }
        if type == .eos {
            memoInput.isHidden = false
            volumeInput.snp.updateConstraints { (make) in
                make.top.equalTo(memoInput.snp.bottom).offset(20)
            }
        } else {
            memoInput.isHidden = true
            volumeInput.snp.updateConstraints { (make) in
                make.top.equalTo(addressInput.snp.bottom).offset(20)
            }
        }
    }
}

class KRWithdrawBottomV: KRBaseV {
    lazy var feeResult : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("矿工手续费".localized())
        object.setRightText("0.00USDT".localized())
        return object
    }()
    
    lazy var realityGet : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("实际到账".localized())
        object.setRightText("0.00USDT".localized())
        return object
    }()
    
    override func setupSubViewsLayout() {
        backgroundColor = UIColor.ThemeTab.bg
        layer.cornerRadius = 10
        addSubViews([feeResult,realityGet])
        feeResult.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.height.equalTo(40)
        }
        realityGet.snp.makeConstraints { (make) in
            make.top.equalTo(feeResult.snp.bottom)
            make.left.right.equalTo(feeResult)
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    func setView(_ fee:String, feeUnit:String, _ getVolume: String,volumeUnit:String) {
        feeResult.setRightText(fee + " " + feeUnit)
        realityGet.setRightText(getVolume + " " + volumeUnit)
    }
}
