//
//  KRRecommendedView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/15.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import YYText

let recommendedViewHeight = 100/1.0

class KRRecommendedView: UIView {
    var rowDatas : [KRSettingVEntity] = [KRSettingVEntity()]
    
    lazy var collectionCCSize : (CGFloat,CGFloat) = {
        if rowDatas.count >= 4{
            return (SCREEN_WIDTH/4.0,CGFloat(recommendedViewHeight))
        } else {
            return (SCREEN_WIDTH/4.0,CGFloat(recommendedViewHeight))
//            return (SCREEN_WIDTH/CGFloat(rowDatas.count),CGFloat(recommendedViewHeight))
        }
    }()
    
    lazy var collectionV : UICollectionView = {
        let collectionV = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: collectionCCSize.1) , collectionViewLayout: getCollectionLayout())
        collectionV.showsHorizontalScrollIndicator = false
        collectionV.backgroundColor = UIColor.ThemeView.bg
        collectionV.register(KRRecommendCell.classForCoder(), forCellWithReuseIdentifier: "KRRecommendCell")
        collectionV.delegate = self
        collectionV.dataSource = self
        collectionV.backgroundColor = UIColor.ThemeView.bg
        return collectionV
    }()
    
    func getCollectionLayout() -> UICollectionViewFlowLayout{
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.itemSize = CGSize.init(width: collectionCCSize.0, height: collectionCCSize.1)
        return collectionLayout
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeView.bg
        addSubViews([collectionV])
    }
    
    func setView(_ arr : [KRSettingVEntity]){
        rowDatas = arr
        collectionV.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension KRRecommendedView :  UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let entity = rowDatas[indexPath.row]
        let cell : KRRecommendCell = collectionView.dequeueReusableCell(withReuseIdentifier: "KRRecommendCell", for: indexPath) as! KRRecommendCell
        cell.setCell(entity)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 跳转
        let entity = rowDatas[indexPath.row]
        switch entity.rmType {
        case .deposit:
            let vc = KRDepositVc()
            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        case .withdraw:
            let vc = KRWithdrawVc()
            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        case .tranfer:
            let vc = KRTransferVc()
            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        case .help:
            
            break
        case .fundrate:
            let vc = KRAssetRecordVc()
            vc.vcType = .wallet
            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}
