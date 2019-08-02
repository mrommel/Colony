//
//  PausableTimer.swift
//  Colony
//
//  Created by Michael Rommel on 29.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

public class PausableTimer {

    // MARK: - callback closures
    public var didStart: (() -> Void)?
    public var didPause: (() -> Void)?
    public var didResume: (() -> Void)?
    public var didStop: ((_ isFinished: Bool) -> Void)?

    // MARK: - private properties
    private var timer: Timer?
    private var elasedTimer: Timer?

    private let duration: TimeInterval
    private var currentDuration: TimeInterval
    private var elapsedDuration: TimeInterval

    // MARK: - constructor
    init(with duration: TimeInterval) {
        self.duration = duration
        self.currentDuration = duration
        self.elapsedDuration = 0
    }

    // MARK: - operate
    public func start() {
        self.registerTimer()

        self.didStart?()
    }

    public func pause() {
        if !isRunning() { return }

        self.currentDuration = self.remainingDuration()
        self.timer?.invalidate()

        self.didPause?()
    }

    public func resume() {
        if self.isRunning() { return }
        if self.remainingDuration() == 0 { return }

        self.registerTimer()

        self.didResume?()
    }

    public func stop() {
        self.reset()

        self.didStop?(false)
    }

    // MARK: -
    public func isRunning() -> Bool {
        guard let timer = timer, timer.isValid else { return false }

        return self.remainingDuration() > 0
    }

    public func remainingDuration() -> TimeInterval {
        guard let timer = timer, timer.isValid else {
            return 0
        }

        let remainingDuration: TimeInterval = self.currentDuration - self.elapsedDuration

        return remainingDuration < 0 ? 0 : remainingDuration
    }

    // MARK: - Timer
    @objc private func didFinishTimerDuration() {
        self.reset()

        self.didStop?(true)
    }

    // MARK: - private
    private func registerTimer() {
        self.timer = Timer(timeInterval: self.currentDuration,
            target: self,
            selector: #selector(didFinishTimerDuration),
            userInfo: nil,
            repeats: false)
        RunLoop.current.add(self.timer!, forMode: .default)
        
        self.elasedTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireUpdateTimer), userInfo: nil, repeats: true)
        /*self.elasedTimer = Timer(timeInterval: 1, repeats: true, block: { timer in
            self.elapsedDuration += 1
        })*/
    }
    
    @objc private func fireUpdateTimer() {
        
        self.elapsedDuration += 1
    }

    private func reset() {
        //self.currentDuration = duration
        self.timer?.invalidate()
        self.elasedTimer?.invalidate()
    }
}
