//
//  KRRegionVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/14.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRRegionVc: KRNavCustomVC {
    typealias ClickRegionCellBlock = (RegionEntity)->()
    var clickRegionCellBlock : ClickRegionCellBlock?
    
    var vm = KRRegionVM()
    
    var regionTableViewRowDatas : [String : [RegionEntity]] = [:]
    
    var regionNameSetions : [String] = []
    
    var allRowDatas : [String : [RegionEntity]] = [:]
    
    var choose:Bool = false
    
    lazy var tableView : UITableView = {
        let tableV = UITableView()
        tableV.extUseAutoLayout()
        tableV.extSetTableView(self , self )
        tableV.register(KRRegionHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: "RegionHeaderView")
        tableV.extRegistCell([KRRegionCell.classForCoder()], ["RegionTC"])
        tableV.sectionIndexBackgroundColor = UIColor.ThemeView.bg
        return tableV
    }()
    
    //搜索的背景
    lazy var topSearchView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.bg
        return view
    }()
    //搜索栏
    lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.extUseAutoLayout()
        searchBar.barTintColor = UIColor.ThemeView.bg
        searchBar.layer.borderColor = UIColor.ThemeView.bg.cgColor
        searchBar.subviews.first?.subviews.last?.backgroundColor = UIColor.ThemeView.bg
        searchBar.tintColor = UIColor.ThemeLabel.colorMedium
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField{
            textfield.setPlaceHolderAtt("common_text_search".localized(), color: UIColor.ThemeLabel.colorDark, font: 14)
            textfield.textColor = UIColor.ThemeLabel.colorMedium
            textfield.font = UIFont.ThemeFont.BodyRegular
            textfield.setModifyClearButton()
        }
        searchBar.layer.borderWidth = 1
        searchBar.delegate = self
        searchBar.setImage(UIImage.themeImageNamed(imageName: "search_dark"), for: .search, state: .normal)
        return searchBar
    }()
    //取消按钮
    lazy var cancelBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setEnlargeEdgeWithTop(10, left: 10, bottom: 10, right: 10)
        btn.extSetImages([UIImage.themeImageNamed(imageName: "closed")], controlStates: [.normal])
        btn.extSetAddTarget(self, #selector(clickCancelBtn))
        return btn
    }()
    
    override func setNavCustomV() {
        self.navCustomView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.ThemeView.bg
        contentView.addSubview(tableView)
        view.addSubview(topSearchView)
        topSearchView.addSubViews([searchBar, cancelBtn])
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-TABBAR_BOTTOM)
        }
        topSearchView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(NAV_TOP + 20)
            make.height.equalTo(44)
        }
        searchBar.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(cancelBtn.snp.left).offset(-5)
            make.top.equalTo(self.topSearchView).offset(5)
            make.height.equalTo(36)
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.topSearchView).offset(-15)
            make.height.width.equalTo(20)
            make.centerY.equalTo(self.searchBar)
        }
        vm.setVC(self)
        getRegionInfo()
    }
    func getRegionInfo(){
        if KRBasicParameter.isHan(){
            self.reloadSearchView(KRRegionVM().zh_nameTransForm(CountryList.getAllRegions()))
            
        }else{
            self.reloadSearchView(KRRegionVM().us_nameTransForm(CountryList.getAllRegions()))
            
        }
    }
}

extension KRRegionVc : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.regionNameSetions.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let name = self.regionNameSetions[section]
        let view : KRRegionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RegionHeaderView") as! KRRegionHeaderView
        view.setCellLabel(name)
        if choose{
            if section == 0{
                view.isHidden = true

            }else{
                view.isHidden = false

            }
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if choose{
            if section == 0{
                return 0.01
            }
        }
        return 32
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.regionTableViewRowDatas[self.regionNameSetions[section]]?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let secion = self.regionTableViewRowDatas[self.regionNameSetions[indexPath.section]]{
            let entity = secion[indexPath.row]
            let cell : KRRegionCell = tableView.dequeueReusableCell(withIdentifier: "RegionTC") as! KRRegionCell
            cell.setCellWithEntity(entity)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let secion = self.regionTableViewRowDatas[self.regionNameSetions[indexPath.section]]{
            let entity = secion[indexPath.row]
            clickRegionCellBlock?(entity)
            popBack()
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.regionNameSetions
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: index), at: .top, animated: false)
        return index
    }
    
}

extension KRRegionVc : UISearchBarDelegate {
    @objc func clickCancelBtn(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            reloadSearchView(allRowDatas)
        }else{
            var array : [RegionEntity] = []
            if KRBasicParameter.isHan() == true{
                for key in allRowDatas.keys{
                    for item in allRowDatas[key] ?? []{
                        if item.cnName.contains(searchText) || item.dialingCode.contains(searchText){
                            array.append(item)
                        }
                    }
                }
                self.reloadSearchView(KRRegionVM().zh_nameTransForm(array))
            }else{
                for key in allRowDatas.keys{
                    for item in allRowDatas[key] ?? []{
                        if item.enName.uppercased().contains(searchText) || item.enName.lowercased().contains(searchText) ||  item.dialingCode.contains(searchText){
                            array.append(item)
                        }
                    }
                }
                self.reloadSearchView(KRRegionVM().us_nameTransForm(array))
            }
        }
    }
    
    func reloadSearchView(_ arr :  [String : [RegionEntity]]){
        self.regionTableViewRowDatas = arr
        self.regionNameSetions = self.regionTableViewRowDatas.keys.sorted()
        self.tableView.reloadData()
        if allRowDatas.count == 0{
            allRowDatas = arr
        }
    }
}
