//
//  KROrderDrawerVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/24.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KROrderDrawerVc: KRNavCustomVC {
    
    typealias ComfirmOrderDrawerBlock = (BTContractOrderWay,KRSwapTransactionStatus) -> ()
    var comfirmOrderDrawerBlock : ComfirmOrderDrawerBlock?
    
    var sectionDataSource : [KRDrawerSiftSecEntity] = []
    
    var drawerVArr : [KROrderDrawerV] = []
    
    var orderWay : BTContractOrderWay = .unkown
    var status : KRSwapTransactionStatus = .allTypes
    
    lazy var resetBtn : KRFrameBtn = {
        let object = KRFrameBtn()
        object.extSetTitle("重置".localized(), 14, UIColor.ThemeLabel.colorHighlight, .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            guard let mySelf = self else { return }
            mySelf.orderWay = .unkown
            mySelf.status = .allTypes
            mySelf.configDrawerVc()
        }).disposed(by: disposeBag)
        return object
    }()
    
    lazy var comfirmBtn : EXButton = {
        let object = EXButton()
        object.setTitle("common_text_btnComfirm".localized(), for: .normal)
        object.setTitleColor(UIColor.ThemeBtn.colorTitle, for: .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            guard let mySelf = self else { return }
            mySelf.comfirmOrderDrawerBlock?(mySelf.orderWay,mySelf.status)
            mySelf.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navCustomView.isHidden = true
        view.backgroundColor = UIColor.ThemeTab.bg
        contentView.backgroundColor = UIColor.ThemeTab.bg
        sectionDataSource = PublicInfoEntity.sharedInstance.getSwapOrdersDrawerEntitys()
        handleDrawerViews()
        handlePositiveBtn()
        configDrawerVc()
    }
    
    // 初始化设置
    func configDrawerVc() {
        let section = self.orderWay.rawValue
        let drawerV = drawerVArr[0]
        drawerV.selectedItem(drawerV.itemsArr[section])
        
        let section1 = self.status.rawValue
        let drawerV1 = drawerVArr[1]
        drawerV1.selectedItem(drawerV1.itemsArr[section1])
    }
}

extension KROrderDrawerVc {
    func handleDrawerViews() {
        for i in 0..<sectionDataSource.count {
            let entity = sectionDataSource[i]
            let drawerV = KROrderDrawerV.init(frame: CGRect.init(x: 0, y: CGFloat(i * 144) + NAV_SCREEN_HEIGHT - 30, width: self.view.width, height: 144), entity)
            drawerV.tag = i
            view.addSubview(drawerV)
            drawerVArr.append(drawerV)
            drawerV.clickDrawerBtnBlock = {[weak self] tag in
                if drawerV.tag == 0 {
                    self?.orderWay = BTContractOrderWay.init(rawValue:tag) ?? .unkown
                } else if drawerV.tag == 1 {
                    self?.status = KRSwapTransactionStatus.init(rawValue:tag) ?? .allTypes
                }
            }
        }
    }
    
    func handlePositiveBtn() {
        contentView.addSubViews([resetBtn,comfirmBtn])
        resetBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-38)
        }
        comfirmBtn.snp.makeConstraints { (make) in
            make.left.equalTo(resetBtn.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
            make.width.height.bottom.equalTo(resetBtn)
        }
    }
}

// MARK: - KROrderDrawerV
class KROrderDrawerV : KRBaseV {
    
    typealias ClickDrawerBtnBlock = (Int) -> ()
    var clickDrawerBtnBlock : ClickDrawerBtnBlock?
    
    var entity : KRDrawerSiftSecEntity = KRDrawerSiftSecEntity()
    
    var itemsArr : [KRFlatBtn] = []
    
    var btnW : CGFloat = 0
    
    var btnH : CGFloat = 32
    
    var spaceW : CGFloat = 0
    
    var spaceH : CGFloat = 0
    
    public convenience init(frame: CGRect,_ data : KRDrawerSiftSecEntity) {
        self.init(frame: frame)
        entity = data
        titleLabel.text = entity.title
        btnW = (SCREEN_WIDTH * CGFloat(300.0/375.0) - CGFloat(MarginSpace)) / 3.0 - CGFloat(MarginSpace)
        spaceW = btnW + CGFloat(MarginSpace)
        spaceH = btnH + CGFloat(MarginSpace)
        handleSubViewsBtns()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.ThemeTab.bg
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel : UILabel = {
        let object = UILabel.init(text: "", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        object.frame = CGRect.init(x: CGFloat(MarginSpace), y: CGFloat(MarginSpace), width: 100, height: 16)
        return object
    }()
    
    func handleSubViewsBtns() {
        for i in 0..<entity.content.count {
            let rowItem = entity.content[i]
            let object = KRFlatBtn()
            object.extSetTitle(rowItem.name, 14, UIColor.ThemeLabel.colorHighlight, .selected)
            object.extSetTitle(rowItem.name, 14, UIColor.ThemeLabel.colorMedium, .normal)
            object.tag = i
            object.isSelected = rowItem.isSelect
            addSubview(object)
            itemsArr.append(object)
            let ver = i % 3
            let row  = i / 3
            object.frame = CGRect.init(x: CGFloat(ver) * spaceW + CGFloat(MarginSpace), y: CGFloat(row) * spaceH + CGFloat(MarginSpace) * 3, width: btnW, height: btnH)
            object.extSetAddTarget(self, #selector(selectedItem))
        }
    }
    
    @objc func selectedItem(_ sender : KRFlatBtn) {
        sender.isSelected = true
        clickDrawerBtnBlock?(sender.tag)
        for itemBtn in itemsArr {
            if itemBtn != sender {
                itemBtn.isSelected = false
            }
        }
    }
}
