//
//  KRHomeView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/15.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

let KRHomeSwapMarketTC = "KRHomeSwapMarketTC"
let KRHomeDayProfitTC = "KRHomeDayProfitTC"

class KRHomeView: KRBaseV {
    
    var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, BehaviorSubject<BTItemModel>>>?
    
    var dataArray: BehaviorSubject<[SectionModel<String, BehaviorSubject<BTItemModel>>]> = BehaviorSubject(value: [])
    
    var homeVm = KRHomeVM()
    
    lazy var headView : KRHomeHeaderView = {
        let object = KRHomeHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: pagewheelHeight + CGFloat(recommendedViewHeight)))
        return object
    }()
    
    lazy var swapMarketHead : KRHomeSectionHeadView = {
        let object = KRHomeSectionHeadView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100), homeHeadeType: .swapMarket)
        object.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        return object
    }()
    
    lazy var dayProfitHead : KRHomeSectionHeadView = {
        let object = KRHomeSectionHeadView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100), homeHeadeType: .dayProfit)
        object.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        return object
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.backgroundColor = UIColor.ThemeView.bg
        tableView.bounces = false
        tableView.extRegistCell([KRHomeListTC.classForCoder(),KRHomeListTC.classForCoder()], [KRHomeSwapMarketTC,KRHomeDayProfitTC])
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 60
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([tableView])
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.tableHeaderView = headView
        
        setNoti()
        bindTableView()
        headView.setRecommend(PublicInfoEntity.sharedInstance.getRecommends())
        homeVm.getBannerEntity {[weak self] (bannerEntity) in
            self?.headView.setBannerView(bannerEntity)
        }
    }
    
    func setNoti() {
         _ = NotificationCenter.default.rx
                   .notification(Notification.Name(rawValue: MARKET_TICKER_LOADED_NOTI))
                   .takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
                   .subscribe(onNext: {[weak self] notification in
                       guard let mySelf = self else {return}
                       mySelf.dataArray.onNext([
                           SectionModel.init(model: "1", items: KRSwapSDKManager.shared.allTickerInfoObs),
                           SectionModel.init(model: "2", items: KRSwapSDKManager.shared.allTickerInfoObs)])
                   })
    }
    
    func bindTableView() {
       let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, BehaviorSubject<BTItemModel>>>(
            configureCell: { ds, tableView, indexPath, observable in
                if indexPath.section == 0 {
                    let cell : KRHomeListTC = tableView.dequeueReusableCell(withIdentifier: KRHomeSwapMarketTC) as! KRHomeListTC
                    cell.selectedBackgroundView = UIView()
                    cell.selectedBackgroundView?.backgroundColor = UIColor.ThemeTab.bg
                    _ = observable.bind { (model) in
                        if model.instrument_id > 0 {
                            cell.setCell(model)
                        }
                    }.disposed(by: cell.disposeBag)
                    return cell
                 } else if indexPath.section == 1 {
                    let cell : KRHomeListTC = tableView.dequeueReusableCell(withIdentifier: KRHomeDayProfitTC) as! KRHomeListTC
                    cell.selectedBackgroundView = UIView()
                    cell.selectedBackgroundView?.backgroundColor = UIColor.ThemeTab.bg
                    return cell
                 }
                return UITableViewCell()
            }
        )
        self.dataSource = dataSource
        
        dataArray.asObserver().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        dataArray.onNext([
        SectionModel.init(model: "1", items: KRSwapSDKManager.shared.allTickerInfoObs),
        SectionModel.init(model: "2", items: KRSwapSDKManager.shared.allTickerInfoObs)])
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KRHomeView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return swapMarketHead
        } else if section == 1 {
            return dayProfitHead
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerV = UIView()
        footerV.backgroundColor = UIColor.ThemeView.bg
        return footerV
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
