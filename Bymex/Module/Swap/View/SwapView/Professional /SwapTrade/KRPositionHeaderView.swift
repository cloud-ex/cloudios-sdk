//
//  KRPositionHeaderView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

let headerCellWidth = SCREEN_WIDTH - 32

class KRPositionHeaderView: KRBaseV {
    
    typealias PositionHeaderClickBlock = (BTPositionModel) -> ()
    var positionHeaderClickBlock : PositionHeaderClickBlock?
    
    var rowDatas : [BTPositionModel] = []
    lazy var collectionV : UICollectionView = {
        let collectionV = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 144) , collectionViewLayout: getCollectionLayout(width: headerCellWidth))
        collectionV.showsHorizontalScrollIndicator = false
        collectionV.backgroundColor = UIColor.ThemeView.bg
        collectionV.register(KRPositionHeaderCell.classForCoder(), forCellWithReuseIdentifier: "KRPositionHeaderCell")
        collectionV.delegate = self
        collectionV.dataSource = self
        collectionV.backgroundColor = UIColor.ThemeView.bg
        return collectionV
    }()
    
    func getCollectionLayout(width:CGFloat) -> UICollectionViewFlowLayout{
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = 16
        collectionLayout.itemSize = CGSize.init(width: width, height: 144)
        return collectionLayout
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeView.bg
        addSubViews([collectionV])
        collectionV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView(_ arr : [BTPositionModel]){
        if arr.count == 2 {
            collectionV.collectionViewLayout = getCollectionLayout(width: headerCellWidth * 0.8)
        } else {
            collectionV.collectionViewLayout = getCollectionLayout(width: headerCellWidth)
        }
        rowDatas = arr
        collectionV.reloadData()
    }
}

extension KRPositionHeaderView:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : KRPositionHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "KRPositionHeaderCell", for: indexPath) as! KRPositionHeaderCell
        cell.setCell(rowDatas[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? KRPositionHeaderCell,let entity = cell.entity else {
            return
        }
        self.positionHeaderClickBlock?(entity)
    }
}

class KRPositionHeaderCell: UICollectionViewCell {
    
    weak var entity : BTPositionModel?
    
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
    
    lazy var typeLabel : KRSpaceLabel = {
        let object = KRSpaceLabel.init(text: "多头".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemekLine.up, alignment: .center)
        object.textInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        object.extSetCornerRadius(3)
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    
    lazy var open_px : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("持仓均价".localized())
        object.setBottomText("--")
        return object
    }()
    
    lazy var liquidation_px : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.contentAlignment = .right
        object.setTopText("预计强平价".localized())
        object.setBottomText("--")
        return object
    }()
    
    lazy var profitLossRate : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.contentAlignment = .right
        object.setTopText("盈亏率".localized())
        object.setBottomText("--")
        return object
    }()
    
    lazy var profitLossValue : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("未实现盈亏".localized())
        object.setBottomText("--")
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.ThemeTab.bg
        contentView.extSetCornerRadius(4)
        contentView.addSubViews([nameLabel,leverageLabel,typeLabel,open_px,liquidation_px,profitLossRate,profitLossValue])
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview()
            make.height.equalTo(20)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.height.equalTo(typeLabel)
            make.top.equalTo(typeLabel.snp.bottom).offset(10)
            make.width.lessThanOrEqualTo(100)
        }
        leverageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.height.equalTo(14)
            make.centerY.equalTo(nameLabel)
        }
        open_px.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.height.equalTo(34)
        }
        liquidation_px.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.top.width.height.equalTo(open_px)
            make.left.equalTo(open_px.snp.right).offset(10)
        }
        profitLossValue.snp.makeConstraints { (make) in
            make.left.equalTo(open_px)
            make.top.equalTo(open_px.snp.bottom).offset(10)
            make.width.height.equalTo(open_px)
        }
        profitLossRate.snp.makeConstraints { (make) in
            make.right.width.height.equalTo(liquidation_px)
            make.top.equalTo(profitLossValue)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(_ entity: BTPositionModel) {
        self.entity = entity
        if entity.side == .openMore {
            typeLabel.text = "多头"
            typeLabel.textColor = UIColor.ThemekLine.up
        } else {
            typeLabel.text = "空头"
            typeLabel.textColor = UIColor.ThemekLine.down
        }
        nameLabel.text = entity.contractInfo?.symbol ?? "-"
        let typeStr = (entity.position_type == .allType) ? "全仓".localized() : "逐仓".localized()
        leverageLabel.text = typeStr+(entity.avg_fixed_leverage.toDecimalUp(0) ?? "10")+"X"
        open_px.setBottomText(entity.avg_cost_px?.toSmallEditPriceContractID(entity.instrument_id) ?? "0")
        liquidation_px.setBottomText(entity.liquidate_price ?? "0")
        if (entity.unrealised_profit ?? "0").greaterThan(BTZERO) {
            profitLossRate.bottomLabel.textColor = UIColor.ThemekLine.up
            profitLossRate.setBottomText("+" + (entity.repayRate ?? "0").toPercentString(2))
        } else {
            profitLossRate.bottomLabel.textColor = UIColor.ThemekLine.down
            profitLossRate.setBottomText((entity.repayRate ?? "0").toPercentString(2))
        }
        profitLossValue.setBottomText(entity.unrealised_profit?.toSmallValue(withContract:entity.instrument_id) ?? "0" )
    }
}
