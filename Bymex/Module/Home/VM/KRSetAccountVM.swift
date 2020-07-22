//
//  KRSetAccountVM.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/23.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift

class KRSetAccountVM: NSObject {
    let disposeBag = DisposeBag()
}

extension KRSetAccountVM {
    // 解绑GOOGLE验证器
    func delGoogleSerialCode(ga_code: String,_ completeHandle: @escaping ((Bool) -> ())) {
        appAPI.rx.request(AppAPIEndPoint.gaKey(action: "delete", ga_code: ga_code)).MJObjectMap(NSDictionary.self).subscribe(onSuccess: { (result) in
            completeHandle(true)
        }) { (error) in
            print(error)
            completeHandle(false)
        }.disposed(by: self.disposeBag)
    }
}

struct ArrowConfig: PatternLockViewConfig {
    var matrix: Matrix = Matrix(row: 3, column: 3)
    var gridSize: CGSize = CGSize(width: 70, height: 70)
    var connectLine: ConnectLine?
    var autoMediumGridsConnect: Bool = false
    var connectLineHierarchy: ConnectLineHierarchy = .bottom
    var errorDisplayDuration: TimeInterval = 1
    var initGridClosure: (Matrix) -> (PatternLockGrid)

    init() {
        let normalColor = UIColor.ThemeLabel.colorDark
        let tintColor = UIColor.ThemeLabel.colorHighlight
        initGridClosure = {(matrix) -> PatternLockGrid in
            let gridView = GridView()
            let outerStrokeLineWidthStatus = GridPropertyStatus<CGFloat>.init(normal: 1, connect: 2, error: 2)
            let outerStrokeColorStatus = GridPropertyStatus<UIColor>(normal: normalColor, connect: tintColor, error: .red)
            gridView.outerRoundConfig = RoundConfig(radius: 33, lineWidthStatus: outerStrokeLineWidthStatus, lineColorStatus: outerStrokeColorStatus, fillColorStatus: nil)
            let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: tintColor, error: .red)
            gridView.innerRoundConfig = RoundConfig(radius: 10, lineWidthStatus: nil, lineColorStatus: nil, fillColorStatus: innerFillColorStatus)
            return gridView
        }
        let lineView = ConnectLineView()
        lineView.lineColorStatus = .init(normal: tintColor, error: .red)
        lineView.triangleColorStatus = .init(normal: tintColor, error: .red)
        lineView.isTriangleHidden = false
        lineView.lineWidth = 3
        connectLine = lineView
    }
}


class KRGoogleEntity: SuperEntity {
    var ga_key = ""
    var login_name = ""
}
