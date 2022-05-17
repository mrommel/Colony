//
//  GovernmentTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 12.05.21.
//

import SmartAILibrary

extension GovernmentType {

    public func toolTip() -> NSAttributedString {

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: self.name().localized(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)
        toolTipText.append(NSAttributedString(string: "\n\n"))

        let tokenizer = LabelTokenizer()
        for effect in [self.bonus1Summary(), self.bonus2Summary()] {
            let effectText = tokenizer.convert(text: effect, with: Globals.Attributs.tooltipContentAttributs)
            toolTipText.append(NSAttributedString(string: "\n"))
            toolTipText.append(effectText)
        }

        return toolTipText
    }

    public func iconTexture() -> String {

        switch self {

            // ancient
        case .chiefdom: return "government-chiefdom"

            // classical
        case .autocracy: return "government-autocracy"
        case .classicalRepublic: return "government-classicalRepublic"
        case .oligarchy: return "government-oligarchy"

            //
        case .merchantRepublic: return "government-merchantRepublic"
        case .monarchy: return "government-monarchy"
        case .theocracy: return "government-theocracy"

            // modern
        case .fascism: return "government-fascism"
        case .communism: return "government-communism"
        case .democracy: return "government-democracy"
        }
    }

    public func ambientTexture() -> String {

        switch self {

            // ancient
        case .chiefdom: return "government-ambient-chiefdom"

            // classical
        case .autocracy: return "government-ambient-autocracy"
        case .classicalRepublic: return "government-ambient-classicalRepublic"
        case .oligarchy: return "government-ambient-oligarchy"

            //
        case .merchantRepublic: return "government-ambient-merchantRepublic"
        case .monarchy: return "government-ambient-monarchy"
        case .theocracy: return "government-ambient-theocracy"

            // modern
        case .fascism: return "government-ambient-fascism"
        case .communism: return "government-ambient-communism"
        case .democracy: return "government-ambient-democracy"
        }
    }

    public func legendColor() -> TypeColor {

        switch self {

            // ancient
        case .chiefdom: return Globals.Colors.governmentChiefdom

            // classical
        case .autocracy: return Globals.Colors.governmentAutocracy
        case .classicalRepublic: return Globals.Colors.governmentClassicalRepublic
        case .oligarchy: return Globals.Colors.governmentOligarchy

            //
        case .merchantRepublic: return Globals.Colors.governmentMerchantRepublic
        case .monarchy: return Globals.Colors.governmentMonarchy
        case .theocracy: return Globals.Colors.governmentTheocracy

            // modern
        case .fascism: return Globals.Colors.governmentFascism
        case .communism: return Globals.Colors.governmentCommunism
        case .democracy: return Globals.Colors.governmentDemocracy
        }
    }

    public func legendText() -> String {

        return self.name()
    }
}
