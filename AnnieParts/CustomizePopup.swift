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
    let width = ModalSize.default
    let height = ModalSize.custom(size: 200)
    let center = ModalCenterPosition.topCenter
    let presenter = Presentr(presentationType: .custom(width: width, height: height, center: center))
    presenter.blurBackground = true
    presenter.transitionType = .crossDissolve
    presenter.dismissTransitionType = .crossDissolve
    presenter.roundCorners = false
    
    return presenter
}

func notificationPresentr() -> Presentr {
    let width = ModalSize.default
    let height = ModalSize.default
    let center = ModalCenterPosition.center
    let presenter = Presentr(presentationType: .custom(width: width, height: height, center: center))
    presenter.backgroundOpacity = 0.1
    presenter.transitionType = TransitionType.crossDissolve
    presenter.dismissTransitionType = TransitionType.crossDissolve
    return presenter
}

func orderSummaryPresentr() -> Presentr {
    let width = ModalSize.full
    let height = ModalSize.full
    let center = ModalCenterPosition.center
    let presenter = Presentr(presentationType: .custom(width: width, height: height, center: center))
    presenter.backgroundOpacity = 0.3
    presenter.blurBackground = true
    presenter.transitionType = TransitionType.crossDissolve
    presenter.dismissTransitionType = TransitionType.crossDissolve
    presenter.roundCorners = false
    return presenter
}

func orderNumberPresentr() -> Presentr {
    let presenter = Presentr(presentationType: .custom(width: ModalSize.default, height: ModalSize.custom(size: 200), center: ModalCenterPosition.center))
    presenter.backgroundOpacity = 0.3
    presenter.transitionType = TransitionType.crossDissolve
    presenter.dismissTransitionType = TransitionType.crossDissolve
    presenter.roundCorners = false
    presenter.dismissOnTap = false
    return presenter
}
