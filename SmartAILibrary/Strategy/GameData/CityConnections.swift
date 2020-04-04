//
//  CityConnections.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

struct RouteState {
    
    var hasAnyRoute: Bool
    var hasWaterRoute: Bool
    var hasBestRoute: Bool
}

struct RouteInfo {
    
    let from: AbstractCity?
    let to: AbstractCity?
    var routeState: RouteState
    var passEval: Int // used to create the data, but should not be referenced as a value
}

class PlotRouteInfos {
    
    let state: BitArray
    let location: HexPoint
    
    init(location: HexPoint) {
        self.location = location
        self.state = BitArray(count: 3)
    }
    
    var noConnection: Bool {
        get { return self.state.valueOfBit(at: 0) }
        set { self.state.setValueOfBit(value: newValue, at: 0) }
    }
    
    var connection: Bool {
        get { return self.state.valueOfBit(at: 1) }
        set { self.state.setValueOfBit(value: newValue, at: 1) }
    }
    
    var connectionLastTurn: Bool {
        get { return self.state.valueOfBit(at: 2) }
        set { self.state.setValueOfBit(value: newValue, at: 2) }
    }
}

public class CityConnections {
    
    var player: Player?
    
    internal var cityPlots: [AbstractCity?]
    private var routeInfos: [RouteInfo]
    private var plotRouteInfos: [PlotRouteInfos]
    
    // MARK: constructors

    init(player: Player?) {

        self.player = player
        
        self.cityPlots = []
        self.routeInfos = []
        self.plotRouteInfos = []
    }
    
    /// Update - called from within Player
    func turn(with gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError()
        }
        
        guard let player = self.player else {
            fatalError()
        }
        
        if player.isBarbarian() {
            return
        }

        self.updatePlotRouteStates()
        self.updateCityPlots(in: gameModel)
        self.updateRouteInfo(in: gameModel)
        //self.broadcastPlotRouteStateChanges()
    }
    
    /// if there are no cities in the route list
    var isEmpty: Bool {
        return self.cityPlots.isEmpty
    }
    
    func numConnectableCities() -> Int {
        
        return self.cityPlots.count
    }
    
    func updatePlotRouteStates() {
        
        for plotRouteInfo in self.plotRouteInfos {
            
            if plotRouteInfo.connection {
                plotRouteInfo.connection = false
                plotRouteInfo.noConnection = false
                plotRouteInfo.connectionLastTurn = true
            } else {
                plotRouteInfo.connection = false
                plotRouteInfo.noConnection = true
                plotRouteInfo.connectionLastTurn = false
            }
        }
    }
    
    /// Update the city ids to the correct ones
    func updateCityPlots(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        self.resetCityPlots()

        for otherPlayer in gameModel.players {

            if otherPlayer.isBarbarian() {
                continue
            }

            if player.leader == otherPlayer.leader {
                
                // player's city
                for cityRef in gameModel.cities(of: otherPlayer) {
                    self.cityPlots.append(cityRef)
                }
            } else if self.shouldConnectTo(otherPlayer: otherPlayer) {
                
                if let capital = gameModel.capital(of: otherPlayer) {
                    self.cityPlots.append(capital)
                }
            }
        }
    }
    
    /// Reset the city id array to have invalid data
    func resetCityPlots() {
        
        self.cityPlots.removeAll()
    }
    
    func shouldConnectTo(otherPlayer: AbstractPlayer?) -> Bool {
        
        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }

        // shouldn't be able to connect to yourself
        if player.leader == otherPlayer.leader {
            return false
        }

        if !otherPlayer.isAlive() {
            return false
        }

        if otherPlayer.isBarbarian() {
            return false
        }

        return true
    }
    
    func updateRouteInfo(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        let bestRouteType = player.bestRoute()

        // build city list
        /*FStaticVector<CvCity*, SAFE_ESTIMATE_NUM_CITIES, true, c_eCiv5GameplayDLL, 0> vpCities;
        CvCity* pLoopCity = NULL;
        int iLoop;*/

        var vpCities: [AbstractCity?] = []
        var allowWaterRoutes = false

        // add all the cities we control and those that we want to connect to
        for otherPlayer in gameModel.players {

            if otherPlayer.isBarbarian() {
                continue
            }

            if player.leader == otherPlayer.leader {
                
                // player's city
                for cityRef in gameModel.cities(of: otherPlayer) {
                    
                    if let city = cityRef {
                        vpCities.append(city)
                        city.setRouteToCapitalConnected(value: false)

                        if !allowWaterRoutes {
                            if city.has(district: .harbor) {
                                allowWaterRoutes = true
                            }
                        }
                    }
                }
            } else if self.shouldConnectTo(otherPlayer: otherPlayer) {
                
                if let capital = gameModel.capital(of: otherPlayer) {
                    vpCities.append(capital)
                }
            }
        }

        self.resetRouteInfo()

        // if the player can't build any routes, then we don't need to check this
        if bestRouteType == .none && !allowWaterRoutes {
            return
        }

        // pass 0 = can cities connect via water routes
        // pass 1 = can cities connect via land and water routes
        for pass in 0..<2 {
            
            if pass == 0 && !allowWaterRoutes {
                // if in the first pass and we can't embark, skip
                continue
            } else if pass == 1 && bestRouteType == .none {
                // if in the second pass, we can't build a road, skip
                continue
            }

            //CvCity* pFirstCity = NULL;
            //CvCity* pSecondCity = NULL;

            //CvAStar* pkLandRouteFinder;
            //pkLandRouteFinder = &GC.getRouteFinder();
            let landPathfinder = AStarPathfinder()
            landPathfinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: .walk, for: player)
            
            let waterPathfinder = AStarPathfinder()
            waterPathfinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: .swim, for: player)
            
            for firstCityRef in vpCities {
                
                guard let firstCity = firstCityRef else {
                    continue
                }

                for secondCityRef in vpCities {
                
                    guard let secondCity = secondCityRef else {
                        continue
                    }
                    // same city! ignore
                    if secondCity.location == firstCity.location {
                        continue
                    }

                    // bail if either are null
                    guard var routeInfo = self.routeInfo(from: firstCityRef, to: secondCityRef) else {
                        continue
                    }
                    
                    guard let inverseRouteInfo = self.routeInfo(from:secondCityRef, to: firstCityRef) else {
                        continue
                    }

                    // if the route has already been evaluated, copy the data
                    if inverseRouteInfo.passEval > pass {
                        routeInfo.passEval = inverseRouteInfo.passEval
                        routeInfo.routeState = inverseRouteInfo.routeState
                        continue
                    }

                    // this path already has an existing route (usually water)
                    if routeInfo.routeState.hasAnyRoute || routeInfo.routeState.hasBestRoute || routeInfo.routeState.hasWaterRoute {
                        continue
                    }

                    routeInfo.passEval = pass + 1

                    // check water route
                    if pass == 0 {
                        // if either city is blockaded, don't consider a water connection
                        if firstCity.isBlockaded() || secondCity.isBlockaded() {
                            continue
                        }

                        // add a check to see if there are harbors at the end points, right now just see if two cities are connected
                        let firstCityHasHarbor = firstCity.has(district: .harbor)
                        let secondCityHasHarbor = secondCity.has(district: .harbor)

                        if firstCityHasHarbor && secondCityHasHarbor {
                            
                            if let _ = waterPathfinder.shortestPath(fromTileCoord: firstCity.location, toTileCoord: secondCity.location) {
                                
                                routeInfo.routeState.hasAnyRoute = true
                                routeInfo.routeState.hasWaterRoute = true
                            }
                        }
                    } else if pass == 1 {
                        
                        // check land route
                        var anyRouteFound = false
                        var bestRouteFound = false

                        let landPath = landPathfinder.shortestPath(fromTileCoord: firstCity.location, toTileCoord: secondCity.location)
                        if landPath != nil && landPath!.count < 50 {
                            anyRouteFound = true
                            bestRouteFound = true
                        }

                        if !bestRouteFound && landPath != nil {
                            anyRouteFound = true
                        }

                        if bestRouteFound {
                            routeInfo.routeState.hasBestRoute = true
                            routeInfo.routeState.hasAnyRoute = true
                        } else if anyRouteFound {
                            routeInfo.routeState.hasAnyRoute = true
                        }

                        // walk through the nodes for plot route info
                        if firstCity.isCapital() || secondCity.isCapital() {
                            
                            if anyRouteFound {
                                
                                for landPoint in landPath! {
                                    self.connectPlotRoute(landPoint)
                                }

                                firstCity.setRouteToCapitalConnected(value: true)
                                secondCity.setRouteToCapitalConnected(value: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func connectPlotRoute(_ location: HexPoint) {
        
        if let plotRouteInfo = self.plotRouteInfos.first(where: { $0.location == location }) {
            plotRouteInfo.connection = true
        } else {

            let plotRouteInfo = PlotRouteInfos(location: location)
            plotRouteInfo.connection = true
            
            self.plotRouteInfos.append(plotRouteInfo)
        }
    }
    
    func resetRouteInfo() {
        
        self.routeInfos.removeAll()
    }
    
    func routeInfo(from firstCity: AbstractCity?, to secondCity: AbstractCity?) -> RouteInfo? {
        
        self.routeInfos.first(where: { $0.from?.location == firstCity?.location && $0.to?.location == secondCity?.location })
    }
}
