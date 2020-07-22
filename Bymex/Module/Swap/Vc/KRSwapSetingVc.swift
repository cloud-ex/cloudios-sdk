//
//  KRSwapSetingVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/1.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSwapSetingVc: KRNavCustomVC {
    
    typealias SelectUnitBlock = () -> ()
    var selectUnitBlock : SelectUnitBlock?
    
    typealias ClickCellBlock = (String) -> ()
    var clickCellBlock : ClickCellBlock?
    
    var tableViewRowDatas : [KRSettingSecEntity] = []
    
    lazy var tableView : UITableView = {
        let tableV = UITableView()
        tableV.extUseAutoLayout()
        tableV.extSetTableView(self, self)
        tableV.separatorStyle = .none
        tableV.backgroundColor = UIColor.ThemeView.bg
        tableV.extRegistCell([KRSettingTC.classForCoder(),KRSwitchTC.classForCoder()], ["KRSettingTC","KRSwitchTC"])
        tableV.rowHeight = 48
        tableV.bounces = false
        return tableV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.tableViewRowDatas = KRSwapSDKManager.shared.getSwapSettingPage()
        self.tableView.reloadData()
    }
    
    override func setNavCustomV() {
        self.setTitle("合约设置".localized())
    }
}

extension KRSwapSetingVc: UITableViewDelegate ,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contents = tableViewRowDatas[section].contents
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contents = tableViewRowDatas[indexPath.section].contents
        let entity = contents[indexPath.row]
        if entity.cellType == .defaultTC {
            let cell : KRSettingTC = tableView.dequeueReusableCell(withIdentifier: "KRSettingTC") as! KRSettingTC
            cell.setCell(entity)
            return cell
        } else if entity.cellType == .switchTC {
            let cell : KRSwitchTC = tableView.dequeueReusableCell(withIdentifier: "KRSwitchTC") as! KRSwitchTC
            cell.clickSwitchBlock = { isOn in
                if isOn {
                    XUserDefault.setComfirmSwapAlert(true)
                } else {
                    XUserDefault.setComfirmSwapAlert(false)
                }
            }
            cell.setCell(entity)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView.init(frame:CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 20))
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! KRSettingTC
        switch indexPath.row {
        case 0:
            let isCoin = BTStoreData.storeBool(forKey: BT_UNIT_VOL)
            var seleceIndex = 0
            if isCoin {
                seleceIndex = 1
            }
            let sheet = KRActionSheet()
            sheet.configButtonTitles(buttons: ["张".localized(),"币".localized()], selectedIdx: seleceIndex)
            sheet.actionIdxCallback = {[weak self] (idx,title) in
                BTStoreData.setStoreBoolAndKey(idx == 1, key: BT_UNIT_VOL)
                cell.defaultLabel.text = title
                self?.selectUnitBlock?()
            }
            EXAlert.showSheet(sheetView: sheet)
        case 1:
            let idx = BTStoreData.storeObject(forKey: ST_UNREA_CARCUL) as? Int ?? 0
            let sheet = KRActionSheet()
            sheet.configButtonTitles(buttons: ["最新价".localized(),"合理价".localized()], selectedIdx: idx)
            sheet.actionIdxCallback = {(idx,title) in
                BTStoreData.setStoreObjectAndKey(idx, key: ST_UNREA_CARCUL)
                cell.defaultLabel.text = title
            }
            EXAlert.showSheet(sheetView: sheet)
            break
        case 2:
            break
        case 3:
            let idx = BTStoreData.storeObject(forKey: ST_DATE_CYCLE) as? Int ?? 0
            let sheet = KRActionSheet()
            sheet.configButtonTitles(buttons: ["24小时".localized(),"7天".localized()], selectedIdx: idx)
            sheet.actionIdxCallback = { (idx,title) in
                BTStoreData.setStoreObjectAndKey(idx, key: ST_DATE_CYCLE)
                cell.defaultLabel.text = title
            }
            EXAlert.showSheet(sheetView: sheet)
        default:
            break
        }
        
    }
}
