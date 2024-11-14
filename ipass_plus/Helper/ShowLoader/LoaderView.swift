//
//  LoaderView.swift
//  ipass_plus
//
//  Created by MOBILE on 29/02/24.
//

import Foundation
import PKHUD

class Loader {
    static func show() {
        HUD.show(.progress)
    }

    static func hide() {
        HUD.hide()
    }
}
