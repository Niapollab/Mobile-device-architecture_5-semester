import Foundation

struct PointsManager {
    private var internalPoints: Int

    private var canBeLessZero: Bool

    var points: Int {
        return internalPoints
    }

    mutating func add() {
        internalPoints += 1
    }

    mutating func remove() {
        if internalPoints >= 2 || canBeLessZero {
            internalPoints -= 2
        }
    }

    mutating func reset() {
        internalPoints = 0
    }

    init(canBeLessZero: Bool) {
        internalPoints = 0
        self.canBeLessZero = canBeLessZero
    }
}
 
