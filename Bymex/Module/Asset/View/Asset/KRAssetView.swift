//
//  KRAssetView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/28.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class KRAssetView: KRBaseV {
    
    var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, BehaviorSubject<KRAssetEntity>>>?
    
    var dataArray: BehaviorSubject<[SectionModel<String, BehaviorSubject<KRAssetEntity>>]> = BehaviorSubject(value: [])
    
    var assetVM = KRAssetVM()
    
    lazy var headView : KRAssetHeaderView = {
        let object = KRAssetHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 350))
        return object
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.backgroundColor = UIColor.ThemeView.bg
        tableView.extRegistCell([KRAssetListTC.classForCoder()], ["KRAssetListTC"])
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 96
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
    }
    
    func setNoti() {
        
    }
    
    func bindTableView() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, BehaviorSubject<KRAssetEntity>>>(
            configureCell: { ds, tableView, indexPath, observable in
                let cell : KRAssetListTC = tableView.dequeueReusableCell(withIdentifier: "KRAssetListTC") as! KRAssetListTC
                cell.selectedBackgroundView = UIView()
                cell.selectedBackgroundView?.backgroundColor = UIColor.ThemeTab.bg
                _ = observable.bind { (model) in
                    cell.setCell(model)
                }.disposed(by: cell.disposeBag)
                return cell
            }
        )
        self.dataSource = dataSource
        
        dataArray.asObserver().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        dataArray.onNext([
        SectionModel.init(model: "1", items:[]),
        SectionModel.init(model: "2", items:[])])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
