//
//  KRLightPositionView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/17.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  闪电模式下仓位

import Foundation

class KRLightPositionView: KRBaseV {
    
    typealias CancelLightPositionBlock = (BTPositionModel) -> ()
    var cancelLightPositionBlock : CancelLightPositionBlock?
    
    var rowDatas : [BTPositionModel] = []
    
    lazy var collectionV : UICollectionView = {
        let collectionV = UICollectionView.init(frame: CGRect.init(x: 10, y: 0, width: SCREEN_WIDTH - 20, height: 164) , collectionViewLayout: getCollectionLayout(width: SCREEN_WIDTH - 20))
        collectionV.showsHorizontalScrollIndicator = false
        collectionV.backgroundColor = UIColor.ThemeView.bg
        collectionV.register(KRLightPositionCell.classForCoder(), forCellWithReuseIdentifier: "KRLightPositionCell")
        collectionV.delegate = self
        collectionV.dataSource = self
        collectionV.backgroundColor = UIColor.ThemeView.bg
        return collectionV
    }()
    
    func getCollectionLayout(width:CGFloat) -> UICollectionViewFlowLayout{
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = 10
        collectionLayout.itemSize = CGSize.init(width: width, height: 160)
        return collectionLayout
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeView.bg
        addSubViews([collectionV])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView(_ arr : [BTPositionModel]){
        if arr.count == 2 {
            collectionV.collectionViewLayout = getCollectionLayout(width: (SCREEN_WIDTH - 20) * 0.8)
        } else {
            collectionV.collectionViewLayout = getCollectionLayout(width: (SCREEN_WIDTH - 20))
        }
        rowDatas = arr
        collectionV.reloadData()
    }
}

extension KRLightPositionView :UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : KRLightPositionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "KRLightPositionCell", for: indexPath) as! KRLightPositionCell
        cell.setCell(rowDatas[indexPath.row])
        cell.cancelPositionCellBtnBlock = {[weak self] entity in
            self?.cancelLightPositionBlock?(entity)
        }
        return cell
    }
}


class KRLightPositionCell: UICollectionViewCell {
    
    typealias CancelPositionCellBtnBlock = (BTPositionModel) -> ()
    var cancelPositionCellBtnBlock : CancelPositionCellBtnBlock?
    
    weak var entity : BTPositionModel?
    
    lazy var typeLabel : UILabel = { // 仓位类型
        let object = UILabel.init(text: "多头".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .center)
        object.extUseAutoLayout()
        object.backgroundColor = UIColor.ThemeView.seperator
        object.extSetCornerRadius(2)
        return object
    }()
    lazy var nameLabel : UILabel = { // 名字
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.HeadRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        object.extUseAutoLayout()
        return object
    }()
    lazy var leverageLabel : UILabel = { // 杠杆
        let object = UILabel.init(text: "-", font: UIFont.ThemeFont.MinimumRegular, textColor: UIColor.ThemeLabel.colorHighlight, alignment: .center)
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    
    lazy var timeLabel : UILabel = { // 时间
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        object.extUseAutoLayout()
        return object
    }()
    
    lazy var closeBtn : KRFlatBtn = {
        let object = KRFlatBtn()
        object.extSetTitle("闪电平仓".localized(), 12, UIColor.ThemeLabel.colorHighlight, .normal)
        object.color = UIColor.ThemeView.highlight
        object.rx.tap.subscribe(onNext:{ [weak self] in
            guard let position = self?.entity else {
                return
            }
            self?.cancelPositionCellBtnBlock?(position)
        }).disposed(by: disposeBag)
        return object
    }()
    
    lazy var costAvgDetailLabel : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("持仓均价".localized())
        object.setBottomText("--".localized())
        return object
    }()
    
    lazy var closeDetailLabel : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("预估强平价".localized())
        object.setBottomText("--".localized())
        return object
    }()
    lazy var unRealityDetailLabel : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("未实现盈亏")
        object.setBottomText("--")
        return object
    }()
    lazy var profitRateDetailLabel : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("盈亏率")
        object.setBottomText("--")
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.ThemeTab.bg
        extSetCornerRadius(4)
        contentView.addSubViews([typeLabel,nameLabel,leverageLabel,timeLabel,closeBtn,closeDetailLabel,costAvgDetailLabel,unRealityDetailLabel,profitRateDetailLabel])
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(2)
            make.height.equalTo(17)
            make.width.equalTo(30)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.height.equalTo(20)
            make.top.equalTo(typeLabel.snp.bottom).offset(9)
        }
        leverageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(4)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(50)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.height.equalTo(16)
            make.top.equalTo(nameLabel.snp.bottom)
        }
        closeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel.snp.bottom)
            make.height.equalTo(24)
            make.width.equalTo(64)
            make.right.equalToSuperview().offset(-10)
        }
        costAvgDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.height.equalTo(34)
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
        }
        closeDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(costAvgDetailLabel.snp.right).offset(10)
            make.width.height.top.equalTo(costAvgDetailLabel)
            make.right.equalToSuperview().offset(-10)
        }
        unRealityDetailLabel.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(costAvgDetailLabel)
            make.top.equalTo(costAvgDetailLabel.snp.bottom).offset(10)
        }
        profitRateDetailLabel.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(closeDetailLabel)
            make.top.equalTo(closeDetailLabel.snp.bottom).offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setCell(_ position: BTPositionModel) {
        entity = position
        typeLabel.text = (position.side == .openMore) ? "多头".localized() : "空头".localized()
        typeLabel.backgroundColor = (position.side == .openMore) ? UIColor.ThemekLine.up : UIColor.ThemekLine.down
        
        nameLabel.text = position.contractInfo?.symbol ?? "--"
        let typeStr = (position.position_type == .allType) ? "全仓".localized() : "逐仓".localized()
        leverageLabel.text = typeStr+(position.avg_fixed_leverage.toDecimalUp(0) ?? "10")+"X"
        timeLabel.text = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: (position.updated_at ?? "0")), format: "yyyy/MM/dd HH:mm")
        costAvgDetailLabel.setBottomText(position.avg_cost_px.toSmallEditPriceContractID(position.instrument_id) ?? "-")
        closeDetailLabel.setBottomText(position.liquidate_price ?? "-")
        if (position.unrealised_profit ?? "0").greaterThan(BTZERO) {
            unRealityDetailLabel.bottomLabel.textColor = UIColor.ThemekLine.up
            profitRateDetailLabel.bottomLabel.textColor = UIColor.ThemekLine.up
            profitRateDetailLabel.setBottomText("+" + (position.repayRate ?? "0").toPercentString(2))
        } else {
            unRealityDetailLabel.bottomLabel.textColor = UIColor.ThemekLine.down
            profitRateDetailLabel.bottomLabel.textColor = UIColor.ThemekLine.down
            profitRateDetailLabel.setBottomText((position.repayRate ?? "0").toPercentString(2))
        }
        unRealityDetailLabel.setBottomText(position.unrealised_profit ?? "-")
    }
}
