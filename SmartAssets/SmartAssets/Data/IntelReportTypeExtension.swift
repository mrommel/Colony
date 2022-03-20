//
//  IntelReportTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 20.03.22.
//

import SmartAILibrary

extension IntelReportType {

    public func title() -> String {

        switch self {

        case .action: return "TXT_KEY_DIPLOMACY_INTEL_REPORT_ACTION"
        case .overview: return "TXT_KEY_DIPLOMACY_INTEL_REPORT_OVERVIEW"
        case .gossip: return "TXT_KEY_DIPLOMACY_INTEL_REPORT_GOSSIP"
        case .accessLevel: return "TXT_KEY_DIPLOMACY_INTEL_REPORT_ACCESS_LEVEL"
        case .government: return "TXT_KEY_DIPLOMACY_INTEL_REPORT_GOVERNMENT"
        case .agendas: return "TXT_KEY_DIPLOMACY_INTEL_REPORT_AGENDAS"
        case .ownRelationship: return "TXT_KEY_DIPLOMACY_INTEL_REPORT_RELATIONSHIP"
        case .otherRelationships: return "TXT_KEY_DIPLOMACY_INTEL_REPORT_OTHER_RELATIONSHIPS"
        }
    }

    public func buttonTexture() -> String {

        switch self {

        case .action: return "intelReportType-button-action"
        case .overview: return "intelReportType-button-overview"
        case .gossip: return "intelReportType-button-gossip"
        case .accessLevel: return "intelReportType-button-accessLevel"
        case .government: return ""
        case .agendas: return ""
        case .ownRelationship: return "intelReportType-button-ownRelationship"
        case .otherRelationships: return ""
        }
    }

    public func iconTexture() -> String {

        switch self {

        case .action: return ""
        case .overview: return ""
        case .gossip: return "intelReportType-gossip"
        case .accessLevel: return "intelReportType-accessLevel"
        case .government: return "intelReportType-government"
        case .agendas: return "intelReportType-agendas"
        case .ownRelationship: return "intelReportType-ownRelationship"
        case .otherRelationships: return "intelReportType-otherRelationships"
        }
    }
}
