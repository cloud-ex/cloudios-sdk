//
//  KRSwapPositionVM.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSwapPositionVM: NSObject {
    
    var cellIdentifier = currentPosition
    
    var itemModel : BTItemModel?
    
    var tableViewRowDatas : [BTPositionModel] = []
    
    weak var vc : KRSwapPositionVc?
    func setVc(_ vc : KRSwapPositionVc){
        self.vc = vc
        setNotification()
    }
    
    func setNotification() {
        // MARK:- 合约私有信息
        _ = NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: BTSocketDataUpdate_Contract_Unicast_Notification))
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: {[weak self] notification in
                guard let mySelf = self else {return}
                guard let socketModelArray = notification.userInfo?["data"] as? [BTWebSocketModel] else {
                    return
                }
                if mySelf.cellIdentifier == currentPosition {
                    mySelf.wsDealPosition(socketModelArray)
                }
            })
    }
}

extension KRSwapPositionVM {
    
    func loadPositionData(_ instrument_id : Int64) {
        guard instrument_id > 0 else {
            return
        }
        if cellIdentifier == currentPosition {
            BTContractTool.getUserPosition(withContractID: instrument_id, status: .holdSystem, offset: 0, size: 0, success: {[weak self] (positions) in
                self?.tableViewRowDatas = positions ?? []
                self?.vc?.reloadTableView()
            }) {[weak self] (error) in
                if self?.tableViewRowDatas.count ?? 0 > 0 {
                    self?.tableViewRowDatas.removeAll()
                    self?.vc?.reloadTableView()
                }
            }
        } else if cellIdentifier == historyPosition {
            BTContractTool.getUserPosition(withContractID: instrument_id, status: .close, offset: 0, size: 0, success: {[weak self] (positions) in
                self?.tableViewRowDatas = positions ?? []
                self?.vc?.reloadTableView()
            }) {[weak self] (error) in
                if self?.tableViewRowDatas.count ?? 0 > 0 {
                    self?.tableViewRowDatas.removeAll()
                    self?.vc?.reloadTableView()
                }
            }
        }
    }
}

// MARK: - ws
extension KRSwapPositionVM {
    func wsDealPosition(_ sockerModels : [BTWebSocketModel]) {
        var positions = Array(tableViewRowDatas)
        var isChanged = false
        
        for socketModel in sockerModels {
            guard let socketPositionModel = socketModel.position else {
                continue
            }
            // 已平仓
            if socketPositionModel.status == .close {
                for idx in 0..<positions.count {
                    if positions[idx].pid == socketPositionModel.pid {
                        // 如果websocket推送过来的是最新的
                        if BTFormat.getTimeStr(with: socketPositionModel.updated_at) >= BTFormat.getTimeStr(with: positions[idx].updated_at) {
                            positions.remove(at: idx)
                            isChanged = true
                        }
                        break
                    }
                }
            } else if positions.count == 0 {
                if socketPositionModel.instrument_id == self.itemModel?.instrument_id {
                    positions.append(socketPositionModel)
                    isChanged = true
                }
            } else {
                for idx in 0..<positions.count {
                    if positions[idx].pid == socketPositionModel.pid {
                        if BTFormat.getTimeStr(with: socketPositionModel.updated_at) >= BTFormat.getTimeStr(with: positions[idx].updated_at) {
                            positions[idx] = socketPositionModel
                            isChanged = true
                        }
                        break
                    }
                    if idx == positions.count - 1 && socketPositionModel.instrument_id == self.itemModel?.instrument_id {
                        positions.insert(socketPositionModel, at: 0)
                        isChanged = true
                    }
                }
            }
        }
        if isChanged == true {
            DispatchQueue.main.async { [weak self] in
                self?.tableViewRowDatas = positions
                self?.vc?.reloadTableView()
            }
        }
    }
}
