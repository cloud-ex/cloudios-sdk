//
//  KRAllTransactionsVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/24.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  全部委托

import Foundation
import RxSwift

class KRAllTransactionsVc: KRNavCustomVC {
    
    let vm = KRAllOrdersVM()
    
    var headerTag : Int = 1001
    var segmentTag : Int = 0
    
    var cellIdentifier = limitIdentify
    lazy var headNavV : KRAllTransactionsNavV = {
        let object = KRAllTransactionsNavV()
        object.setViews(["当前委托".localized(),"历史委托".localized()])
        return object
    }()
    lazy var headSegmentV : UISegmentedControl = {
        let object = UISegmentedControl.init(titles: ["普通委托".localized(),"条件委托".localized()])
        return object
    }()
    lazy var tableView : UITableView = {
        let object = UITableView()
        object.extUseAutoLayout()
        object.backgroundColor = UIColor.ThemeView.bg
        object.showsVerticalScrollIndicator = false
        object.extSetTableView(self, self)
        object.extRegistCell([KRSwapOrderTC.classForCoder(),KRSwapOrderTC.classForCoder(),KRSwapOrderTC.classForCoder(),KRSwapOrderTC.classForCoder()], [limitIdentify,limitHistoryIdentify,planIdentify,planHistoryIdentify])
        return object
    }()
    lazy var drawerBtn : UIButton = {
        let object = UIButton()
         object.extSetImages([UIImage.themeImageNamed(imageName: "asset_drawer")], controlStates: [.normal])
        object.rx.tap.subscribe(onNext:{ [weak self] in
            guard let myself = self else {return}
            let vc = KROrderDrawerVc()
            vc.orderWay = myself.vm.orderWay
            vc.status = myself.vm.status
            myself.gy_showSide(configuration: { (config) in
                config.direction = .right
            }, viewController: vc)
            vc.comfirmOrderDrawerBlock = {[weak self] (way,status) in
                myself.vm.orderWay = way
                myself.vm.status = status
                myself.vm.requestTransitionData()
            }
        }).disposed(by: disposeBag)
        return object
    }()
    
    lazy var emptyV : KRSwapEmptyView = {
        let object = KRSwapEmptyView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        object.emptyTips.text = "赶快下单吧，你离暴富只差一步"
        return object
    }()
    
    override func setNavCustomV() {
        self.navCustomView.setRightModule([drawerBtn],rightSize:[(30,30)])
        self.navCustomView.addSubview(headNavV)
        headNavV.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.width.equalTo(176)
            make.centerX.bottom.equalToSuperview()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviewsLayout()
        bindVM()
        bindSubject()
    }
    private func setupSubviewsLayout() {
        view.addSubViews([headSegmentV,tableView])
        headSegmentV.snp.makeConstraints { (make) in
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.top.equalTo(navCustomView.snp.bottom).offset(16)
            make.height.equalTo(32)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headSegmentV.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        view.addSubview(emptyV)
        emptyV.snp.makeConstraints { (make) in
            make.top.equalTo(headSegmentV.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func bindVM() {
        vm.setVc(self)
    }
    
    private func bindSubject() {
        headNavV.subject.asObserver().subscribe(onNext: {[weak self] (tag) in
            self?.headerTag = tag
            self?.requestDataWithHeaderTag()
        }).disposed(by: self.disposeBag)
        _ = headSegmentV.rx.value.asObservable()
        .subscribe(onNext: { [weak self] tag in
            self?.segmentTag = tag
            self?.requestDataWithHeaderTag()
        }).disposed(by: disposeBag)
    }
    
    private func requestDataWithHeaderTag() {
        self.emptyV.isHidden = false
        if headerTag == 1001 {
            if segmentTag == 0 {    // 当前普通委托
                vm.cellIdentifier = limitIdentify
            } else {                // 当前j委计划托
                vm.cellIdentifier = planIdentify
            }
        } else {
            if segmentTag == 0 {    // 历史普通委托
                vm.cellIdentifier = limitHistoryIdentify
            } else {                // 历史条件单
                vm.cellIdentifier = planHistoryIdentify
            }
        }
        vm.requestTransitionData()
    }
}

extension KRAllTransactionsVc: UITableViewDelegate,UITableViewDataSource {
    
    func reloadTableView() {
        emptyV.isHidden = (vm.tableViewRowDatas.count > 0) ? true : false
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = vm.tableViewRowDatas[indexPath.row]
        if headerTag == 1001 {
            if segmentTag == 0 {    // 当前普通委托
                let cell : KRSwapOrderTC = tableView.dequeueReusableCell(withIdentifier: limitIdentify) as! KRSwapOrderTC
                cell.setCell(entity)
                cell.cancelOrderBlock = {[weak self] order in
                    guard let mySelf = self,let entity = order else { return }
                    mySelf.vm.cancelTransitionOrders(limitIdentify, [entity]) { (result) in
                        
                    }
                }
                return cell
            } else {                // 当前委计划托
                let cell : KRSwapOrderTC = tableView.dequeueReusableCell(withIdentifier: planIdentify) as! KRSwapOrderTC
                cell.setCell(entity)
                cell.cancelOrderBlock = {[weak self] order in
                    guard let mySelf = self,let entity = order else { return }
                    mySelf.vm.cancelTransitionOrders(planIdentify, [entity]) { (result) in
                        
                    }
                }
                return cell
            }
        } else {
            if segmentTag == 0 {    // 历史普通委托
                let cell : KRSwapOrderTC = tableView.dequeueReusableCell(withIdentifier: limitHistoryIdentify) as! KRSwapOrderTC
                cell.setCell(entity)
                cell.clickOrderDetailBlock = {[weak self] order in
                    guard let mySelf = self else { return }
                    let vc = KRDetailTransactionVC()
                    vc.orderModel = order
                    mySelf.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            } else {                // 历史条件单
                let cell : KRSwapOrderTC = tableView.dequeueReusableCell(withIdentifier: planHistoryIdentify) as! KRSwapOrderTC
                cell.setCell(entity)
                cell.clickOrderDetailBlock = {[weak self] order in
                    guard let mySelf = self else { return }
                    let vc = KRDetailTransactionVC()
                    vc.orderModel = order
                    mySelf.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if headerTag == 1001 {
            if segmentTag == 0 {    // 当前普通委托
                return 176
            } else {                // 当前委计划托
                return 176
            }
        } else {
            if segmentTag == 0 {    // 历史普通委托
                return 176
            } else {                // 历史条件单
                return 216
            }
        }
    }
}

// MARK:- KRAllTransactionsNavV
class KRAllTransactionsNavV: KRBaseV {
    var subject : PublishSubject<Int> = PublishSubject.init()
    lazy var leftBtn : UIButton = {
        let object = UIButton()
        object.extSetTitle("", 16, UIColor.ThemeLabel.colorDark, .normal)
        object.setTitleColor(UIColor.ThemeLabel.colorLite, for: .selected)
        object.tag = 1001
        object.extSetAddTarget(self, #selector(clickBtn(_:)))
        object.isSelected = true
        return object
    }()
    lazy var rightBtn : UIButton = {
        let object = UIButton()
        object.extSetTitle("", 16, UIColor.ThemeLabel.colorDark, .normal)
        object.setTitleColor(UIColor.ThemeLabel.colorLite, for: .selected)
        object.tag = 1002
        object.extSetAddTarget(self, #selector(clickBtn(_:)))
        return object
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        addSubViews([leftBtn,rightBtn])
        leftBtn.snp.makeConstraints { (make) in
            make.left.bottom.top.equalToSuperview()
        }
        rightBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(leftBtn.snp.right)
            make.width.equalTo(leftBtn)
        }
    }
    
    func setViews(_ titles: [String]) {
        leftBtn.setTitle(titles[0], for: .normal)
        rightBtn.setTitle(titles[1], for: .normal)
    }
    
    @objc func clickBtn(_ btn : UIButton){
        btn.isSelected = true
        if btn == leftBtn {
            rightBtn.isSelected = false
        } else {
            leftBtn.isSelected = false
        }
        subject.onNext(btn.tag)
    }
}
