//
//  KRSwapPositionTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/2.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

let currentPosition = "CurrentPosition"
let historyPosition = "HistoryPosition"

class KRSwapPositionTC: UITableViewCell {
    
    typealias ClickPositionTCBtnBlock = (Int) -> ()
    var clickPositionTCBtnBlock : ClickPositionTCBtnBlock?
    
    typealias ClickShowTipsBlock = (Int) -> ()
    var clickShowTipsBlock : ClickShowTipsBlock?
    
    
    lazy var typeLabel : KRSpaceLabel = { // 仓位类型
        let object = KRSpaceLabel.init(text: "多头仓位".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.white, alignment: .center)
        object.frame = CGRect.init(x: 10, y: 0, width: 30, height: 17)
        object.textInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        object.backgroundColor = UIColor.ThemekLine.up
        object.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 4)
        return object
    }()
    lazy var nameLabel : UILabel = { // 名字
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.HeadRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        object.extUseAutoLayout()
        return object
    }()
    lazy var leverageLabel : UILabel = { // 杠杆
        let object = UILabel.init(text: "-", font: UIFont.ThemeFont.MinimumRegular, textColor: UIColor.ThemeLabel.colorHighlight, alignment: .center)
        object.frame = CGRect.init(x: 0, y: 0, width: 50, height: 16)
        object.backgroundColor = UIColor.ThemeView.seperator
        object.roundCorners(corners: [.bottomRight,.topLeft,.topRight], radius: 4)
        return object
    }()
    lazy var timeLabel : UILabel = { // 时间
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        object.extUseAutoLayout()
        return object
    }()
    lazy var shareBtn : KRFlatBtn = {
        let object = KRFlatBtn()
        object.extSetTitle("分享".localized(), 12, UIColor.ThemeLabel.colorHighlight, .normal)
        object.color = UIColor.ThemeView.highlight
        object.tag = 1000
        object.rx.tap.subscribe(onNext:{ [weak self] in
            self?.clickPositionTCBtnBlock?(object.tag)
        }).disposed(by: disposeBag)
        return object
    }()
    lazy var holdPxDetailLabel : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("持仓均价")
        object.setBottomText("--")
        object.contentAlignment = .left
        return object
    }()
    lazy var closePxDetailLabel : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("预估强平价")
        object.setBottomText("--")
        object.addTapLabel()
        object.clickBottomLabelBlock = {[weak self] in
            self?.clickShowTipsBlock?(2001)
        }
        return object
    }()
    lazy var unRealityDetailLabel : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("未实现盈亏")
        object.setBottomText("--")
        object.addTapLabel()
        object.clickBottomLabelBlock = {[weak self] in
            self?.clickShowTipsBlock?(2002)
        }
        return object
    }()
    lazy var profitRateDetailLabel : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("盈亏率")
        object.setBottomText("--")
        object.addTapLabel()
        object.clickBottomLabelBlock = {[weak self] in
            self?.clickShowTipsBlock?(2003)
        }
        return object
    }()
    lazy var middleLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    lazy var realityLabel : KRHorLabel = {
        let object = KRHorLabel()
        object.setLeftText("已实现盈亏".localized())
        object.addTapLabel()
        object.clickRightLabelBlock = {[weak self] in
            self?.clickShowTipsBlock?(2004)
        }
        return object
    }()
    lazy var holdQtyLabel : KRHorLabel = {
        let object = KRHorLabel()
        object.setLeftText("持仓量".localized())
        return object
    }()
    lazy var depositLabel : KRHorLabel = {
        let object = KRHorLabel()
        object.setLeftText("保证金".localized())
        return object
    }()
    lazy var canCloseLabel : KRHorLabel = {
        let object = KRHorLabel()
        object.setLeftText("可平量".localized())
        return object
    }()
    lazy var profitPxLabel : KRHorLabel = {
        let object = KRHorLabel()
        object.setLeftText("止盈价".localized())
        return object
    }()
    lazy var lossPxLabel : KRHorLabel = {
        let object = KRHorLabel()
        object.setLeftText("止损价".localized())
        return object
    }()
    lazy var bottomLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    lazy var marginBtn : KRFlatBtn = {
        let object = KRFlatBtn()
        object.extSetTitle("调整保证金".localized(), 12, UIColor.ThemeLabel.colorHighlight, .normal)
        object.color = UIColor.ThemeView.highlight
        object.tag = 1001
        object.rx.tap.subscribe(onNext:{ [weak self] in
            self?.clickPositionTCBtnBlock?(object.tag)
        }).disposed(by: disposeBag)
        return object
    }()
    lazy var unrealizedBtn : KRFlatBtn = {
        let object = KRFlatBtn()
        object.extSetTitle("止盈止损".localized(), 12, UIColor.ThemeLabel.colorHighlight, .normal)
        object.color = UIColor.ThemeView.highlight
        object.tag = 1002
        object.rx.tap.subscribe(onNext:{ [weak self] in
            self?.clickPositionTCBtnBlock?(object.tag)
        }).disposed(by: disposeBag)
        return object
    }()
    lazy var depositBtn : KRFlatBtn = {
        let object = KRFlatBtn()
        object.extSetTitle("平仓".localized(), 12, UIColor.ThemeLabel.colorHighlight, .normal)
        object.color = UIColor.ThemeView.highlight
        object.tag = 1003
        object.rx.tap.subscribe(onNext:{ [weak self] in
            self?.clickPositionTCBtnBlock?(object.tag)
        }).disposed(by: disposeBag)
        return object
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.ThemeView.bg
        contentView.backgroundColor = UIColor.ThemeTab.bg
        selectionStyle = .none
        contentView.extSetCornerRadius(5)
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        if reuseIdentifier == currentPosition { // 399 -56 -56 -12
            setupCurrentPositionLayout()
            holdPxDetailLabel.showEqualLabel()
        } else if reuseIdentifier == historyPosition {
            holdPxDetailLabel.setTopText("开仓均价".localized())
            holdPxDetailLabel.bottomLine.isHidden = true
            closePxDetailLabel.setTopText("平仓均价".localized())
            closePxDetailLabel.bottomLine.isHidden = true
            unRealityDetailLabel.setTopText("已实现盈亏".localized())
            unRealityDetailLabel.bottomLine.isHidden = true
            setupHistoryPositionLayout()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCurrentPositionLayout() {
        contentView.addSubViews([typeLabel,nameLabel,leverageLabel,shareBtn,
                                 holdPxDetailLabel,closePxDetailLabel,unRealityDetailLabel,profitRateDetailLabel,
                     middleLine,
                     realityLabel,holdQtyLabel,depositLabel,canCloseLabel,
                     profitPxLabel,lossPxLabel,
                     marginBtn,unrealizedBtn,depositBtn,bottomLine])
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalToSuperview()
            make.height.equalTo(17)
            make.width.lessThanOrEqualTo(50)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(typeLabel.snp.bottom).offset(8)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(150)
        }
        leverageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(4)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(50)
        }
        shareBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(40)
            make.height.equalTo(24)
            make.centerY.equalTo(nameLabel)
        }
        holdPxDetailLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.height.equalTo(34)
        }
        closePxDetailLabel.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(holdPxDetailLabel)
            make.left.equalTo(holdPxDetailLabel.snp.right).offset(15)
            make.right.equalToSuperview().offset(-10)
        }
        unRealityDetailLabel.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(holdPxDetailLabel)
            make.top.equalTo(holdPxDetailLabel.snp.bottom).offset(12)
        }
        profitRateDetailLabel.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(unRealityDetailLabel)
            make.left.equalTo(closePxDetailLabel)
        }
        middleLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(1)
            make.top.equalTo(unRealityDetailLabel.snp.bottom).offset(12)
        }
        realityLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(holdPxDetailLabel)
            make.height.equalTo(16)
            make.top.equalTo(middleLine.snp.bottom).offset(10)
        }
        holdQtyLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(closePxDetailLabel)
            make.height.top.equalTo(realityLabel)
        }
        depositLabel.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(realityLabel)
            make.top.equalTo(realityLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-90)
        }
        canCloseLabel.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(holdQtyLabel)
            make.top.equalTo(holdQtyLabel.snp.bottom).offset(12)
        }
        profitPxLabel.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(depositLabel)
            make.top.equalTo(depositLabel.snp.bottom).offset(12)
        }
        lossPxLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(canCloseLabel)
            make.top.equalTo(canCloseLabel.snp.bottom).offset(12)
        }
        marginBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(32)
            make.bottom.equalToSuperview().offset(-10)
        }
        unrealizedBtn.snp.makeConstraints { (make) in
            make.left.equalTo(marginBtn.snp.right).offset(12)
            make.width.height.top.equalTo(marginBtn)
        }
        depositBtn.snp.makeConstraints { (make) in
            make.width.height.top.equalTo(marginBtn)
            make.left.equalTo(unrealizedBtn.snp.right).offset(12)
            make.right.equalToSuperview().offset(-10)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(middleLine)
            make.bottom.equalTo( marginBtn.snp.top).offset(-10)
        }
    }
    private func setupHistoryPositionLayout() {
        contentView.addSubViews([typeLabel,nameLabel,leverageLabel,timeLabel,
                     holdPxDetailLabel,closePxDetailLabel,unRealityDetailLabel])
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalToSuperview()
            make.height.equalTo(17)
            make.width.lessThanOrEqualTo(50)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(typeLabel.snp.bottom).offset(8)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(150)
        }
        leverageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(4)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(50)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(200)
        }
        holdPxDetailLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.height.equalTo(34)
        }
        closePxDetailLabel.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(holdPxDetailLabel)
            make.left.equalTo(holdPxDetailLabel.snp.right).offset(15)
            make.right.equalToSuperview().offset(-10)
        }
        unRealityDetailLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(holdPxDetailLabel)
            make.top.equalTo(holdPxDetailLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}

extension KRSwapPositionTC {
    func setCell(_ entity: BTPositionModel) {
        var typeStr = "多头".localized()
        var color = UIColor.ThemekLine.up
        if entity.side == .openEmpty {
            typeStr = "空头".localized()
            color = UIColor.ThemekLine.down
        }
        typeLabel.backgroundColor = color
        typeLabel.text = typeStr
        nameLabel.text = entity.contractInfo?.symbol ?? "BTCUSDT"
        let ty = (entity.position_type == .allType) ? "全仓".localized() : "逐仓".localized()
        leverageLabel.text = ty+(entity.avg_fixed_leverage.toDecimalUp(0) ?? "10")+"X"
        if self.reuseIdentifier == currentPosition {
            let canClose = entity.cur_qty.bigSub(entity.freeze_qty) ?? "0"
            // 持仓均价
            holdPxDetailLabel.setBottomText(entity.avg_cost_px.toSmallEditPriceContractID(entity.instrument_id))
            // 预估强平价
            closePxDetailLabel.setBottomText(entity.liquidate_price ?? "0")
            // 未实现盈亏
            unRealityDetailLabel.setBottomText(entity.unrealised_profit ?? "0")
            // 盈亏率
            profitRateDetailLabel.setBottomText(entity.repayRate.toPercentString(2) ?? "-")
            
            if entity.unrealised_profit.greaterThanOrEqual(BTZERO) {
                unRealityDetailLabel.setTapColor(UIColor.ThemekLine.up)
                profitRateDetailLabel.setTapColor(UIColor.ThemekLine.up)
            } else {
                unRealityDetailLabel.setTapColor(UIColor.ThemekLine.down)
                profitRateDetailLabel.setTapColor(UIColor.ThemekLine.down)
            }
            
            // 已实现盈亏
            realityLabel.setRightText(entity.realised_pnl.toSmallValue(withContract:entity.instrument_id))
            // 持有量
            holdQtyLabel.setRightText(entity.cur_qty)
            // 保证金
            depositLabel.setRightText(entity.im.toSmallValue(withContract:entity.instrument_id))
            // 可平量
            canCloseLabel.setRightText(canClose)
            // 止盈
            if let stopProfit = entity.plan_order_stop_p {
                profitPxLabel.setRightText(stopProfit.px ?? "-")
                SLFormula.carculatePositionAnticipateProfit(entity, performPrice: stopProfit.px) {[weak self] (value, rate) in
                    let value = (stopProfit.px ?? "--") + "/" + rate.toPercentString(2)
                    self?.profitPxLabel.setRightText(value)
                }
            }
            // 止损
            if let stopLoss = entity.plan_order_stop_l {
                lossPxLabel.setRightText(stopLoss.px ?? "-")
                SLFormula.carculatePositionAnticipateLoss(entity, performPrice: stopLoss.px) {[weak self] (value, rate) in
                    let value = (stopLoss.px ?? "--") + "/" + rate.toPercentString(2)
                    self?.lossPxLabel.setRightText(value)
                }
            }
        } else if self.reuseIdentifier == historyPosition {
            // 更新时间
            timeLabel.text = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: (entity.updated_at ?? "0")), format: "yyyy/MM/dd HH:mm")
            // 开仓均价
            holdPxDetailLabel.setBottomText(entity.avg_cost_px.toSmallPrice(withContractID:entity.instrument_id))
            
            if entity.errorno == 5 || entity.errorno == 6 {
                // 平仓均价
                closePxDetailLabel.setBottomText("--")
            } else {
                // 平仓均价
                closePxDetailLabel.setBottomText(entity.avg_close_px.toSmallPrice(withContractID:entity.instrument_id))
            }
            
            // 已实现盈亏
            unRealityDetailLabel.setBottomText(entity.realised_pnl.toSmallValue(withContract:entity.instrument_id))
        }
    }
}
