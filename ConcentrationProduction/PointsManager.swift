import Foundation

struct PointsManager {
    private var canBeLessZero: Bool

    private(set) var points: Int = 0

    mutating func add() {
        points += 1
    }

    mutating func remove() {
        if points >= 2 || canBeLessZero {
            points -= 2
        }
    }

    init(canBeLessZero: Bool) {
        points = 0
        self.canBeLessZero = canBeLessZero
    }
}
 
