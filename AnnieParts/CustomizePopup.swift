//
//  CustomizePopup.swift
//  AnnieParts
//
//  Created by Ryan Yue on 8/11/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import Foundation
import Presentr

func initializePresentr() -> Presentr {
    let width = ModalSize.Default
    let height = ModalSize.Custom(size: 200)
    let center = ModalCenterPosition.TopCenter
    let presenter = Presentr(presentationType: .Custom(width: width, height: height, center: center))
    presenter.blurBackground = true
    
    return presenter
}