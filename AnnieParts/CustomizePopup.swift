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
    presenter.transitionType = .CrossDissolve
    presenter.dismissTransitionType = .CrossDissolve
    presenter.roundCorners = false
    
    return presenter
}

func notificationPresentr() -> Presentr {
    let width = ModalSize.Default
    let height = ModalSize.Default
    let center = ModalCenterPosition.Center
    let presenter = Presentr(presentationType: .Custom(width: width, height: height, center: center))
    presenter.backgroundOpacity = 0.1
    presenter.transitionType = .CrossDissolve
    presenter.dismissTransitionType = .CrossDissolve
    return presenter
}

func orderSummaryPresentr() -> Presentr {
    let width = ModalSize.Full
    let height = ModalSize.Full
    let center = ModalCenterPosition.Center
    let presenter = Presentr(presentationType: .Custom(width: width, height: height, center: center))
    presenter.backgroundOpacity = 0.3
    presenter.blurBackground = true
    presenter.transitionType = .CrossDissolve
    presenter.dismissTransitionType = .CrossDissolve
    presenter.roundCorners = false
    return presenter
}