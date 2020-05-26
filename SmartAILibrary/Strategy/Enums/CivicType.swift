//
//  CivicType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public struct CivicAchievements {

    public let buildingTypes: [BuildingType]
    public let unitTypes: [UnitType]
    public let wonderTypes: [WonderType]
    public let buildTypes: [BuildType]
    public let policyCards: [PolicyCardType]
}

public enum CivicType: String, Codable {

    case none

    // ancient
    case stateWorkforce
    case craftsmanship
    case codeOfLaws
    case earlyEmpire
    case foreignTrade
    case mysticism
    case militaryTradition

    // classical
    case defensiveTactics
    case gamesAndRecreation
    case politicalPhilosophy
    case recordedHistory
    case dramaAndPoetry
    case theology
    case militaryTraining

    // medieval
    case navalTradition
    case feudalism
    case medievalFaires
    case civilService
    case guilds
    case mercenaries
    case divineRight

    // renaissance
    case enlightenment
    case humanism
    case mercantilism
    case diplomaticService
    case exploration
    case reformedChurch

    // industrial
    case civilEngineering
    case colonialism
    case nationalism
    case operaAndBallet
    case naturalHistory
    case urbanization
    case scorchedEarth

    // modern
    case conservation
    case massMedia
    case mobilization
    case capitalism
    case ideology
    case nuclearProgram
    case suffrage
    case totalitarianism
    case classStruggle

    // atomic
    case culturalHeritage
    case coldWar
    case professionalSports
    case rapidDeployment
    case spaceRace


    static var all: [CivicType] {
        return [
            // ancient
            .stateWorkforce, .craftsmanship, .codeOfLaws, .earlyEmpire, .foreignTrade, .mysticism, .militaryTradition,

            // classical
            .defensiveTactics, .gamesAndRecreation, .politicalPhilosophy, .recordedHistory, .dramaAndPoetry, .theology, .militaryTraining,

            // medieval
            .navalTradition, .feudalism, .medievalFaires, .civilService, .guilds, .mercenaries, .divineRight,

            // renaissance
            .enlightenment, .humanism, .mercantilism, .diplomaticService, .exploration, .reformedChurch,

            // industrial
            .civilEngineering, .colonialism, .nationalism, .operaAndBallet, .naturalHistory, .urbanization, .scorchedEarth,

            // modern
            .conservation, .massMedia, .mobilization, .capitalism, .ideology, .nuclearProgram, .suffrage, .totalitarianism, .classStruggle,

            // atomic
            .culturalHeritage, .coldWar, .professionalSports, .rapidDeployment, .spaceRace
        ]
    }

    public func name() -> String {

        return self.data().name
    }

    public func eurekaSummary() -> String {

        return self.data().eurekaSummary
    }
    
    public func eurekaDescription() -> String {

        return self.data().eurekaDescription
    }
    
    public func quoteText() -> String {
        
        return "quote"
    }

    public func era() -> EraType {

        return self.data().era
    }

    public func cost() -> Int {

        return self.data().cost
    }

    // https://github.com/caiobelfort/civ6_personal_mod/blob/9fdf8736016d855990556c71cc76a62f124f5822/Gameplay/Data/Civics.xml
    func required() -> [CivicType] {

        return self.data().required
    }

    func leadsTo() -> [CivicType] {

        var leadingTo: [CivicType] = []

        for tech in CivicType.all {
            if tech.required().contains(self) {
                leadingTo.append(tech)
            }
        }

        return leadingTo
    }

    func flavorValue(for flavor: FlavorType) -> Int {

        if let flavorOfTech = self.flavours().first(where: { $0.type == flavor }) {
            return flavorOfTech.value
        }

        return 0
    }

    func flavours() -> [Flavor] {

        return self.data().flavors
    }

    public func achievements() -> CivicAchievements {

        let buildings = BuildingType.all.filter({
            if let civic = $0.requiredCivic() {
                return civic == self
            } else {
                return false
            }
        })

        /*let units = UnitType.all.filter({
            if let civic = $0.required() {
                return civic == self
            } else {
                return false
            }
        })*/

        // districts
        // wonders
        let wonders = WonderType.all.filter({
            if let civic = $0.requiredCivic() {
                return civic == self
            } else {
                return false
            }
        })

        // buildtypes
        /*let builds = BuildType.all.filter({
            if let civic = $0.required() {
                return civic == self
            } else {
                return false
            }
        })*/

        // policyCards
        let policyCards = PolicyCardType.all.filter({
            return self == $0.required()
        })

        return CivicAchievements(buildingTypes: buildings, unitTypes: [], wonderTypes: wonders, buildTypes: [], policyCards: policyCards)
    }

    // MARK private

    private struct CivicTypeData {

        let name: String
        let eurekaSummary: String
        let eurekaDescription: String
        let era: EraType
        let cost: Int
        let required: [CivicType]
        let flavors: [Flavor]
    }

    private func data() -> CivicTypeData {

        switch self {

        case .none: return CivicTypeData(
            name: "---",
            eurekaSummary: "---",
            eurekaDescription: "-",
            era: .ancient,
            cost: -1,
            required: [],
            flavors: []
            )

            // ancient
        case .codeOfLaws:
            return CivicTypeData(name: "Code of Laws",
                                 eurekaSummary: "-",
                                 eurekaDescription: "",
                                 era: .ancient,
                                 cost: 20,
                                 required: [],
                                 flavors: [])
        case .stateWorkforce:
            return CivicTypeData(name: "State Workforce",
                                 eurekaSummary: "",
                                 eurekaDescription: "",
                                 era: .ancient,
                                 cost: 70,
                                 required: [.craftsmanship],
                                 flavors: [])
        case .craftsmanship:
            return CivicTypeData(name: "Craftmanship",
                                 eurekaSummary: "",
                                 eurekaDescription: "With the land around our first city developing nicely, we can fine tune our production techniques.",
                                 era: .ancient,
                                 cost: 40,
                                 required: [.codeOfLaws],
                                 flavors: [])
        case .earlyEmpire:
            return CivicTypeData(name: "Early Empire",
                                 eurekaSummary: "",
                                 eurekaDescription: "The growing number of citizens in your lands dream of having an empire.",
                                 era: .ancient,
                                 cost: 70,
                                 required: [.foreignTrade],
                                 flavors: [])
        case .foreignTrade:
            return CivicTypeData(name: "Foreign Trade",
                                 eurekaSummary: "",
                                 eurekaDescription: "Having discovered another continent we realize there is a wide world of trading opportunities.",
                                 era: .ancient,
                                 cost: 40,
                                 required: [.codeOfLaws],
                                 flavors: [])
        case .mysticism:
            return CivicTypeData(name: "Mysticism",
                                 eurekaSummary: "",
                                 eurekaDescription: "Worship of your pantheon of gods has brought up further questions about spiritual forces in our world.",
                                 era: .ancient,
                                 cost: 50,
                                 required: [.foreignTrade],
                                 flavors: [])
        case .militaryTradition:
            return CivicTypeData(name: "Military Tradition",
                                 eurekaSummary: "",
                                 eurekaDescription: "Your soldiers hope your victory over a Barbarian Outpost is the start of a long line of military successes.",
                                 era: .ancient,
                                 cost: 50,
                                 required: [.craftsmanship],
                                 flavors: [])

            // classical
        case .defensiveTactics:
            return CivicTypeData(name: "Defensive Tactics",
                                 eurekaSummary: "",
                                 eurekaDescription: "Faced with the threat of invasion, your people are ready to come up with innovative defenses.",
                                 era: .classical,
                                 cost: 175,
                                 required: [.gamesAndRecreation, .politicalPhilosophy],
                                 flavors: [])
        case .gamesAndRecreation:
            return CivicTypeData(name: "Games and Recreation",
                                 eurekaSummary: "",
                                 eurekaDescription: "Your new skills in construction will surely help create venues for games and entertainment.",
                                 era: .classical,
                                 cost: 110,
                                 required: [.stateWorkforce],
                                 flavors: [])
        case .politicalPhilosophy:
            return CivicTypeData(name: "Political Philosophy",
                                 eurekaSummary: "",
                                 eurekaDescription: "Your contact with other states has crystallized your ideas on governing your own people.",
                                 era: .classical,
                                 cost: 110,
                                 required: [.stateWorkforce, .earlyEmpire],
                                 flavors: [])
        case .recordedHistory:
            return CivicTypeData(name: "Recorded History",
                                 eurekaSummary: "",
                                 eurekaDescription: "With plans to house many scrolls in the libraries of your campuses, your people begin to record the history of your empire.",
                                 era: .classical,
                                 cost: 175,
                                 required: [.politicalPhilosophy, .dramaAndPoetry],
                                 flavors: [])
        case .dramaAndPoetry:
            return CivicTypeData(name: "Dramaa nd Poetry",
                                 eurekaSummary: "",
                                 eurekaDescription: "The glory of completing a wonder has energized your people. They are writing works to commemorate this great event.",
                                 era: .classical,
                                 cost: 110,
                                 required: [.earlyEmpire],
                                 flavors: [])
        case .theology:
            return CivicTypeData(name: "Theology",
                                 eurekaSummary: "",
                                 eurekaDescription: "The formation of a Religion by your Great Prophet inspires deeper thought on the nature of the divine.",
                                 era: .classical,
                                 cost: 120,
                                 required: [.dramaAndPoetry, .mysticism],
                                 flavors: [])
        case .militaryTraining:
            return CivicTypeData(name: "Military Training",
                                 eurekaSummary: "",
                                 eurekaDescription: "With an Encampment now in place, we can formalize our military training.",
                                 era: .classical,
                                 cost: 120,
                                 required: [.militaryTradition, .gamesAndRecreation],
                                 flavors: [])

            // medieval
        case .navalTradition:
            return CivicTypeData(name: "Naval Tradition",
                                 eurekaSummary: "",
                                 eurekaDescription: "Your victory at sea inspires your people to strive to become a naval power.",
                                 era: .medieval,
                                 cost: 200,
                                 required: [.defensiveTactics],
                                 flavors: [])
        case .medievalFaires:
            return CivicTypeData(name: "Medieval Faires",
                                 eurekaSummary: "",
                                 eurekaDescription: "The increase of commerce through your lands will soon attract a trade fair.",
                                 era: .medieval,
                                 cost: 385,
                                 required: [.feudalism],
                                 flavors: [])
        case .guilds:
            return CivicTypeData(name: "Guilds",
                                 eurekaSummary: "",
                                 eurekaDescription: "The success of your commercial districts has spurred the growth of trade guilds.",
                                 era: .medieval,
                                 cost: 385,
                                 required: [.feudalism, .civilService],
                                 flavors: [])
        case .feudalism:
            return CivicTypeData(name: "Feudalism",
                                 eurekaSummary: "",
                                 eurekaDescription: "A system of lords and vassals is forming to manage all the farmlands of your empire.",
                                 era: .medieval,
                                 cost: 275,
                                 required: [.defensiveTactics],
                                 flavors: [])
        case .civilService:
            return CivicTypeData(name: "Civil Service",
                                 eurekaSummary: "",
                                 eurekaDescription: "Your large urban center will soon require a corps of bureaucrats.",
                                 era: .medieval,
                                 cost: 275,
                                 required: [.defensiveTactics, .recordedHistory],
                                 flavors: [])
        case .mercenaries:
            return CivicTypeData(name: "Mercenaries",
                                 eurekaSummary: "",
                                 eurekaDescription: "With such a large standing army, you may want to consider adding mercenaries if your army needs to expand further.",
                                 era: .medieval,
                                 cost: 290,
                                 required: [.feudalism, .militaryTraining],
                                 flavors: [])
        case .divineRight:
            return CivicTypeData(name: "Divine Right",
                                 eurekaSummary: "",
                                 eurekaDescription: "Your devout people believe strongly that your rule is a blessing from the divine.",
                                 era: .medieval,
                                 cost: 290,
                                 required: [.civilService, .theology],
                                 flavors: [])

            // renaissance
        case .humanism:
            return CivicTypeData(name: "Humanism",
                                 eurekaSummary: "",
                                 eurekaDescription: "The inspiration provided by your newly-acquired Great Artist is awakening our people to the power of the individual.",
                                 era: .renaissance,
                                 cost: 540,
                                 required: [.guilds, .medievalFaires],
                                 flavors: [])
        case .mercantilism:
            return CivicTypeData(name: "Mercantilism",
                                 eurekaSummary: "",
                                 eurekaDescription: "Your new Great Merchant is sharing ideas on how we can get the edge on our economic competitors.",
                                 era: .renaissance,
                                 cost: 655,
                                 required: [.humanism],
                                 flavors: [])
        case .enlightenment:
            return CivicTypeData(name: "Enlightenment",
                                 eurekaSummary: "",
                                 eurekaDescription: "The ideas from your great people have inspired intellectual discussion throughout the land.",
                                 era: .renaissance,
                                 cost: 655,
                                 required: [.diplomaticService],
                                 flavors: [])
        case .diplomaticService:
            return CivicTypeData(name: "Diplomatic Service",
                                 eurekaSummary: "",
                                 eurekaDescription: "The legwork to build an alliance has trained up your first corps of diplomats.",
                                 era: .renaissance,
                                 cost: 540,
                                 required: [.guilds],
                                 flavors: [])
        case .reformedChurch:
            return CivicTypeData(name: "Reformed Church",
                                 eurekaSummary: "",
                                 eurekaDescription: "The growth of your Religion comes with the danger of schism. Reforming corrupt church practices better happen soon!",
                                 era: .renaissance,
                                 cost: 400,
                                 required: [.divineRight],
                                 flavors: [])
        case .exploration:
            return CivicTypeData(name: "Exploration",
                                 eurekaSummary: "",
                                 eurekaDescription: "The lessons you have learned from Caravel exploration have led to a new way of governing your people.",
                                 era: .renaissance,
                                 cost: 400,
                                 required: [.mercenaries, .medievalFaires],
                                 flavors: [])

            // industrial
        case .civilEngineering:
            return CivicTypeData(name: "Civil Engineering",
                                 eurekaSummary: "",
                                 eurekaDescription: "Having constructed so many types of districts, your engineers have become skilled in city construction.",
                                 era: .industrial,
                                 cost: 920,
                                 required: [.mercantilism],
                                 flavors: [])
        case .colonialism:
            return CivicTypeData(name: "Colonialism",
                                 eurekaSummary: "",
                                 eurekaDescription: "Your new knowledge of the heavens is helping your navy navigate and establish a global empire.",
                                 era: .industrial,
                                 cost: 725,
                                 required: [.mercantilism],
                                 flavors: [])
        case .nationalism:
            return CivicTypeData(name: "Nationalism",
                                 eurekaSummary: "",
                                 eurekaDescription: "Your people believe in the just nature of this war.  It has become an issue of national pride for us!",
                                 era: .industrial,
                                 cost: 920,
                                 required: [.enlightenment],
                                 flavors: [])
        case .operaAndBallet:
            return CivicTypeData(name: "Opera and Ballet",
                                 eurekaSummary: "",
                                 eurekaDescription: "The unveiling of a new museum is drawing people to the arts. Perhaps dance and opera are next?",
                                 era: .industrial,
                                 cost: 725,
                                 required: [.enlightenment],
                                 flavors: [])
        case .naturalHistory:
            return CivicTypeData(name: "Natural History",
                                 eurekaSummary: "",
                                 eurekaDescription: "With a museum now ready to hold your findings, it is time to see what you can discover out in the natural world.",
                                 era: .industrial,
                                 cost: 870,
                                 required: [.colonialism],
                                 flavors: [])
        case .urbanization:
            return CivicTypeData(name: "Urbanization",
                                 eurekaSummary: "",
                                 eurekaDescription: "Your large city is getting overcrowded. It's time to start planning for some suburbs.",
                                 era: .industrial,
                                 cost: 1060,
                                 required: [.civilEngineering, .nationalism],
                                 flavors: [])
        case .scorchedEarth:
            return CivicTypeData(name: "Scorched Earth",
                                 eurekaSummary: "",
                                 eurekaDescription: "Modern warfare is clearly a brutal affair. Your military doctrine is starting to reflect some of these principles of total war.",
                                 era: .industrial,
                                 cost: 1060,
                                 required: [.nationalism],
                                 flavors: [])

            // modern
        case .conservation:
            return CivicTypeData(name: "Conservation",
                                 eurekaSummary: "",
                                 eurekaDescription: "The residents of your breathtaking new neighborhood clamor for a plan to conserve all the world’s natural treasures.",
                                 era: .modern,
                                 cost: 1255,
                                 required: [.naturalHistory, .urbanization],
                                 flavors: [])
        case .massMedia:
            return CivicTypeData(name: "MassMedia",
                                 eurekaSummary: "",
                                 eurekaDescription: "The advent of radio beckons the start of a new era of communication.",
                                 era: .modern,
                                 cost: 1410,
                                 required: [.urbanization],
                                 flavors: [])
        case .mobilization:
            return CivicTypeData(name: "Mobilization",
                                 eurekaSummary: "",
                                 eurekaDescription: "Your military is better organized. Now time to take your force to the world stage.",
                                 era: .modern,
                                 cost: 1410,
                                 required: [.urbanization],
                                 flavors: [])
        case .capitalism:
            return CivicTypeData(name: "Capitalism",
                                 eurekaSummary: "",
                                 eurekaDescription: "With stock exchanges springing up in several cities, investment capital is plentiful and a market economy is ready to emerge.",
                                 era: .modern,
                                 cost: 1560,
                                 required: [.massMedia],
                                 flavors: [])
        case .ideology:
            return CivicTypeData(name: "Ideology",
                                 eurekaSummary: "",
                                 eurekaDescription: "",
                                 era: .modern,
                                 cost: 660,
                                 required: [.massMedia, .mobilization],
                                 flavors: [])
        case .nuclearProgram:
            return CivicTypeData(name: "Nuclear Program",
                                 eurekaSummary: "",
                                 eurekaDescription: "With a dedicated research lab in place, your initiative to recruit scientists into a nuclear research program can commence.",
                                 era: .modern,
                                 cost: 1715,
                                 required: [.ideology],
                                 flavors: [])
        case .suffrage:
            return CivicTypeData(name: "Suffrage",
                                 eurekaSummary: "",
                                 eurekaDescription: "The women of your empire have clamored for proper sanitation. Having won that battle, they now need the right to vote.",
                                 era: .modern,
                                 cost: 1715,
                                 required: [.ideology],
                                 flavors: [])
        case .totalitarianism:
            return CivicTypeData(name: "Totalitarianism",
                                 eurekaSummary: "",
                                 eurekaDescription: "The discipline instilled by your military academies is now second nature to your citizens.",
                                 era: .modern,
                                 cost: 1715,
                                 required: [.ideology],
                                 flavors: [])
        case .classStruggle:
            return CivicTypeData(name: "Class Struggle",
                                 eurekaSummary: "",
                                 eurekaDescription: "Your factory workers clamor for better working conditions. It is time for the workers of the world to unite!",
                                 era: .modern,
                                 cost: 1715,
                                 required: [.ideology],
                                 flavors: [])

            // atomic
        case .culturalHeritage:
            return CivicTypeData(name: "Cultural Heritage",
                                 eurekaSummary: "",
                                 eurekaDescription: "With a perfectly curated museum, your people's strong cultural heritage is on exhibit for all to see.",
                                 era: .atomic,
                                 cost: 1955,
                                 required: [.conservation],
                                 flavors: [])
        case .coldWar:
            return CivicTypeData(name: "Cold War",
                                 eurekaSummary: "",
                                 eurekaDescription: "The advent of nuclear weaponry will surely change the nature of armed conflict across the globe.",
                                 era: .atomic,
                                 cost: 2185,
                                 required: [.ideology],
                                 flavors: [])
        case .professionalSports:
            return CivicTypeData(name: "Professional Sports",
                                 eurekaSummary: "",
                                 eurekaDescription: "Your 4 cites with Entertainment Complexes want to compete in a new professional sports league.",
                                 era: .atomic,
                                 cost: 2185,
                                 required: [.ideology],
                                 flavors: [])
        case .rapidDeployment:
            return CivicTypeData(name: "Rapid Deployment",
                                 eurekaSummary: "",
                                 eurekaDescription: "With air bases now spanning the globe, our military is ready to be deployed anywhere in the world at a moment's notice.",
                                 era: .atomic,
                                 cost: 2415,
                                 required: [.coldWar],
                                 flavors: [])
        case .spaceRace:
            return CivicTypeData(name: "Space Race",
                                 eurekaSummary: "",
                                 eurekaDescription: "The unveiling of your new Spaceport has energized your people to push into space.",
                                 era: .atomic,
                                 cost: 2415,
                                 required: [.coldWar],
                                 flavors: [])
        /* <Replace Language="sv_SE" Tag="LOC_BOOST_TRIGGER_LONGDESC_GLOBALIZATION">
            <Text>With so many airports in place, the world is truly becoming a smaller place.</Text>
        </Replace>
        <Replace Language="sv_SE" Tag="LOC_BOOST_TRIGGER_LONGDESC_SOCIAL_MEDIA">
            <Text>Your advances in communications technology are allowing people to congregate online.</Text>
        </Replace> */
        }
    }
}
