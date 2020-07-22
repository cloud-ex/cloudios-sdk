//
//  KRSetGoogleView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/23.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSetGoogleView: UIScrollView {
    
    typealias RequestBingResult = (Bool) -> ()
    var requestBingResult : RequestBingResult?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviewsLayout()
        setLayoutData()
        getGoogleData()
        codeView.textFiled.rx.text.orEmpty
        .map{ $0.count > 5}
        .share(replay: 1).subscribe(onNext: {[weak self] (bool) in
            self?.confirmBtn.isEnabled = bool
            }, onError: { (error) in
        }, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutData() {
        
    }
    
    private func setupSubviewsLayout() {
        addSubViews([titleLabel,qrImgV,secretlabel,copyBtn,verifyLabel,codeView,tipsLabel,confirmBtn])
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.top.equalTo(25)
        }
        qrImgV.snp.makeConstraints { (make) in
            make.width.height.equalTo(120)
            make.centerX.equalTo(self)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        secretlabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-20)
            make.top.equalTo(qrImgV.snp.bottom).offset(10)
            make.height.equalTo(18)
        }
        copyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(secretlabel.snp.right).offset(10)
            make.top.height.equalTo(secretlabel)
        }
        verifyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.height.equalTo(20)
            make.top.equalTo(secretlabel.snp.bottom).offset(20)
        }
        codeView.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(35)
            make.top.equalTo(verifyLabel.snp.bottom).offset(20)
        }
        tipsLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(codeView)
            make.top.equalTo(codeView.snp.bottom).offset(80)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(codeView)
            make.top.equalTo(tipsLabel.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
    }
    
    // MARK:-lazy
    lazy var titleLabel : UILabel = {
        let object = UILabel.init(text: "在Google验证器中添加该密匙", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .center)
        object.numberOfLines = 0
        return object
    }()
    
    lazy var qrImgV : UIImageView = {
        let object = UIImageView()
        object.backgroundColor = UIColor.white
        return object
    }()
    
    lazy var secretlabel : UILabel = {
        let object = UILabel.init(text: "FC9MB1myjiEH6fZ4", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .right)
        return object
    }()
    
    lazy var copyBtn : UIButton = {
        let object = UIButton()
        object.extSetTitle("common_tip_copy".localized(), 14, UIColor.ThemeLabel.colorHighlight, .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            
        }).disposed(by: disposeBag)
        return object
    }()
    
    lazy var verifyLabel : UILabel = {
        let object = UILabel.init(text: "谷歌验证码", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    
    lazy var codeView: KRVerifyCodeView = {
        let object = KRVerifyCodeView.init(inputTextNum: 6)
        object.textValueChange = {str in
        }
        object.inputFinish = {[weak self] str in
            self?.senBindGoogle(str)
        }
        return object
    }()
    
    lazy var tipsLabel : UILabel = {
        let object = UILabel.init(text: "密钥可用于手机更换或遗失时找回谷歌验证器，绑定前请妥善保管并备份密钥", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        object.numberOfLines = 0
        return object
    }()
    
    lazy var confirmBtn : EXButton = {
        let object = EXButton()
        object.extUseAutoLayout()
        object.setTitle("绑定".localized(), for: .normal)
        object.setTitleColor(UIColor.ThemeBtn.colorTitle, for: .normal)
        object.isEnabled = false
        object.rx.tap.subscribe(onNext:{ [weak self] in
            self?.senBindGoogle(self?.codeView.textFiled.text ?? "")
        }).disposed(by: disposeBag)
        return object
    }()
    
}

extension KRSetGoogleView {
    
    func senBindGoogle(_ str : String) {
        confirmBtn.showLoading()
        appAPI.rx.request(AppAPIEndPoint.gaKey(action: "add", ga_code: str)).MJObjectMap(NSDictionary.self).subscribe(onSuccess: {[weak self] (result) in
            PublicInfoManager.sharedInstance.accountEntity.ga_key = "bind"
            self?.confirmBtn.hideLoading()
            self?.requestBingResult?(true)
        }) { (error) in
            print(error)
            self.confirmBtn.hideLoading()
        }.disposed(by: self.disposeBag)
        
    }
    
    func getGoogleData() {
        appAPI.rx.request(AppAPIEndPoint.gaKey(action: "query", ga_code: "")).MJObjectMap(KRGoogleEntity.self).subscribe(onSuccess: {[weak self] (result) in
            let sn = KRBasicParameter.getGoogleAuthAlignment(result.login_name, ga_key: result.ga_key)
            self?.secretlabel.text = result.ga_key
            let image = QRCodeCreate().creteScancode(sn)
            self?.qrImgV.image = image
        }) { (error) in
            print(error)
        }.disposed(by: self.disposeBag)
    }
}
