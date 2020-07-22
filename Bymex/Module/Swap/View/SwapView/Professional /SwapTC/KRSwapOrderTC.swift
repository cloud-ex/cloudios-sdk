//
//  KRSwapOrderTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/24.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

enum KRSwapTransactionDetailType: Int {
    case force
    case reduce
}

class KRSwapOrderTC: UITableViewCell {
    
    typealias CancelOrderBlock = (BTContractOrderModel?) -> ()
    var cancelOrderBlock : CancelOrderBlock?
    
    typealias ClickOrderDetailBlock = (BTContractOrderModel?) -> ()
    var clickOrderDetailBlock : ClickOrderDetailBlock?
    
    weak var cellOrder : BTContractOrderModel?
    
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
        object.frame = CGRect.init(x: 0, y: 0, width: 50, height: 20)
        object.backgroundColor = UIColor.ThemeView.seperator
        object.roundCorners(corners: [.topLeft, .topRight,.bottomRight], radius: 4)
        return object
    }()
    lazy var timeLabel : UILabel = { // 时间
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        object.extUseAutoLayout()
        return object
    }()
    lazy var closeBtn : KRFlatBtn = {
        let object = KRFlatBtn()
        object.extSetTitle("撤销".localized(), 12, UIColor.ThemeLabel.colorHighlight, .normal)
        object.color = UIColor.ThemeView.highlight
        object.rx.tap.subscribe(onNext:{ [weak self] in
            self?.cancelOrderBlock?(self?.cellOrder)
        }).disposed(by: disposeBag)
        return object
    }()
    lazy var detailView: UIControl = {
        let detail = UIControl()
        let label = UILabel(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        let imageView = UIImageView(image: UIImage.themeImageNamed(imageName: "account_next"))
        imageView.contentMode = .scaleAspectFit
        detail.addSubViews([label, imageView])
        label.snp_makeConstraints { (make) in
            make.left.top.height.equalToSuperview()
        }
        imageView.snp_makeConstraints { (make) in
            make.left.equalTo(label.snp_right)
            make.right.equalToSuperview()
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        detail.addTarget(self, action: #selector(clickDetailButton), for: .touchUpInside)
        return detail
    }()
    
    lazy var orderQtyLabel : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("委托数量(张)".localized())
        object.setBottomText("--".localized())
        return object
    }()
    lazy var orderPxLabel : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("委托价格(USDT)".localized())
        object.setBottomText("--".localized())
        return object
    }()
    lazy var dealQtyLabel : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("成交数量(张)".localized())
        object.setBottomText("--".localized())
        return object
    }()
    lazy var orderAvaiLabel : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("委托价值(USDT)".localized())
        object.setBottomText("--".localized())
        return object
    }()
    lazy var bottomLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.bg
        return object
    }()
    lazy var dueTimeLabel : KRHorLabel = {
        let object = KRHorLabel()
        object.setLeftText("到期时间".localized())
        object.rightLabel.font = UIFont.ThemeFont.SecondaryRegular
        return object
    }()
    lazy var tiggerTimeLabel : KRHorLabel = {
        let object = KRHorLabel()
        object.setLeftText("触发时间".localized())
        object.rightLabel.font = UIFont.ThemeFont.SecondaryRegular
        return object
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.ThemeView.bg
        selectionStyle = .none
        contentView.backgroundColor = UIColor.ThemeTab.bg
        contentView.extSetCornerRadius(5)
        setupBaseViewsLayout()
        switch reuseIdentifier {
        case limitIdentify:
            setupNormalSubViewsLayout()
        case limitHistoryIdentify:
            closeBtn.isHidden = true
            setupNormalSubViewsLayout()
            setSubviewsHistoryInfoView()
        case planIdentify:
            setupNormalSubViewsLayout()
        case planHistoryIdentify:
            closeBtn.isHidden = true
            setupPlanHistorySubViewsLayout()
            setSubviewsHistoryInfoView()
        default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(_ order:BTContractOrderModel) {
        self.cellOrder = order
        var typeStr = "开多".localized()
        var color = UIColor.ThemekLine.up
        leverageLabel.text = (order.leverage ?? "10")+"X"
        switch order.side {
        case .buy_OpenLong:
            leverageLabel.isHidden = false
        case .buy_CloseShort:
            typeStr = "平空".localized()
            leverageLabel.isHidden = true
        case .sell_CloseLong:
            leverageLabel.isHidden = true
            typeStr = "平多".localized()
            color = UIColor.ThemekLine.down
        case .sell_OpenShort:
            leverageLabel.isHidden = false
            typeStr = "开空".localized()
            color = UIColor.ThemekLine.down
        default:
            typeStr = "开空".localized()
        }
        typeLabel.backgroundColor = color
        typeLabel.text = typeStr
        nameLabel.text = order.contractInfo?.symbol ?? "--"
        timeLabel.text = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: (order.updated_at ?? "0")), format: "yyyy/MM/dd HH:mm")
        
        switch reuseIdentifier {
        case limitIdentify: // 当前普通委托
            orderQtyLabel.setBottomText(order.qty ?? "-")
            if order.category == .market {
                orderPxLabel.setBottomText("市价".localized())
                orderAvaiLabel.setBottomText("--")
            } else {
                orderPxLabel.setBottomText(order.px.toSmallEditPriceContractID(order.instrument_id) ?? "-")
                orderAvaiLabel.setBottomText(order.avai.toSmallValue(withContract:order.instrument_id) ?? "-")
            }
            dealQtyLabel.setBottomText(order.cum_qty ?? "-")
            orderPxLabel.setTopText(String(format: "委托价格(%@)", order.quote_coin ?? ""))
            orderAvaiLabel.setTopText(String(format: "委托价值(%@)", order.contractInfo?.margin_coin ?? ""))
        case limitHistoryIdentify: // 历史普通委托
            orderQtyLabel.setTopText(String(format: "委托价格(%@)", order.quote_coin ?? ""))
            orderPxLabel.setTopText("委托数量(张)")
            dealQtyLabel.setTopText(String(format: "委托价值(%@)", order.contractInfo?.margin_coin ?? ""))
            orderAvaiLabel.setTopText("成交数量(张)")
            orderPxLabel.setBottomText(order.qty ?? "-")
            if order.category == .market {
                orderQtyLabel.setBottomText("市价".localized())
                dealQtyLabel.setBottomText("--")
            } else {
                orderQtyLabel.setBottomText(order.px.toSmallEditPriceContractID(order.instrument_id) ?? "-")
                dealQtyLabel.setBottomText(order.avai.toSmallValue(withContract:order.instrument_id) ?? "-")
            }
            orderAvaiLabel.setBottomText(order.cum_qty ?? "-")
            if let label = detailView.subviews.first as? UILabel {
                label.text = KRSwapSDKManager.shared.getOrderResultStr(order)
            }
        case planIdentify:  // 当前条件单
            timeLabel.text = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: (order.created_at ?? "0")), format: "yyyy/MM/dd HH:mm")
            orderQtyLabel.setTopText(String(format: "触发价格(%@)", order.quote_coin ?? ""))
            orderPxLabel.setTopText(String(format: "执行价格(%@)", order.quote_coin ?? ""))
            dealQtyLabel.setTopText("执行数量(张)")
            orderAvaiLabel.setTopText("到期时间")
            var tiggerType = "最新价".localized()
            if order.trigger_type == .markPriceType {
                tiggerType = "合理价".localized()
            } else if order.trigger_type == .indexPriceType {
                tiggerType = "指数价".localized()
            }
            let tiggerPx = tiggerType+" "+(order.px.toSmallEditPriceContractID(order.instrument_id) ?? "-")
            orderQtyLabel.setBottomText(tiggerPx)
            if order.category == .market {
                orderPxLabel.setBottomText("市价".localized())
            } else {
                orderPxLabel.setBottomText(order.exec_px?.toSmallEditPriceContractID(order.instrument_id) ?? "-")
            }
            if order.type == .profitType || order.type == .lossType {
                let qty = (order.qty != "0") ? order.qty : "100%"
                dealQtyLabel.setBottomText(qty ?? "100%")
            } else {
                dealQtyLabel.setBottomText(order.qty ?? "0")
            }
            let time = BTFormat.datelocalTimeStr(BTFormat.date(fromUTCString: order.created_at), format: "yyyy/MM/dd HH:mm", addDate: 60 * 60 * (order.cycle?.doubleValue ?? 0))
            orderAvaiLabel.setBottomText(time ?? "-")
        case planHistoryIdentify: // 历史条件单
            timeLabel.text = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: (order.finished_at ?? "0")), format: "yyyy/MM/dd HH:mm")
            orderQtyLabel.setTopText(String(format: "触发价格(%@)", order.quote_coin ?? ""))
            orderPxLabel.setTopText(String(format: "执行价格(%@)", order.quote_coin ?? ""))
            dealQtyLabel.setTopText("执行数量(张)")
            
            var tiggerType = "最新价".localized()
            if order.trigger_type == .markPriceType {
                tiggerType = "合理价".localized()
            } else if order.trigger_type == .indexPriceType {
                tiggerType = "指数价".localized()
            }
            let tiggerPx = tiggerType+" "+(order.px.toSmallEditPriceContractID(order.instrument_id) ?? "-")
            orderQtyLabel.setBottomText(tiggerPx)
            if order.category == .market {
                orderPxLabel.setBottomText("市价".localized())
            } else {
                orderPxLabel.setBottomText(order.exec_px?.toSmallEditPriceContractID(order.instrument_id) ?? "-")
            }
            if order.type == .profitType || order.type == .lossType {
                let qty = (order.qty != "0") ? order.qty : "100%"
                dealQtyLabel.setBottomText(qty ?? "100%")
            } else {
                dealQtyLabel.setBottomText(order.qty ?? "0")
            }
            let time = BTFormat.datelocalTimeStr(BTFormat.date(fromUTCString: order.created_at), format: "yyyy/MM/dd HH:mm", addDate: 60 * 60 * (order.cycle ?? NSNumber.init(value: 24)).doubleValue)
            dueTimeLabel.setRightText(time ?? "-")
            let tiggerTime = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: (order.finished_at ?? "0")), format: "yyyy/MM/dd HH:mm")
            tiggerTimeLabel.setRightText(tiggerTime ?? "-")
            if let label = detailView.subviews.first as? UILabel {
                label.text = KRSwapSDKManager.shared.getOrderResultStr(order)
            }
        default:
            break
        }
    }
}

extension KRSwapOrderTC {
    
    func setupBaseViewsLayout() {
        contentView.addSubViews([typeLabel,nameLabel,timeLabel,closeBtn,leverageLabel])
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalToSuperview()
            make.height.equalTo(17)
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
            make.width.equalTo(32)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(150)
        }
        closeBtn.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(24)
            make.centerY.equalTo(nameLabel.snp.bottom)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    func setupNormalSubViewsLayout() {
        contentView.addSubViews([orderQtyLabel,orderPxLabel,dealQtyLabel,orderAvaiLabel])
        orderQtyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.height.equalTo(34)
        }
        orderPxLabel.snp.makeConstraints { (make) in
            make.left.equalTo(orderQtyLabel.snp.right).offset(10)
            make.width.height.top.equalTo(orderQtyLabel)
            make.right.equalToSuperview().offset(-10)
        }
        dealQtyLabel.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(orderQtyLabel)
            make.top.equalTo(orderQtyLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        orderAvaiLabel.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(orderPxLabel)
            make.top.equalTo(dealQtyLabel)
        }
    }
    func setupPlanHistorySubViewsLayout() {
        contentView.addSubViews([orderQtyLabel,orderPxLabel,dealQtyLabel,bottomLine,dueTimeLabel,tiggerTimeLabel])
        orderQtyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.height.equalTo(34)
        }
        orderPxLabel.snp.makeConstraints { (make) in
            make.left.equalTo(orderQtyLabel.snp.right).offset(10)
            make.width.height.top.equalTo(orderQtyLabel)
            make.right.equalToSuperview().offset(-10)
        }
        dealQtyLabel.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(orderQtyLabel)
            make.top.equalTo(orderQtyLabel.snp.bottom).offset(12)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(orderQtyLabel)
            make.right.equalTo(orderPxLabel)
            make.height.equalTo(1)
            make.top.equalTo(dealQtyLabel.snp.bottom).offset(10)
        }
        dueTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(orderQtyLabel)
            make.top.equalTo(bottomLine.snp.bottom).offset(10)
            make.height.equalTo(16)
            make.bottom.equalToSuperview().offset(-12)
        }
        tiggerTimeLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(orderPxLabel)
            make.height.top.equalTo(dueTimeLabel)
        }
    }
    
    func setSubviewsHistoryInfoView() {
        contentView.addSubview(detailView)
        detailView.snp_makeConstraints { (make) in
            make.right.equalToSuperview().offset(-9)
            make.height.equalTo(20)
            make.centerY.equalTo(nameLabel.snp.bottom)
        }
    }
}

extension KRSwapOrderTC {
    @objc func clickDetailButton() {
        self.clickOrderDetailBlock?(cellOrder)
    }
}
