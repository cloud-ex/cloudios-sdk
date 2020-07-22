//
//  KRSwapDrawerVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class KRSwapDrawerVc: KRNavCustomVC {
    
    var didSelectItem: ((BehaviorSubject<BTItemModel>) -> Void)?
    
    var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, BehaviorSubject<BTItemModel>>>?
    var dataArray: BehaviorSubject<[SectionModel<String, BehaviorSubject<BTItemModel>>]> = BehaviorSubject(value: [])
    
    lazy var tableView : UITableView = {
        let tableV = UITableView()
        tableV.extUseAutoLayout()
        tableV.separatorStyle = .none
        tableV.backgroundColor = UIColor.ThemeTab.bg
        tableV.extRegistCell([KRSwapDrawerTC.classForCoder()], ["KRSwapDrawerTC"])
        tableV.rowHeight = 48
        return tableV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navCustomView.backView.backgroundColor = UIColor.ThemeTab.bg
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        bindTableView()
    }
    
    override func setNavCustomV() {
        self.navtype = .nopopback
        self.setTitle("合约切换".localized())
    }
    
    func bindTableView() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, BehaviorSubject<BTItemModel>>>(
            configureCell: { ds, tableView, indexPath, observable in
                let cell : KRSwapDrawerTC = tableView.dequeueReusableCell(withIdentifier: "KRSwapDrawerTC") as! KRSwapDrawerTC
                cell.selectedBackgroundView = UIView()
                cell.selectedBackgroundView?.backgroundColor = UIColor.ThemeTab.bg
                _ = observable.bind { (model) in
                    if model.instrument_id > 0 {
                        cell.setCell(model)
                    }
                }.disposed(by: cell.disposeBag)
                return cell
            }
        )
        tableView.rx.modelSelected(BehaviorSubject<BTItemModel>.self).subscribe(onNext: { (itemBS) in
            self.didSelectItem?(itemBS)
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
        
        self.dataSource = dataSource
        
        dataArray.asObserver().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        dataArray.onNext([
        SectionModel.init(model: "0", items: KRSwapSDKManager.shared.usdtTickerObs),
        SectionModel.init(model: "1", items: KRSwapSDKManager.shared.currencyTickerObs),
        SectionModel.init(model: "2", items: KRSwapSDKManager.shared.simulateTickerObs)])
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension KRSwapDrawerVc {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let V = UIView()
        V.backgroundColor = UIColor.ThemeTab.bg
        let label = UILabel.init(text: "", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        V.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(150)
            make.height.equalTo(16)
        }
        if section == 0 {
            label.text = "USDT合约".localized()
            return V
        } else if section == 1 {
            label.text = "币本位合约".localized()
            return V
        } else if section == 2 {
            label.text = "模拟合约".localized()
            return V
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
