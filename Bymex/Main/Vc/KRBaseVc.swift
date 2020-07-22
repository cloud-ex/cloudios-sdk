//
//  KRBaseVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/10.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

class KRBaseVc: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if KRThemeManager.isNight() == true {
            return .lightContent
        }else{
            return .default
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        addConstraint()
        setDatas()
        _ = KRLaunguageBase.getSubjectAsobsever().subscribe({[weak self] (event) in
            guard let mySelf = self else{return}
            mySelf.ModifyLanguage()
        })
    }
    //
    //MARK:收到修改文字的通知
    @objc func ModifyLanguage(){
        
    }
    
    //MARK:设置数据
    public func setDatas(){
        
    }
    
    //MARK:添加约束
    public func addConstraint(){
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
