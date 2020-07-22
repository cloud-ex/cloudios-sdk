//
//  KRCapitalCostVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/4.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  资金费用明细

import Foundation

class KRCapitalCostVc : KRNavCustomVC {
    
    var position : BTPositionModel?
    
    var tableViewRowDatas : [BTIndexDetailModel] = []
    
    lazy var tableView : UITableView = {
        let object = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        object.extUseAutoLayout()
        object.backgroundColor = UIColor.ThemeView.bg
        object.extSetTableView(self, self)
        object.extRegistCell([KRCapitalCostTC.classForCoder()], ["KRCapitalCostTC"])
        object.rowHeight = 152;
        return object
    }()
    
    override func setNavCustomV() {
        self.setTitle("资金费用明细")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviewsLayout()
        loadPositionFeeList()
    }
    private func setupSubviewsLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(navCustomView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension KRCapitalCostVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = tableViewRowDatas[indexPath.row]
        let cell : KRCapitalCostTC = tableView.dequeueReusableCell(withIdentifier: "KRCapitalCostTC") as! KRCapitalCostTC
        if position != nil {
            cell.instrument_id = position?.instrument_id ?? 0
            cell.px_Code = position?.contractInfo?.margin_coin ?? ""
            cell.setCell(entity)
        }
        return cell
    }
}

extension KRCapitalCostVc {
    private func loadPositionFeeList() {
        guard let instrumentId = position?.instrument_id,let pid = position?.pid else { return }
        
        let success = { [weak self] (result: Any?) in
            if let arr = result as? [BTIndexDetailModel] {
                self?.tableViewRowDatas = arr
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        let failure = { [weak self] (err: Any?) in
            
        }
        BTContractTool.getPositionFundingrate(withContractID: instrumentId, pid: pid, success: success, failure: failure)
    }
}
