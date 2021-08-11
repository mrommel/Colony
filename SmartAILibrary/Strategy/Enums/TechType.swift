//
//  TechType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public struct TechAchievements {
    
    public let buildingTypes: [BuildingType]
    public let unitTypes: [UnitType]
    public let wonderTypes: [WonderType]
    public let buildTypes: [BuildType]
    public let districtTypes: [DistrictType]
}

// https://github.com/fredzgreen/Civilization6_SwedishTranslation/blob/2591dc66a1674477a1857763d0b46e88d00a265b/XMLFiles/Technologies_Text.xml
public enum TechType: String, Codable {
    
    case none
    
    // ancient
    case mining
    case pottery
    case animalHusbandry
    case sailing
    case astrology
    case irrigation
    case writing
    case masonry
    case archery
    case bronzeWorking
    case wheel

    // classical
    case celestialNavigation
    case horsebackRiding
    case currency
    case construction
    case ironWorking
    case shipBuilding
    case mathematics
    case engineering

    // medieval
    case militaryTactics
    case buttress
    case apprenticeship
    case stirrups
    case machinery
    case education
    case militaryEngineering
    case castles

    // renaissance
    case cartography
    case massProduction
    case banking
    case gunpowder
    case printing
    case squareRigging
    case astronomy
    case metalCasting
    case siegeTactics
    
    // industrial
    case industrialization
    case scientificTheory
    case ballistics
    case militaryScience
    case steamPower
    case sanitation
    case economics
    case rifling
    
    // modern
    case flight
    case replaceableParts
    case steel
    case refining
    case electricity
    case radio
    case chemistry
    case combustrion
    
    // atomic
    case advancedFlight
    case rocketry
    case advancedBallistics
    case combinedArms
    case plastics
    case computers
    case nuclearFission
    case syntheticMaterials
    
    // information
    case telecommunications
    case satellites
    case guidanceSystems
    case lasers
    case composites
    case stealthTechnology
    case robotics
    case nuclearFusion
    case nanotechnology
    
    case futureTech

    public static var all: [TechType] {
        return [
            // ancient
            .mining, .pottery, .animalHusbandry, .sailing, .astrology, .irrigation, .writing, .masonry, .archery, .bronzeWorking, .wheel,
            
            // classical
            .celestialNavigation, horsebackRiding, .currency, .construction, .ironWorking, .shipBuilding, .mathematics, .engineering,
            
            // medieval
            .militaryTactics, .buttress, .apprenticeship, .stirrups, .machinery, .education, .militaryEngineering, .castles,
            
            // renaissance
            .cartography, .massProduction, .banking, .gunpowder, .printing, .squareRigging, .astronomy, .metalCasting, .siegeTactics,
            
            // industrial
            .industrialization, .scientificTheory, .ballistics, .militaryScience, .steamPower, .sanitation, .economics, .rifling,
            
            // modern
            .flight, .replaceableParts, .steel, .refining, .electricity, .radio, .chemistry, .combustrion,
            
            // atomic
            .advancedFlight, .rocketry, .advancedBallistics, .combinedArms, .plastics, .computers, .nuclearFission, .syntheticMaterials,
            
            // information
            .telecommunications, .satellites, .guidanceSystems, .lasers, .composites, .stealthTechnology, .robotics, .nuclearFusion,. nanotechnology,
            
            // future
            .futureTech
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
    
    public func quoteTexts() -> [String] {
        
        return self.data().quoteTexts
    }

    func era() -> EraType {

        return self.data().era
    }

    public func cost() -> Int {

        return self.data().cost
    }

    // https://github.com/caiobelfort/civ6_personal_mod/blob/9fdf8736016d855990556c71cc76a62f124f5822/Gameplay/Data/Technologies.xml
    func required() -> [TechType] {

        return self.data().required
    }

    func leadsTo() -> [TechType] {

        var leadingTo: [TechType] = []

        for tech in TechType.all {
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
    
    func isGoodyTech() -> Bool {
        
        return self.era() == .ancient
    }
    
    public func achievements() -> TechAchievements {
        
        let buildings = BuildingType.all.filter({
            if let tech = $0.requiredTech() {
                return tech == self
                
            } else {
                return false
            }
        })
        
        let units = UnitType.all.filter({
            if let tech = $0.requiredTech() {
                return tech == self
            } else {
                return false
            }
        })
        
        // districts
        let districts = DistrictType.all.filter({
            if let district = $0.requiredTech() {
                return district == self
            } else {
                return false
            }
        })
        
        // wonders
        let wonders = WonderType.all.filter({
            if let tech = $0.requiredTech() {
                return tech == self
            } else {
                return false
            }
        })
        
        // buildtypes
        let builds = BuildType.all.filter({
            if let tech = $0.required() {
                return tech == self
            } else {
                return false
            }
        })
            
        return TechAchievements(buildingTypes: buildings, unitTypes: units, wonderTypes: wonders, buildTypes: builds, districtTypes: districts)
    }
    
    // MARK private
    
    private struct TechTypeData {
        
        let name: String
        let eurekaSummary: String
        let eurekaDescription: String
        let quoteTexts: [String]
        let era: EraType
        let cost: Int
        let required: [TechType]
        let flavors: [Flavor]
    }
    
    private func data() -> TechTypeData {
        
        switch self {

        case .none:
            return TechTypeData(name: "---",
                                eurekaSummary: "",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .ancient,
                                cost: -1,
                                required: [],
                                flavors: [])
            
            // ancient
        case .mining:
            return TechTypeData(name: "Mining",
                                eurekaSummary: "",
                                eurekaDescription: "",
                                quoteTexts: ["”Who deserves more credit than the wife of a coal miner?” [NEWLINE]– Merle Travis", "vWhen you find yourself in a hole, quit digging.” [NEWLINE]- Will Rogers"],
                                era: .ancient,
                                cost: 25,
                                required: [],
                                flavors: [Flavor(type: .production, value: 3), Flavor(type: .tileImprovement, value: 2)])
        case .pottery:
            return TechTypeData(name: "Pottery",
                                eurekaSummary: "",
                                eurekaDescription: "",
                                quoteTexts: ["“No man ever wetted clay and then left it, as if there would be bricks by chance and fortune.” [NEWLINE]- Plutarch", "“I thought clay must feel happy in the good potter’s hand.” [NEWLINE]– Janet Fitch"],
                                era: .ancient,
                                cost: 25,
                                required: [],
                                flavors: [Flavor(type: .growth, value: 5)])
        case .animalHusbandry:
            return TechTypeData(name: "Animal Husbandry",
                                eurekaSummary: "",
                                eurekaDescription: "",
                                quoteTexts: ["“If there are no dogs in Heaven, then when I die I want to go where they went.“ [NEWLINE]- Will Rogers", "“I am fond of pigs. Dogs look up to us. Cats look down on us. Pigs treat us as equals.” [NEWLINE]- Winston S. Churchill "],
                                era: .ancient,
                                cost: 25,
                                required: [],
                                flavors: [Flavor(type: .mobile, value: 4), Flavor(type: .tileImprovement, value: 1)])
        case .sailing:
            return TechTypeData(name: "Sailing",
                                eurekaSummary: "Found a city on the Coast",
                                eurekaDescription: "Founding a city on the Coast has given your civilization insight into navigating the waves.",
                                quoteTexts: ["“Vessels large may venture more, but little boats should keep near shore.“ [NEWLINE]-Benjamin Franklin", "“It is not that life ashore is distasteful to me. But life at sea is better.” [NEWLINE]– Sir Francis Drake"],
                                era: .ancient,
                                cost: 50,
                                required: [],
                                flavors: [Flavor(type: .naval, value: 3), Flavor(type: .navalTileImprovement, value: 3), Flavor(type: .wonder, value: 3), Flavor(type: .navalRecon, value: 2)])
        case .astrology:
            return TechTypeData(name: "Astrology",
                                eurekaSummary: "Find a Natural Wonder",
                                eurekaDescription: "Discovering a natural wonder has inspired your people with the majesty of the universe.",
                                quoteTexts: ["“I don’t believe in astrology; I’m a Sagittarius and we’re skeptical.” [NEWLINE]– Arthur C. Clarke", "“A physician without a knowledge of astrology has no right to call himself a physician.” [NEWLINE]- Hippocrates"],
                                era: .ancient,
                                cost: 50,
                                required: [],
                                flavors: [Flavor(type: .happiness, value: 10), Flavor(type: .tileImprovement, value: 2), Flavor(type: .wonder, value: 4)])
        case .irrigation:
            return TechTypeData(name: "Irrigation",
                                eurekaSummary: "Farm a resource",
                                eurekaDescription: "Farming a resource has given you an appreciation of the importance of irrigating your crops.",
                                quoteTexts: ["“Thousands have lived without love, not one without water.” [NEWLINE]-W. H. Auden", "“The man who has grit enough to bring about the afforestation or the irrigation of a country is not less worthy of honor than its conqueror.” [NEWLINE]– Sir John Thomson"],
                                era: .ancient,
                                cost: 50,
                                required: [.pottery],
                                flavors: [Flavor(type: .growth, value: 5)])
        case .writing:
            return TechTypeData(name: "Writing",
                                eurekaSummary: "Meet another civilization",
                                eurekaDescription: "After meeting another civilization you see the need for new ways to communicate.",
                                quoteTexts: ["“Writing means sharing. It’s part of the human condition to want to share things – thoughts, ideas, opinions.” [NEWLINE]– Paulo Coelho", "“Writing is easy. All you have to do is cross out the wrong words.“ [NEWLINE]-Mark Twain"],
                                era: .ancient,
                                cost: 50,
                                required: [.pottery],
                                flavors: [Flavor(type: .science, value: 6), Flavor(type: .wonder, value: 2), Flavor(type: .diplomacy, value: 2)])
        case .masonry:
            return TechTypeData(name: "Masonry",
                                eurekaSummary: "Build a Quarry",
                                eurekaDescription: "Quarrying a resource has given you the raw materials you need to employ masons.",
                                quoteTexts: ["“Each of us is carving a stone, erecting a column, or cutting a piece of stained glass in the construction of something much bigger than ourselves.”[NEWLINE]– Adrienne Clarkson", "“When wasteful war shall statues overturn, and broils root out the work of masonry.” [NEWLINE]– William Shakespeare"],
                                era: .ancient,
                                cost: 80,
                                required: [.mining],
                                flavors: [Flavor(type: .cityDefense, value: 4), Flavor(type: .happiness, value: 2), Flavor(type: .tileImprovement, value: 2), Flavor(type: .wonder, value: 2)])
        case .archery:
            return TechTypeData(name: "Archery",
                                eurekaSummary: "Kill a unit with a Slinger",
                                eurekaDescription: "After finally killing an enemy with a Slinger, you long for a stronger ranged weapon.",
                                quoteTexts: ["“I shot an arrow into the air. It fell to earth, I knew not where.” [NEWLINE]– Henry Wadsworth Longfellow", "“May the forces of evil become confused while your arrow is on its way to the target.” [NEWLINE]– George Carlin"],
                                era: .ancient,
                                cost: 50,
                                required: [.animalHusbandry],
                                flavors: [Flavor(type: .ranged, value: 4), Flavor(type: .offense, value: 1)])
        case .bronzeWorking:
            return TechTypeData(name: "Bronze Working",
                                eurekaSummary: "Kill 3 Barbarians",
                                eurekaDescription: "Your fights with Barbarians highlight the need for stronger weaponry.",
                                quoteTexts: ["“Bronze is the mirror of the form, wine of the mind.” [NEWLINE]– Aeschylus", "“I’m also interested in creating a lasting legacy … because bronze will last for thousands of years.” [NEWLINE]- Richard MacDonald"],
                                era: .ancient,
                                cost: 80,
                                required: [.mining],
                                flavors: [Flavor(type: .defense, value: 4), Flavor(type: .militaryTraining, value: 4), Flavor(type: .wonder, value: 2)])
        case .wheel:
            return TechTypeData(name: "Wheel",
                                eurekaSummary: "Mine a resource",
                                eurekaDescription: "Your mining operations have given you the ability to create an axle. Will the wheel follow?",
                                quoteTexts: ["“Sometimes the wheel turns slowly, but it turns.” [NEWLINE]– Lorne Michaels", "“Don’t reinvent the wheel, just realign it.” [NEWLINE]– Anthony D’Angelo"],
                                era: .ancient,
                                cost: 80,
                                required: [.mining],
                                flavors: [Flavor(type: .mobile, value: 2), Flavor(type: .growth, value: 2), Flavor(type: .ranged, value: 2), Flavor(type: .infrastructure, value: 2), Flavor(type: .gold, value: 6)])
            
            // classical
        // https://github.com/kondeeza/Anki_Python_Addon/blob/96c7474b14aad4a276312f7b1cb25120f1045830/Civ6_Mod/Language_Mod/Input2/en_US/Quotes_Text.xml
        case .celestialNavigation:
            return TechTypeData(name: "Celestrial Navigation",
                                eurekaSummary: "Improve 2 Sea Resources",
                                eurekaDescription: "Your fishermen are learning how to guide their travels based on studying the night sky.",
                                quoteTexts: [],
                                era: .classical,
                                cost: 120,
                                required: [.sailing, .astrology],
                                flavors: [Flavor(type: .naval, value: 5), Flavor(type: .navalGrowth, value: 5)])
        case .horsebackRiding:
            return TechTypeData(name: "Horseback Riding",
                                eurekaSummary: "Build a Pasture",
                                eurekaDescription: "With animals now domesticated into Pastures, it is time to learn to ride.",
                                quoteTexts: [],
                                era: .classical,
                                cost: 120,
                                required: [.animalHusbandry],
                                flavors: [Flavor(type: .mobile, value: 7), Flavor(type: .happiness, value: 3)])
        case .currency:
            return TechTypeData(name: "Currency",
                                eurekaSummary: "Make a Trade Route",
                                eurekaDescription: "Your [ICON_TradeRoute] Trade Route directly exchanges goods, but a medium of exchange would make trade more flexible.",
                                quoteTexts: [],
                                era: .classical,
                                cost: 120,
                                required: [.writing],
                                flavors: [Flavor(type: .gold, value: 8), Flavor(type: .wonder, value: 2)])
        case .construction:
            return TechTypeData(name: "Construction",
                                eurekaSummary: "Build a Water Mill",
                                eurekaDescription: "Work on the Water Mill has taught your workers much about construction practices.",
                                quoteTexts: [],
                                era: .classical,
                                cost: 200,
                                required: [.masonry, .horsebackRiding],
                                flavors: [Flavor(type: .happiness, value: 17), Flavor(type: .infrastructure, value: 2), Flavor(type: .wonder, value: 2)])
        case .ironWorking:
            return TechTypeData(name: "Iron Working",
                                eurekaSummary: "Build an Iron Mine",
                                eurekaDescription: "Access to a steady source of Iron has enabled you to build better weapons and stronger armor.",
                                quoteTexts: [],
                                era: .classical,
                                cost: 120,
                                required: [.bronzeWorking],
                                flavors: [Flavor(type: .offense, value: 12), Flavor(type: .defense, value: 6), Flavor(type: .militaryTraining, value: 3)])
        case .shipBuilding:
            return TechTypeData(name: "Ship Building",
                                eurekaSummary: "Own 2 Galleys",
                                eurekaDescription: "Constructing a squadron of Galleys has taught you much about building larger ships.",
                                quoteTexts: [],
                                era: .classical,
                                cost: 200,
                                required: [.sailing],
                                flavors: [Flavor(type: .naval, value: 5), Flavor(type: .navalGrowth, value: 3), Flavor(type: .navalRecon, value: 2)])
        case .mathematics:
            return TechTypeData(name: "Mathematics",
                                eurekaSummary: "Build 3 Specialty Districts",
                                eurekaDescription: "Your district planners have worked out the basics of geometry. Maybe a full mathematical system will follow soon?",
                                quoteTexts: [],
                                era: .classical,
                                cost: 200,
                                required: [.currency],
                                flavors: [Flavor(type: .ranged, value: 8), Flavor(type: .wonder, value: 2)])
        case .engineering:
            return TechTypeData(name: "Engeneering",
                                eurekaSummary: "Build Ancient Walls",
                                eurekaDescription: "Completing walls around your city demonstrated the principles of engineering needed for Aqueducts and Catapults.",
                                quoteTexts: [],
                                era: .classical,
                                cost: 200,
                                required: [.wheel],
                                flavors: [Flavor(type: .defense, value: 2), Flavor(type: .production, value: 5), Flavor(type: .tileImprovement, value: 5)])
            
            // medieval
        case .militaryTactics:
            return TechTypeData(name: "Military Tactics",
                                eurekaSummary: "Kill a unit with a Spearman",
                                eurekaDescription: "Your spearmen are proving effective, but now your opponents are stronger and faster. Perhaps a longer weapon is needed?",
                                quoteTexts: [],
                                era: .medieval,
                                cost: 275,
                                required: [.mathematics],
                                flavors: [Flavor(type: .offense, value: 3), Flavor(type: .mobile, value: 3), Flavor(type: .cityDefense, value: 2), Flavor(type: .wonder, value: 2),])
        case .buttress:
            return TechTypeData(name: "Buttress",
                                eurekaSummary: "Build a Classical Era or later Wonder",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .medieval,
                                cost: 300,
                                required: [.shipBuilding, .mathematics],
                                flavors: [Flavor(type: .wonder, value: 2)])
        case .apprenticeship:
            return TechTypeData(name: "Apprenticeship",
                                eurekaSummary: "Build 3 Mines",
                                eurekaDescription: "With raw materials now coming in from a wide variety of mines, the need to better teach new craftsmen to use them is essential.",
                                quoteTexts: [],
                                era: .medieval,
                                cost: 275,
                                required: [.currency, .horsebackRiding],
                                flavors: [Flavor(type: .gold, value: 5), Flavor(type: .production, value: 3)])
        case .stirrups:
            return TechTypeData(name: "Stirrups",
                                eurekaSummary: "Have the Feudalism civic",
                                eurekaDescription: "The feudal lords in your realm want a champion to defend their lands. Perhaps mounting an armored warrior will do the trick?",
                                quoteTexts: [],
                                era: .medieval,
                                cost: 360,
                                required: [.horsebackRiding],
                                flavors: [Flavor(type: .offense, value: 3), Flavor(type: .mobile, value: 3), Flavor(type: .defense, value: 2), Flavor(type: .wonder, value: 2)])
        case .machinery:
            return TechTypeData(name: "Machinery",
                                eurekaSummary: "Own 3 Archers",
                                eurekaDescription: "You look to machinery to improve the performance of your sizable contingent of ranged troops.",
                                quoteTexts: [],
                                era: .medieval,
                                cost: 275,
                                required: [.ironWorking, .engineering],
                                flavors: [Flavor(type: .ranged, value: 8), Flavor(type: .infrastructure, value: 2),])
        case .education:
            return TechTypeData(name: "Education",
                                eurekaSummary: "Earn a Great Scientist",
                                eurekaDescription: "The teachings from your Great Scientist have inspired a renewed interest in learning in your realm.",
                                quoteTexts: [],
                                era: .medieval,
                                cost: 335,
                                required: [.apprenticeship, .mathematics],
                                flavors: [Flavor(type: .science, value: 8), Flavor(type: .wonder, value: 2)])
        case .militaryEngineering:
            return TechTypeData(name: "Military Engineering",
                                eurekaSummary: "Build an Aqueduct",
                                eurekaDescription: "Your military leaders carefully followed the progress on your aqueduct. They see new ways to use these engineering skills.",
                                quoteTexts: [],
                                era: .medieval,
                                cost: 335,
                                required: [.construction],
                                flavors: [Flavor(type: .defense, value: 5), Flavor(type: .production, value: 2)])
        case .castles:
            return TechTypeData(name: "Castles",
                                eurekaSummary: "Have a government with 6 policy slots",
                                eurekaDescription: "Our new government’s defense minister suggests that we might want to build impressive defenses to protect our bustling capital.",
                                quoteTexts: [],
                                era: .medieval,
                                cost: 390,
                                required: [.construction],
                                flavors: [Flavor(type: .cityDefense, value: 5)])
            
            // renaissance
        case .cartography:
            return TechTypeData(name: "Cartography",
                                eurekaSummary: "Build 2 Harbors",
                                eurekaDescription: "With so many ships leaving the harbors of your empire you long to document your explorations.",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 490,
                                required: [.shipBuilding],
                                flavors: [Flavor(type: .navalRecon, value: 5)])
        case .massProduction:
            return TechTypeData(name: "Mass Production",
                                eurekaSummary: "Build a Lumber Mill",
                                eurekaDescription: "Now that you have a ready supply of standardized boards, your shipping industry will soon take off.",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 490,
                                required: [.education, .shipBuilding],
                                flavors: [Flavor(type: .production, value: 7)])
        case .banking:
            return TechTypeData(name: "Banking",
                                eurekaSummary: "Have the Guilds civic",
                                eurekaDescription: "Your emerging guilds have plans that require a large influx of gold. Perhaps we can find a way to let them take out a loan?",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 490,
                                required: [.education, .apprenticeship, .stirrups],
                                flavors: [Flavor(type: .gold, value: 6)])
        case .gunpowder:
            return TechTypeData(name: "Gunpowder",
                                eurekaSummary: "Build an Armory",
                                eurekaDescription: "Your men at the armory are fashioning a new weapon that will devastate opponents.",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 490,
                                required: [.militaryEngineering, .stirrups, .apprenticeship],
                                flavors: [Flavor(type: .production, value: 2), Flavor(type: .defense, value: 3), Flavor(type: .cityDefense, value: 2)])
        case .printing:
            return TechTypeData(name: "Printing",
                                eurekaSummary: "Build 2 Universities",
                                eurekaDescription: "Out of necessity your scholars are devising methods for quickly copying books.",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 490,
                                required: [.machinery],
                                flavors: [Flavor(type: .science, value: 7)])
        case .squareRigging:
            return TechTypeData(name: "Square Rigging",
                                eurekaSummary: "Kill a unit with a Musketman",
                                eurekaDescription: "The success of your Musketmen on land has spurred a new idea: what if we upgrade to gunpowder weaponry at sea?",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 600,
                                required: [.cartography],
                                flavors: [Flavor(type: .naval, value: 5), Flavor(type: .navalGrowth, value: 2), Flavor(type: .navalRecon, value: 3)])
        case .astronomy:
            return TechTypeData(name: "Astronomy",
                                eurekaSummary: "Build a University next to a Mountain",
                                eurekaDescription: "Your scientists are hiking into the mountains for a sharper view of the heavens. Maybe a permanent facility would help?",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 600,
                                required: [.education],
                                flavors: [Flavor(type: .science, value: 4)])
        case .metalCasting:
            return TechTypeData(name: "Metal Casting",
                                eurekaSummary: "Own 2 Crossbowmen",
                                eurekaDescription: "With so many Crossbowmen in the field, we’ve had a lot of practice studying ranged weapons.",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 660,
                                required: [.gunpowder],
                                flavors: [Flavor(type: .production, value: 3)])
        case .siegeTactics:
            return TechTypeData(name: "Siege Tactics",
                                eurekaSummary: "Own 2 Bombards",
                                eurekaDescription: "After creating bombards you realize that castles are not impregnable – you need a stauncher defense!",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 660,
                                required: [.castles],
                                flavors: [Flavor(type: .ranged, value: 5), Flavor(type: .offense, value: 3)])

            // industrial
        case .industrialization:
            return TechTypeData(name: "Industrialization",
                                eurekaSummary: "Build 3 Workshops",
                                eurekaDescription: "The busy workshops of your empire hint at greatness to come. Is an Industrial Revolution about to commence?",
                                quoteTexts: [],
                                era: .industrial,
                                cost: 700,
                                required: [.massProduction, .squareRigging],
                                flavors: [Flavor(type: .production, value: 7)])
        case .scientificTheory:
            return TechTypeData(name: "Scientific Theory",
                                eurekaSummary: "Have The Enlightenment civic",
                                eurekaDescription: "The dawning of an age of enlightenment in our realm has sparked a serious discourse on our scientific methods.",
                                quoteTexts: [],
                                era: .industrial,
                                cost: 700,
                                required: [.astronomy, .banking],
                                flavors: [Flavor(type: .diplomacy, value: 5), Flavor(type: .science, value: 5)])
        case .ballistics:
            return TechTypeData(name: "Ballistics",
                                eurekaSummary: "Have 2 Forts in your territory",
                                eurekaDescription: "Your cities have been protected by multiple fortifications, what if they could be defended by cannons?",
                                quoteTexts: [],
                                era: .industrial,
                                cost: 840,
                                required: [.metalCasting],
                                flavors: [Flavor(type: .ranged, value: 5), Flavor(type: .offense, value: 5), ])
        case .militaryScience:
            return TechTypeData(name: "Military Science",
                                eurekaSummary: "Kill a unit with a Knight",
                                eurekaDescription: "Your valiant Knight has vanquished his foe. Let us learn from this victory and become students of military affairs.",
                                quoteTexts: [],
                                era: .industrial,
                                cost: 845,
                                required: [.printing, .siegeTactics],
                                flavors: [Flavor(type: .offense, value: 7),])
        case .steamPower:
            return TechTypeData(name: "Steam Power",
                                eurekaSummary: "Build 2 Shipyards",
                                eurekaDescription: "Let us apply our industrial acumen to your newly-constructed shipyards. Steam-powered naval vessels could rule the seas.",
                                quoteTexts: [],
                                era: .industrial,
                                cost: 805,
                                required: [.industrialization, .squareRigging],
                                flavors: [Flavor(type: .mobile, value: 5), Flavor(type: .offense, value: 2), Flavor(type: .navalGrowth, value: 3)])
        case .sanitation:
            return TechTypeData(name: "Sanitation",
                                eurekaSummary: "Build 2 Neighborhoods",
                                eurekaDescription: "With the introduction of neighborhoods, our cities are growing larger than ever before. Developing a sanitation plan is crucial.",
                                quoteTexts: [],
                                era: .industrial,
                                cost: 805,
                                required: [.scientificTheory],
                                flavors: [Flavor(type: .growth, value: 5),])
        case .economics:
            return TechTypeData(name: "Economics",
                                eurekaSummary: "Build 2 Banks",
                                eurekaDescription: "The power of your banks in on the rise.  It is time to formally study the forces that are shaping your national economy.",
                                quoteTexts: [],
                                era: .industrial,
                                cost: 805,
                                required: [.metalCasting, .scientificTheory],
                                flavors: [Flavor(type: .wonder, value: 5),])
        case .rifling:
            return TechTypeData(name: "Rifling",
                                eurekaSummary: "Build a Niter Mine",
                                eurekaDescription: "With a source of niter, your firearms industry is switching into top gear. The next step will be to improve our accuracy.",
                                quoteTexts: [],
                                era: .industrial,
                                cost: 970,
                                required: [.ballistics, .militaryScience],
                                flavors: [Flavor(type: .offense, value: 5),])
            
            // modern
        case .flight:
            return TechTypeData(name: "Flight",
                                eurekaSummary: "Build an Industrial era or later wonder",
                                eurekaDescription: "Having completed a modern wonder, our engineers are sure they can tackle anything. What, are they thinking of flying next?",
                                quoteTexts: [],
                                era: .modern,
                                cost: 900, required: [.industrialization, .scientificTheory],
                                flavors: [Flavor(type: .mobile, value: 5)])
        case .replaceableParts:
            return TechTypeData(name: "Replaceable Parts",
                                eurekaSummary: "Own 3 Musketmen",
                                eurekaDescription: "Your armament makers are tired of having to hand craft so many muskets.  Perhaps some standardization would help?",
                                quoteTexts: [],
                                era: .modern,
                                cost: 1250,
                                required: [.economics],
                                flavors: [Flavor(type: .offense, value: 5), Flavor(type: .gold, value: 3), Flavor(type: .production, value: 3), ])
        case .steel:
            return TechTypeData(name: "Steel",
                                eurekaSummary: "Build a Coal Mine",
                                eurekaDescription: "Your coal-powered blast furnaces should soon allow us to produce the finest-grade steel.",
                                quoteTexts: [],
                                era: .modern,
                                cost: 1140,
                                required: [.rifling],
                                flavors: [Flavor(type: .ranged, value: 5), Flavor(type: .wonder, value: 3), ])
        case .refining:
            return TechTypeData(name: "Refining",
                                eurekaSummary: "Build 2 Coal Power Plants",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .modern,
                                cost: 1250,
                                required: [.rifling],
                                flavors: [Flavor(type: .navalGrowth, value: 5), Flavor(type: .tileImprovement, value: 3), ])
        case .electricity:
            return TechTypeData(name: "Electricity",
                                eurekaSummary: "Own 3 Privateers",
                                eurekaDescription: "Your crafty privateers are intrigued by the discovery of electric current. Could they use this to create stealthy propulsion?",
                                quoteTexts: [],
                                era: .modern,
                                cost: 985,
                                required: [.steamPower],
                                flavors: [Flavor(type: .navalGrowth, value: 5), Flavor(type: .energy, value: 3), ])
        case .radio:
            return TechTypeData(name: "Radio",
                                eurekaSummary: "Build a National Park",
                                eurekaDescription: "Your new national park needs visitors. Perhaps a new form of communications will help advertise it?",
                                quoteTexts: [],
                                era: .modern,
                                cost: 985,
                                required: [.flight, .steamPower],
                                flavors: [Flavor(type: .expansion, value: 3)])
        case .chemistry:
            return TechTypeData(name: "Chemistry",
                                eurekaSummary: "Complete a Research Agreement.",
                                eurekaDescription: "Joining forces with other nations has started a chain reaction of scientific advances.  Will the next push be in chemistry?",
                                quoteTexts: [],
                                era: .modern,
                                cost: 985,
                                required: [.sanitation],
                                flavors: [Flavor(type: .growth, value: 4), Flavor(type: .science, value: 5)])
        case .combustrion:
            return TechTypeData(name: "Combustion",
                                eurekaSummary: "Extract an Artifact.",
                                eurekaDescription: "Your archaeologist has noticed petroleum seeping out of the rocks. Perhaps your geologists would like to take a look?",
                                quoteTexts: [],
                                era: .modern,
                                cost: 1250,
                                required: [.steel, .rifling],
                                flavors: [Flavor(type: .offense, value: 4), Flavor(type: .wonder, value: 3), ])
            
            // atomic
        case .advancedFlight:
            return TechTypeData(name: "Advanced Flight",
                                eurekaSummary: "Build 3 Biplanes",
                                eurekaDescription: "Your extensive experience with biplanes has led to several aeronautic breakthroughs.",
                                quoteTexts: [],
                                era: .atomic,
                                cost: 1065,
                                required: [.radio],
                                flavors: [Flavor(type: .offense, value: 4), ])
        case .rocketry:
            return TechTypeData(name: "Rocketry",
                                eurekaSummary: "Boost through Great Scientist or Spy",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .atomic,
                                cost: 1065,
                                required: [.radio, .chemistry],
                                flavors: [Flavor(type: .science, value: 5)])
        case .advancedBallistics:
            return TechTypeData(name: "Advanced Ballistics",
                                eurekaSummary: "Build 2 Power Plants",
                                eurekaDescription: "Development of new power plants has spurred on industrial advances that could help your armament production.",
                                quoteTexts: [],
                                era: .information,
                                cost: 1410,
                                required: [.replaceableParts, .steel],
                                flavors: [Flavor(type: .offense, value: 5), Flavor(type: .defense, value: 5)])
        case .combinedArms:
            return TechTypeData(name: "Combined Arms",
                                eurekaSummary: "Build an Airstrip",
                                eurekaDescription: "Now that you know how to build portable airstrips on land, why not try one at sea?",
                                quoteTexts: [],
                                era: .information,
                                cost: 1480,
                                required: [.steel],
                                flavors: [Flavor(type: .navalGrowth, value: 5), ])
        case .plastics:
            return TechTypeData(name: "Plastics",
                                eurekaSummary: "Build an Oil Well",
                                eurekaDescription: "Having a source of petrochemicals should lead to many advances. Its plasticity is of particular interest.",
                                quoteTexts: [],
                                era: .information,
                                cost: 1065,
                                required: [.combustrion],
                                flavors: [Flavor(type: .offense, value: 5), Flavor(type: .navalTileImprovement, value: 4), ])
        case .computers:
            return TechTypeData(name: "Computers",
                                eurekaSummary: "Have a government with 8 policy slots",
                                eurekaDescription: "A modern government comes with a lot of bureaucracy. Developing ways to efficiently track data will be a huge help.",
                                quoteTexts: [],
                                era: .atomic,
                                cost: 1195,
                                required: [.electricity, .radio],
                                flavors: [Flavor(type: .growth, value: 2), Flavor(type: .science, value: 4), Flavor(type: .diplomacy, value: 5)])
        case .nuclearFission:
            return TechTypeData(name: "Nuclear Fission",
                                eurekaSummary: "Boost through Great Scientist or Spy",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .atomic,
                                cost: 1195,
                                required: [.combinedArms, .advancedBallistics],
                                flavors: [Flavor(type: .energy, value: 5), ])
        case .syntheticMaterials:
            return TechTypeData(name: "Synthetic Materials",
                                eurekaSummary: "Build 2 Aerodromes",
                                eurekaDescription: "With facilities for aircrafts in multiple cities, your aeronautic industry is taking off.",
                                quoteTexts: [],
                                era: .atomic,
                                cost: 1195,
                                required: [.plastics],
                                flavors: [Flavor(type: .gold, value: 4), Flavor(type: .offense, value: 2)])
            
            // information
        case .telecommunications:
            return TechTypeData(name: "Telecommunications",
                                eurekaSummary: "Build 2 Broadcast Centers",
                                eurekaDescription: "With your pioneers in radio and television leading the way, you’ve grown adept at transmitting data quickly.",
                                quoteTexts: [],
                                era: .information,
                                cost: 1340,
                                required: [.computers],
                                flavors: [Flavor(type: .offense, value: 3)])
        case .satellites:
            return TechTypeData(name: "Satellites",
                                eurekaSummary: "Boost through Great Scientist or Spy",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .information,
                                cost: 1340,
                                required: [.advancedFlight, .rocketry],
                                flavors: [Flavor(type: .science, value: 3), Flavor(type: .expansion, value: 3)])
        case .guidanceSystems:
            return TechTypeData(name: "Guidance Systems",
                                eurekaSummary: "Kill a Fighter",
                                eurekaDescription: "Your military has defeated an enemy plane. Now it is time to have the best defense against enemy aircraft.",
                                quoteTexts: [],
                                era: .information,
                                cost: 1580,
                                required: [.rocketry, .advancedBallistics],
                                flavors: [Flavor(type: .offense, value: 5), ])
        case .lasers:
            return TechTypeData(name: "Lasers",
                                eurekaSummary: "Boost through Great Scientist or Spy.",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .information,
                                cost: 1340,
                                required: [.nuclearFission],
                                flavors: [Flavor(type: .navalGrowth, value: 5), ])
        case .composites:
            return TechTypeData(name: "Composites",
                                eurekaSummary: "Own 3 Tanks",
                                eurekaDescription: "Tanks have been the backbone of your army so your scientists are striving for a more advanced model.",
                                quoteTexts: [],
                                era: .information,
                                cost: 1340,
                                required: [.syntheticMaterials],
                                flavors: [Flavor(type: .offense, value: 6)])
        case .stealthTechnology:
            return TechTypeData(name: "Stealth Technology",
                                eurekaSummary: "Boost through Great Scientist or Spy",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .information,
                                cost: 1340,
                                required: [.syntheticMaterials],
                                flavors: [Flavor(type: .offense, value: 3)])
        case .robotics:
            return TechTypeData(name: "Robotics",
                                eurekaSummary: "Have the Globalization civic.",
                                eurekaDescription: "Having a diverse set of metals to experiment on will help your scientists push into new fields.",
                                quoteTexts: [],
                                era: .information,
                                cost: 1560,
                                required: [.computers],
                                flavors: [Flavor(type: .production, value: 3), Flavor(type: .offense, value: 3),])
        case .nuclearFusion:
            return TechTypeData(name: "Nuclear Fusion",
                                eurekaSummary: "Boost through Great Scientist or Spy",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .information,
                                cost: 1560,
                                required: [.lasers],
                                flavors: [Flavor(type: .energy, value: 3),])
        case .nanotechnology:
            return TechTypeData(name: "Nanotechnology",
                                eurekaSummary: "Build an Aluminum Mine",
                                eurekaDescription: "Having a diverse set of metals to experiment on will help your scientists push into new fields.",
                                quoteTexts: [],
                                era: .information,
                                cost: 1560,
                                required: [.composites],
                                flavors: [Flavor(type: .science, value: 3)])
            
            // future
        case .futureTech:
            return TechTypeData(name: "Future Tech",
                                eurekaSummary: "---",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .future,
                                cost: 1780,
                                required: [.robotics, .nuclearFusion],
                                flavors: [])
        }
    }
}
