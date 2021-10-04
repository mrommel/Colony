//
//  GreatPerson.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 31.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// swiftlint:disable type_body_length
public enum GreatPerson: String, Codable {

    case none

    // generals
    // https://civilization.fandom.com/wiki/Great_General_(Civ6)
    case boudica
    case hannibalBarca
    case sunTzu
    case aethelflaed // Æthelflæd
    case elCid

    // admirals
    // https://civilization.fandom.com/wiki/Great_Admiral_(Civ6)
    case artemisia
    case gaiusDuilius
    case themistocles
    case leifErikson
    case rajendraChola

    // engineers
    // https://civilization.fandom.com/wiki/Great_Engineer_(Civ6)
    case biSheng
    case isidoreOfMiletus
    case jamesOfStGeorge
    case filippoBrunelleschi
    case leonardoDaVinci

    // merchants
    // https://civilization.fandom.com/wiki/Great_Merchant_(Civ6)
    case colaeus
    case marcusLiciniusCrassus
    case zhangQian
    case ireneOfAthens
    case marcoPolo

    // prophets
    // https://civilization.fandom.com/wiki/Great_Prophet_(Civ6)
    case confucius
    case johnTheBaptist
    case laozi
    case siddharthaGautama
    case simonPeter
    case zoroaster
    case adiShankara
    case bodhidharma
    case irenaeus
    case oNoYasumaro
    case songtsanGampo

    // scientist
    // https://civilization.fandom.com/wiki/Great_Scientist_(Civ6)
    case aryabhata
    case euclid
    case hypatia
    case abuAlQasimAlZahrawi
    case hildegardOfBingen
    case omarKhayyam

    // writers
    // https://civilization.fandom.com/wiki/Great_Writer_(Civ6)
    case homer
    case bhasa
    case quYuan
    case ovid
    case geoffreyChaucer
    case liBai
    case murasakiShikibu

    // artist
    // https://civilization.fandom.com/wiki/Great_Artist_(Civ6)
    case andreiRublev
    case michelangelo
    case donatello
    case hieronymusBosch

    // musicans
    // https://civilization.fandom.com/wiki/Great_Musician_(Civ6)
    case ludwigVanBeethoven
    case johannSebastianBach
    case yatsuhashiKengyo
    case antonioVivaldi
    case wolfgangAmadeusMozart

    static var all: [GreatPerson] {
        return [
            // generals
            .boudica, .hannibalBarca, .sunTzu, .aethelflaed, .elCid,

            // admirals
            .artemisia, .gaiusDuilius, .themistocles, .leifErikson, .rajendraChola,

            // engineers
            .biSheng, .isidoreOfMiletus, .jamesOfStGeorge, .filippoBrunelleschi, .leonardoDaVinci,

            // merchants
            .colaeus, .marcusLiciniusCrassus, .zhangQian, .ireneOfAthens, .marcoPolo,

            // prophets
            .confucius, .johnTheBaptist, .laozi, .siddharthaGautama, .simonPeter, .zoroaster, .adiShankara,
            .bodhidharma, .irenaeus, .oNoYasumaro, .songtsanGampo,

            // scientists
            .aryabhata, .euclid, .hypatia, .abuAlQasimAlZahrawi, .hildegardOfBingen, .omarKhayyam,

            // writer
            .homer, .bhasa, .quYuan, .ovid, .geoffreyChaucer, .liBai, .murasakiShikibu,

            // artsits
            .andreiRublev, .michelangelo, .donatello, .hieronymusBosch,

            // musicans
            .ludwigVanBeethoven, .johannSebastianBach, .yatsuhashiKengyo, .antonioVivaldi, .wolfgangAmadeusMozart
        ]
    }

    public func name() -> String {

        return self.data().name
    }

    public func type() -> GreatPersonType {

        return self.data().type
    }

    public func era() -> EraType {

        return self.data().era
    }

    public func cost() -> Int {

        switch self.era() {

        case .none:
            return 0
        case .ancient:
            return 0
        case .classical:
            return 60
        case .medieval:
            return 120
        case .renaissance:
            return 240
        case .industrial:
            return 420
        case .modern:
            return 560
        case .atomic:
            return 680
        case .information:
            return 800
        case .future:
            return 1280
        }
    }

    func charges() -> Int {

        return self.data().charges
    }

    func works() -> [GreatWork] {

        return self.data().works
    }

    // MARK: private types

    private struct GreatPersonData {

        let name: String
        let type: GreatPersonType
        let era: EraType
        let bonus: String
        let charges: Int
        let works: [GreatWork]
    }

    // swiftlint:disable line_length
    // swiftlint:disable function_body_length
    // swiftlint:disable cyclomatic_complexity
    private func data() -> GreatPersonData {

        switch self {

        case .none:
            return GreatPersonData(name: "None",
                                   type: .greatGeneral,
                                   era: .classical,
                                   bonus: "",
                                   charges: 0,
                                   works: [])

            // ---------------------
            // generals
        case .boudica:
            return GreatPersonData(name: "Boudica",
                                   type: .greatGeneral,
                                   era: .classical,
                                   bonus: "Convert adjacent barbarian units.",
                                   charges: 1,
                                   works: [])
        case .hannibalBarca:
            return GreatPersonData(name: "Hannibal Barca",
                                   type: .greatGeneral,
                                   era: .classical,
                                   bonus: "Grants 1 promotion level to a military land unit.",
                                   charges: 1,
                                   works: [])
        case .sunTzu:
            return GreatPersonData(name: "Sun Tzu",
                                   type: .greatGeneral,
                                   era: .classical,
                                   bonus: "Creates the Art of War Great Work of Writing (+2 Culture, +2 Tourism).",
                                   charges: 1,
                                   works: [.artOfWar])
        case .aethelflaed:
            return GreatPersonData(name: "Æthelflæd",
                                   type: .greatGeneral,
                                   era: .medieval,
                                   bonus: "Instantly creates a Knight unit. Grants +2 Loyalty per turn for this city.",
                                   charges: 1,
                                   works: [])
        case .elCid:
            // https://civilization.fandom.com/wiki/El_Cid_(Civ6)
            return GreatPersonData(name: "El Cid",
                                   type: .greatGeneral,
                                   era: .medieval,
                                   bonus: "Forms a Corps out of a military land unit.",
                                   charges: 1,
                                   works: [])

            // ---------------------
            // admiral
        case .artemisia:
            // https://civilization.fandom.com/wiki/Artemisia_(Civ6)
            return GreatPersonData(name: "Artemisia",
                                   type: .greatAdmiral,
                                   era: .classical,
                                   bonus: "Grants 1 promotion level to a military naval unit.",
                                   charges: 1,
                                   works: [])
        case .gaiusDuilius:
            // https://civilization.fandom.com/wiki/Gaius_Duilius_(Civ6)
            return GreatPersonData(name: "Gaius Duilius",
                                   type: .greatAdmiral,
                                   era: .classical,
                                   bonus: "Forms a Fleet out of a military naval unit.",
                                   charges: 1,
                                   works: [])
        case .themistocles:
            // https://civilization.fandom.com/wiki/Themistocles_(Civ6)
            return GreatPersonData(name: "Themistocles",
                                   type: .greatAdmiral,
                                   era: .classical,
                                   bonus: "Instantly creates a Quadrireme unit. Grants +2 Loyalty per turn for this city.",
                                   charges: 1,
                                   works: [])
        case .leifErikson:
            // https://civilization.fandom.com/wiki/Leif_Erikson_(Civ6)
            return GreatPersonData(name: "Leif Erikson",
                                   type: .greatAdmiral,
                                   era: .medieval,
                                   bonus: "Allows all naval units to move over ocean tiles without the required technology.",
                                   charges: 1,
                                   works: [])
        case .rajendraChola:
            // https://civilization.fandom.com/wiki/Rajendra_Chola_(Civ6)
            return GreatPersonData(name: "Rajendra Chola",
                                   type: .greatAdmiral,
                                   era: .medieval,
                                   bonus: "Gain 50 Gold. Military units get +40% rewards to looting.",
                                   charges: 1,
                                   works: [])

            // ---------------------
            // engineer
        case .biSheng:
            // https://civilization.fandom.com/wiki/Bi_Sheng_(Civ6)
            return GreatPersonData(name: "Bi Sheng",
                                   type: .greatEngineer,
                                   era: .medieval,
                                   bonus: "Lets this city build one more district than the population limit allows. Triggers the Eureka moment for Printing technology.",
                                   charges: 1,
                                   works: [])
        case .isidoreOfMiletus:
            // https://civilization.fandom.com/wiki/Isidore_of_Miletus_(Civ6)
            return GreatPersonData(name: "Isidore of Miletus",
                                   type: .greatEngineer,
                                   era: .medieval,
                                   bonus: "Grants 215 Production towards wonder construction at standard speed. (2 charges)",
                                   charges: 2,
                                   works: [])
        case .jamesOfStGeorge:
            // https://civilization.fandom.com/wiki/James_of_St._George_(Civ6)
            return GreatPersonData(name: "James of St. George",
                                   type: .greatEngineer,
                                   era: .medieval,
                                   bonus: "Instantly builds Ancient and Medieval Walls in this city, and provides enough Gold per turn to pay maintenance. (3 charges)",
                                   charges: 3,
                                   works: [])
        case .filippoBrunelleschi:
            // https://civilization.fandom.com/wiki/Filippo_Brunelleschi_(Civ6)
            return GreatPersonData(name: "Filippo Brunelleschi",
                                   type: .greatEngineer,
                                   era: .renaissance,
                                   bonus: "Grants 315 Production towards wonder construction. (2 charges)",
                                   charges: 2,
                                   works: [])
        case .leonardoDaVinci:
            // https://civilization.fandom.com/wiki/Leonardo_da_Vinci_(Civ6)
            return GreatPersonData(name: "Leonardo da Vinci",
                                   type: .greatEngineer,
                                   era: .renaissance,
                                   bonus: "Triggers the Eureka moment for one random technology of the Modern era. Workshops provide +1  Culture.",
                                   charges: 1,
                                   works: [])

            // ---------------------
            // merchants
        case .colaeus:
            // https://civilization.fandom.com/wiki/Colaeus_(Civ6)
            return GreatPersonData(name: "Colaeus",
                                   type: .greatMerchant,
                                   era: .classical,
                                   bonus: "Gain 100 Faith. Grants 1 free copy of the Luxury resource on this tile to your Capital city.",
                                   charges: 1,
                                   works: [])
        case .marcusLiciniusCrassus:
            // https://civilization.fandom.com/wiki/Marcus_Licinius_Crassus_(Civ6)
            return GreatPersonData(name: "Marcus Licinius Crassus",
                                   type: .greatMerchant,
                                   era: .classical,
                                   bonus: "Gain 60 Gold. Your nearest city annexes this tile into its territory. (3 charges)",
                                   charges: 3,
                                   works: [])
        case .zhangQian:
            // https://civilization.fandom.com/wiki/Zhang_Qian_(Civ6)
            return GreatPersonData(name: "Zhang Qian",
                                   type: .greatMerchant,
                                   era: .classical,
                                   bonus: "Increases Trade Route capacity by 1. Foreign Trade Routes to this city provide +2 Gold to both cities.",
                                   charges: 1,
                                   works: [])
        case .ireneOfAthens:
            // https://civilization.fandom.com/wiki/Irene_of_Athens_(Civ6)
            return GreatPersonData(name: "Irene of Athens",
                                   type: .greatMerchant,
                                   era: .medieval,
                                   bonus: "Increase Trade Route capacity by 1. Grants 1 free copy of the Luxury resource on this tile to your  Capital city. Grants 1 Governor Title or recruit a new Governor.",
                                   charges: 1,
                                   works: [])
        case .marcoPolo:
            // https://civilization.fandom.com/wiki/Marco_Polo_(Civ6)
            return GreatPersonData(name: "Marco Polo",
                                   type: .greatMerchant,
                                   era: .medieval,
                                   bonus: "Grants a free Trader unit in this city, and increases Trade Route capacity by 1. Foreign Trade Routes to this city provides +2 Gold to both cities.",
                                   charges: 1,
                                   works: [])

            // ---------------------
            // prophets
        case .confucius:
            // https://civilization.fandom.com/wiki/Confucius_(Civ6)
            return GreatPersonData(name: "Confucius",
                                   type: .greatProphet,
                                   era: .classical,
                                   bonus: "",
                                   charges: 1,
                                   works: [])
        case .johnTheBaptist:
            //
            return GreatPersonData(name: "John the Baptist",
                                   type: .greatProphet,
                                   era: .classical,
                                   bonus: "",
                                   charges: 1,
                                   works: [])
        case .laozi:
            // https://civilization.fandom.com/wiki/Laozi_(Civ6)
            return GreatPersonData(name: "Laozi",
                                   type: .greatProphet,
                                   era: .classical,
                                   bonus: "",
                                   charges: 1,
                                   works: [])
        case .siddharthaGautama:
            // https://civilization.fandom.com/wiki/Siddhartha_Gautama_(Civ6)
            return GreatPersonData(name: "Siddhartha Gautama",
                                   type: .greatProphet,
                                   era: .classical,
                                   bonus: "",
                                   charges: 1,
                                   works: [])
        case .simonPeter:
            // https://civilization.fandom.com/wiki/Simon_Peter_(Civ6)
            return GreatPersonData(name: "Simon Peter",
                                   type: .greatProphet,
                                   era: .classical,
                                   bonus: "",
                                   charges: 1,
                                   works: [])
        case .zoroaster:
            // https://civilization.fandom.com/wiki/Zoroaster_(Civ6)
            return GreatPersonData(name: "Zoroaster",
                                   type: .greatProphet,
                                   era: .classical,
                                   bonus: "",
                                   charges: 1,
                                   works: [])
        case .adiShankara:
            // https://civilization.fandom.com/wiki/Adi_Shankara_(Civ6)
            return GreatPersonData(name: "Adi Shankara",
                                   type: .greatProphet,
                                   era: .medieval,
                                   bonus: "",
                                   charges: 1,
                                   works: [])
        case .bodhidharma:
            // https://civilization.fandom.com/wiki/Bodhidharma_(Civ6)
            return GreatPersonData(name: "Bodhidharma",
                                   type: .greatProphet,
                                   era: .medieval,
                                   bonus: "",
                                   charges: 1,
                                   works: [])
        case .irenaeus:
            // https://civilization.fandom.com/wiki/Irenaeus_(Civ6)
            return GreatPersonData(name: "Irenaeus",
                                   type: .greatProphet,
                                   era: .medieval,
                                   bonus: "",
                                   charges: 1,
                                   works: [])
        case .oNoYasumaro:
            // https://civilization.fandom.com/wiki/O_No_Yasumaro_(Civ6)
            return GreatPersonData(name: "O No Yasumaro",
                                   type: .greatProphet,
                                   era: .medieval,
                                   bonus: "",
                                   charges: 1,
                                   works: [])
        case .songtsanGampo:
            // https://civilization.fandom.com/wiki/Songtsan_Gampo_(Civ6)
            return GreatPersonData(name: "Songtsan Gampo",
                                   type: .greatProphet,
                                   era: .medieval,
                                   bonus: "",
                                   charges: 1,
                                   works: [])

            // ---------------------
            // scientists
        case .aryabhata:
            // https://civilization.fandom.com/wiki/Aryabhata_(Civ6)
            return GreatPersonData(name: "Aryabhata",
                                   type: .greatScientist,
                                   era: .classical,
                                   bonus: "Triggers the Eureka moment for three random technologies from the Classical or Medieval era.",
                                   charges: 1,
                                   works: [])
        case .euclid:
            // https://civilization.fandom.com/wiki/Euclid_(Civ6)
            return GreatPersonData(name: "Euclid",
                                   type: .greatScientist,
                                   era: .classical,
                                   bonus: "Triggers the Eureka moment for Mathematics and one random technology from the Medieval era.",
                                   charges: 1,
                                   works: [])
        case .hypatia:
            // https://civilization.fandom.com/wiki/Hypatia_(Civ6)
            return GreatPersonData(name: "Hypatia",
                                   type: .greatScientist,
                                   era: .classical,
                                   bonus: "Libraries provide +1 Science. Instantly builds a Library in this district.",
                                   charges: 1,
                                   works: [])
        case .abuAlQasimAlZahrawi:
            // https://civilization.fandom.com/wiki/Abu_Al-Qasim_Al-Zahrawi_(Civ6)
            return GreatPersonData(name: "Abu Al-Qasim Al-Zahrawi",
                                   type: .greatScientist,
                                   era: .medieval,
                                   bonus: "Active: Triggers the Eureka for one random Medieval or Renaissance era technology. Wounded units can heal +5 HP per turn. Passive: +20 HP Healing for all units within one tile.",
                                   charges: 1,
                                   works: [])
        case .hildegardOfBingen:
            // https://civilization.fandom.com/wiki/Hildegard_of_Bingen_(Civ6)
            return GreatPersonData(name: "Hildegard of Bingen",
                                   type: .greatScientist,
                                   era: .medieval,
                                   bonus: "Gain 100 Faith. This Holy Site's adjacency bonuses gain an additional Science bonus.",
                                   charges: 1,
                                   works: [])
        case .omarKhayyam:
            // https://civilization.fandom.com/wiki/Omar_Khayyam_(Civ6)
            return GreatPersonData(name: "Omar Khayyam",
                                   type: .greatScientist,
                                   era: .medieval,
                                   bonus: "Triggers the Eureka moment for two technologies and the Inspiration for one Civic from the Medieval or Renaissance era.",
                                   charges: 1,
                                   works: [])

            // ---------------------
            // writers
        case .homer:
            // https://civilization.fandom.com/wiki/Homer_(Civ6)
            return GreatPersonData(name: "Homer",
                                   type: .greatWriter,
                                   era: .classical,
                                   bonus: "Activate on an appropriate tile to create a Great Work",
                                   charges: 2,
                                   works: [.iliad, .odyssey])
        case .bhasa:
            // https://civilization.fandom.com/wiki/Bhasa_(Civ6)
            return GreatPersonData(name: "Bhasa",
                                   type: .greatWriter,
                                   era: .classical,
                                   bonus: "Activate on an appropriate tile to create a Great Work",
                                   charges: 2,
                                   works: [.theMadhyamaVyayoga, .pratimaNataka])
        case .quYuan:
            // https://civilization.fandom.com/wiki/Qu_Yuan_(Civ6)
            return GreatPersonData(name: "Qu Yuan",
                                   type: .greatWriter,
                                   era: .classical,
                                   bonus: "Activate on an appropriate tile to create a Great Work",
                                   charges: 2,
                                   works: [.chuCi, .lamentForYing])
        case .ovid:
            // https://civilization.fandom.com/wiki/Ovid_(Civ6)
            return GreatPersonData(name: "Ovid",
                                   type: .greatWriter,
                                   era: .classical,
                                   bonus: "Activate on an appropriate tile to create a Great Work",
                                   charges: 2,
                                   works: [.metamorphoses, .heroides])
        case .geoffreyChaucer:
            // https://civilization.fandom.com/wiki/Geoffrey_Chaucer_(Civ6)
            return GreatPersonData(name: "Geoffrey Chaucer",
                                   type: .greatWriter,
                                   era: .medieval,
                                   bonus: "Activate on an appropriate tile to create a Great Work",
                                   charges: 2,
                                   works: [.theCanterburyTales, .troilusAndCriseyde])
        case .liBai:
            // https://civilization.fandom.com/wiki/Li_Bai_(Civ6)
            return GreatPersonData(name: "Li Bai",
                                   type: .greatWriter,
                                   era: .medieval,
                                   bonus: "Activate on an appropriate tile to create a Great Work",
                                   charges: 2,
                                   works: [.drinkingAloneByMoonlight, .inTheMountainsOnASummerDay])
        case .murasakiShikibu:
            // https://civilization.fandom.com/wiki/Murasaki_Shikibu_(Civ6)
            return GreatPersonData(name: "Murasaki Shikibu",
                                   type: .greatWriter,
                                   era: .medieval,
                                   bonus: "Activate on an appropriate tile to create a Great Work",
                                   charges: 2,
                                   works: [.theDiaryOfLadyMurasaki, .theTaleOfGenji])

            // ---------------------
            // artists
        case .andreiRublev:
            // https://civilization.fandom.com/wiki/Andrei_Rublev_(Civ6)
            return GreatPersonData(name: "Andrei Rublev",
                                   type: .greatArtist,
                                   era: .renaissance,
                                   bonus: "Activate on an appropriate tile to create a Great Work",
                                   charges: 3,
                                   works: [.annunciation, .saviourInGlory, .ascension])
        case .michelangelo:
            // https://civilization.fandom.com/wiki/Michelangelo_(Civ6)
            return GreatPersonData(name: "Michelangelo",
                                   type: .greatArtist,
                                   era: .renaissance,
                                   bonus: "Activate on an appropriate tile to create a Great Work",
                                   charges: 3,
                                   works: [.sistineChapelCeiling, .pieta, .david])
        case .donatello:
            // https://civilization.fandom.com/wiki/Donatello_(Civ6)
            return GreatPersonData(name: "Donatello",
                                   type: .greatArtist,
                                   era: .renaissance,
                                   bonus: "Activate on an appropriate tile to create a Great Work",
                                   charges: 3,
                                   works: [.saintMark, .gattamelata, .judithSlayingHolofernes])
        case .hieronymusBosch:
            // https://civilization.fandom.com/wiki/Hieronymus_Bosch_(Civ6)
            return GreatPersonData(name: "Hieronymus Bosch",
                                   type: .greatArtist,
                                   era: .renaissance,
                                   bonus: "Activate on an appropriate tile to create a Great Work",
                                   charges: 3,
                                   works: [.theGardenOfEarthlyDelights, .theLastJudgement, .theHaywainTriptych])

            // ---------------------
            // musicans
        case .ludwigVanBeethoven:
            // https://civilization.fandom.com/wiki/Ludwig_van_Beethoven_(Civ6)
            return GreatPersonData(name: "Ludwig van Beethoven",
                                   type: .greatMusician,
                                   era: .industrial,
                                   bonus: "Activate on an appropriate tile to create a Great Work",
                                   charges: 2,
                                   works: [.odeToJoySymphony9, .symphony3EroicaSymphonyMvt1])
        case .johannSebastianBach:
            // https://civilization.fandom.com/wiki/Johann_Sebastian_Bach_(Civ6)
            return GreatPersonData(name: "Johann Sebastian Bach",
                                   type: .greatMusician,
                                   era: .industrial,
                                   bonus: "Activate on an appropriate tile to create a Great Work",
                                   charges: 2,
                                   works: [.littleFugueInGMinor, .celloSuiteNo1])
        case .yatsuhashiKengyo:
            // https://civilization.fandom.com/wiki/Yatsuhashi_Kengyo_(Civ6)
            return GreatPersonData(name: "Yatsuhashi Kengyo",
                                   type: .greatMusician,
                                   era: .industrial,
                                   bonus: "Activate on an appropriate tile to create a Great Work",
                                   charges: 2,
                                   works: [.rokudanNoShirabe, .hachidanNoShirabe])
        case .antonioVivaldi:
            // https://civilization.fandom.com/wiki/Antonio_Vivaldi_(Civ6)
            return GreatPersonData(name: "Antonio Vivaldi",
                                   type: .greatMusician,
                                   era: .industrial,
                                   bonus: "Activate on an appropriate tile to create a Great Work",
                                   charges: 2,
                                   works: [.fourSeasonsWinter, .laNotteConcerto])
        case .wolfgangAmadeusMozart:
            // https://civilization.fandom.com/wiki/Wolfgang_Amadeus_Mozart_(Civ6)
            return GreatPersonData(name: "Wolfgang Amadeus Mozart",
                                   type: .greatMusician,
                                   era: .industrial,
                                   bonus: "Activate on an appropriate tile to create a Great Work",
                                   charges: 2,
                                   works: [.eineKleineNachtmusik, .symphony40Mvt1])
        }
    }
}
