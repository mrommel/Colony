//
//  BaseDialog.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 01.09.21.
//

import SwiftUI
import SmartAssets

protocol BaseDialogViewModel: AnyObject {

    func closeDialog()
}

#if DEBUG
class BaseDialogViewModelImpl: BaseDialogViewModel {

    func closeDialog() {

    }
}
#endif
