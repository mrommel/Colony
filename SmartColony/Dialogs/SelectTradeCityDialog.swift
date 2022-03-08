//
//  SelectTradeCityDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 20.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

class SelectTradeCityDialogViewModel {

    let start: AbstractCity?
    let cities: [AbstractCity?]

    init(start: AbstractCity?, cities: [AbstractCity?]) {

        self.start = start
        self.cities = cities
    }
}

class SelectTradeCityDialog: Dialog {

    // variables
    var viewModel: SelectTradeCityDialogViewModel

    fileprivate var cityResultHandler: ((_ city: AbstractCity?) -> Void)?

    // nodes
    var scrollNode: ScrollNode?
    var cityNodes: [MessageBoxButtonNode] = []

    // MARK: Constructors

    init(with viewModel: SelectTradeCityDialogViewModel) {

        self.viewModel = viewModel

        let uiParser = UIParser()
        guard let selectTradeCityDialogConfiguration = uiParser.parse(from: "SelectTradeCityDialog") else {
            fatalError("cant load SelectTradeCityDialog configuration")
        }

        super.init(from: selectTradeCityDialogConfiguration)

        // fill in data from view model
        guard let startCity = self.viewModel.start else {
            fatalError("cant get start city of trade route")
        }

        self.set(text: NSMutableAttributedString().normal("The route starts at ").bold(startCity.name), identifier: "route_starts")
        self.setupScrollView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addCityResultHandler(handler: @escaping (_ city: AbstractCity?) -> Void) {
        self.cityResultHandler = handler
    }

    // MARK: private functions

    private func setupScrollView() {

        // scroll area
        self.scrollNode = ScrollNode(
            size: CGSize(width: 310, height: 370),
            contentSize: CGSize(width: 310, height: self.viewModel.cities.count / 3 * 50 + 10)
        )
        self.scrollNode?.position = CGPoint(x: 0, y: -400)
        self.scrollNode?.zPosition = self.zPosition + 1
        self.addChild(self.scrollNode!)

        for city in self.viewModel.cities {

            guard let civilization = city?.player?.leader.civilization() else {
                continue
            }

            let cityNode = MessageBoxButtonNode(imageNamed: civilization.iconTexture(),
                                                title: city?.name ?? "---",
                                                sized: CGSize(width: 200, height: 42),
                                                buttonAction: {

                // print("clicked of \(city?.name ?? "---")")
                if let cityResultHandler = self.cityResultHandler {
                    cityResultHandler(city)
                }
            })
            cityNode.zPosition = 199

            self.scrollNode?.addScrolling(child: cityNode)
            self.cityNodes.append(cityNode)
        }

        // make bottom buttons appear above scrollview
        self.item(with: "cancel_button")?.zPosition = 500

        self.updateLayout()
    }

    private func updateLayout() {

        let offsetY = self.scrollNode!.size.halfHeight - 50
        for (index, cityNode) in self.cityNodes.enumerated() {

            let dx: CGFloat = 0
            let dy: CGFloat = offsetY - CGFloat(index) * 50.0
            cityNode.position = CGPoint(x: dx, y: dy)

            // cityNode.updateLayout()
        }
    }
}
