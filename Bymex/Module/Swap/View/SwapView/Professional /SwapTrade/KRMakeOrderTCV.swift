//
//  KRMakeOrderTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/13.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift

let proportion_width : CGFloat = 196 / (375 - 32) * (SCREEN_WIDTH - 32)//左边的宽度

class KRMakeOrderTC: UITableViewCell {
    
    let heightSubject : PublishSubject<CGFloat> = PublishSubject()
    
    lazy var makeOrderV : KRSwapMakeOrderView = {
        let object = KRSwapMakeOrderView()
        object.frameChangeBlock = {[weak self] _ in
            guard let mySelf = self else {return}
            mySelf.heightSubject.onNext(mySelf.frame.size.height)
        }
        return object
    }()
    lazy var priceInfoV : KRSwapPriceView = {
        let object = KRSwapPriceView()
        object.clickRightBlock = {[weak self] entity in
            self?.makeOrderV.handleSelectedPrice(entity)
        }
        return object
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.ThemeView.bg
        extSetCell()
        setupSubViewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViewsLayout() {
        addSubViews([makeOrderV,priceInfoV])
        makeOrderV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview()
            make.width.equalTo(proportion_width)
            make.bottom.equalToSuperview().priorityLow()
        }
        priceInfoV.snp.makeConstraints { (make) in
            make.left.equalTo(makeOrderV.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.height.equalTo(makeOrderV)
        }
    }
}
