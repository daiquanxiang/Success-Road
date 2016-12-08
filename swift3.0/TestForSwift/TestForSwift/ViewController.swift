//
//  ViewController.swift
//  TestForSwift
//
//  Created by David on 15/11/28.
//  Copyright © 2015年 David. All rights reserved.
//

import UIKit

struct Vector2D {
    var x = 0.0, y = 0.0
}

func + (left: Vector2D, right: Vector2D) -> Vector2D {
    return Vector2D (x: left.x + right.x, y: left.y + right.y)
}

prefix func - (vector: Vector2D) -> Vector2D {
    return Vector2D(x: -vector.x, y: -vector.y)
}

func += ( left: inout Vector2D, right: Vector2D) {
    left = left + right
}

prefix func ++ ( vector: inout Vector2D) -> Vector2D {
    vector += Vector2D(x: 1.0, y: 1.0)
    return vector
}

func == (left: Vector2D, right: Vector2D) -> Bool {
    return (left.x == right.x) && (left.y == right.y)
}

func != (left: Vector2D, right: Vector2D) -> Bool {
    return !(left == right)
}
prefix operator +++

prefix func +++ ( vector: inout Vector2D) -> Vector2D {
    vector += vector
    return vector
}

infix operator +- { associativity left precedence 140 }

func +- (left: Vector2D, right: Vector2D) -> Vector2D {
    return Vector2D(x: left.x + right.x, y: left.y - right.y)
}

struct TrackedString {
    private(set) var numberOfEdits = 0
    var value: String = "" {
        didSet {
            numberOfEdits += 1
        }
    }
}

protocol Container {
    associatedtype ItemType
    mutating func append(item: ItemType)
    var count: Int {get}
    subscript(i: Int) -> ItemType {get}
}

struct Stack<T>: Container {
    // original Stack<T> implementation
    var items = [T]()
    mutating func push(item: T) {
        items.append(item)
    }
    mutating func pop() -> T {
        return items.removeLast()
    }
    
    // conformance to the Container protocol
    mutating func append(item: T) {
        self.push(item: item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> T {
        return items[i]
    }
}

extension Stack {
    var topItem: T? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

extension Array: Container {
    func append(item: Element) {
        
    }
}

@objc protocol CounterDataSource {
    @objc optional func incrementForCount(count: Int) -> Int
    @objc optional var fixedIncrement: Int {get}
}

class MyCounter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.incrementForCount?(count: count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}

class ThreeSource: CounterDataSource {
    let fixedIncrement = 3
}

class TowardsZeroSource: CounterDataSource {
    func incrementForCount(count: Int) -> Int {
        if count == 0 {
            return 0
        } else if count < 0 {
            return 1
        } else {
            return -1
        }
    }
}

protocol HasArea {
    var area: Double {get}
}

class HasAreaCircle: HasArea {
    let pi = 3.1415927
    var radius: Double
    var area: Double { return pi * radius * radius}
    init(radius: Double) {
        self.radius = radius
    }
}

class HasAreaCountry: HasArea {
    var area: Double
    init(area: Double) {
        self.area = area
    }
}

class NotAreaAnimal {
    var legs: Int
    init(legs: Int) {
        self.legs = legs
    }
}

protocol Named {
    var name: String {get}
}

protocol Aged {
    var age: Int {get}
}

struct AgedPerson: Named, Aged {
    var name: String
    var age: Int
}

struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}

protocol TextRepresentable {
    var textualDescription: String { get }
}
extension Hamster: TextRepresentable {}

protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}

extension PrettyTextRepresentable {
    var prettyTextualDescription: String {
        return textualDescription
    }
}

class Dice {
    let sides: Int
    let generator: RandomNumberGenerator
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}

extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}

protocol DiceGame {
    var dice: Dice { get }
    func play()
}
protocol DiceGameDelegate {
    func gameDidStart(game: DiceGame)
    func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(game: DiceGame)
}

class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
        board = [Int](repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    var delegate: DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(game: self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(game: self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(game: self)
    }
}
extension SnakesAndLadders: TextRepresentable {
    var textualDescription: String {
        return "A game of Snakes and Ladders with \(finalSquare) squares"
    }
}

extension SnakesAndLadders: PrettyTextRepresentable {
    var prettyTextualDescription: String {
        var output = textualDescription + ":\n"
        for index in 1...finalSquare {
            switch board[index] {
            case let ladder where ladder > 0:
                output += "🌂"
            case let snake where snake < 0:
                output += "⤵️"
            default:
                output += "⭕️"
            }
        }
        return output
    }
}

class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    func gameDidStart(game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides) - sided dice")
    }
    func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    func gameDidEnd(game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}

protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case Off, On
    mutating func toggle() {
        switch self {
        case .Off:
            self = .On
        case .On:
            self = .Off
        }
    }
}

protocol FullyNamed {
    var fullName: String { get }
}

protocol RandomNumberGenerator {
    func random() -> Double
}

extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = (lastRandom * a + c).truncatingRemainder(dividingBy: m)// lastRandom = ((lastRandom * a + c) % m)
        return lastRandom / m
    }
}

class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
}

extension Int {
    func repetitions(_ task: () -> ()) {
        for _ in 0..<self {
            task()
        }
    }
    mutating func square() {
        self = self * self
    }
    subscript(digitIndex: Int) -> Int {
        var digitIndex = digitIndex
        var decimalBase = 1
        while digitIndex > 0 {
            decimalBase *= 10
            digitIndex -= 1
        }
        return (self / decimalBase) % 10
    }
    
    enum Kind {
        case negative, zero, positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
    
}

struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}

extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY) , size: size)
    }
}

extension Double {
    var km: Double { return self * 1_000.0 }
    var m : Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}

func someFunctionWithNoescapeClosure(_ closure: () -> Void) {
    closure()
}

var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(_ completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

struct Item {
    var price: Int
    var count: Int
}

enum VendingMachineError: Error {
    case invalidSelection       //选择无效
    case insufficientFunds(coinsNeeded: Int)  // 金额不足
    case outOfStock             //缺货
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips":    Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0
    func dispenseSnack(_ snack: String) {
        print("Dispensing \(snack)")
    }
    func vend(itemNamed name: String) throws {
        guard var item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        item.count -= 1
        inventory[name] = item
        dispenseSnack(name)
    }
}

class ResidencePerson {
    var residence: Residence?
}

class Residence {
//    var numberOfRooms = 1
    var rooms = [Room]()
    var numberOfRooms: Int {
        return rooms.count
    }
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms .append(newValue)
//            rooms[i] = newValue
            
        }
    }
    func printNumberOfRooms() {
        print("The number of room is \(numberOfRooms)")
    }
    var address: Address?
}

class Room {
    let name: String
    init(name: String) {
        self.name = name
    }
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if buildingName != nil {
            return buildingName
        } else if buildingNumber != nil {
            return buildingNumber
        } else {
            return nil
        }
    }
}

class HTMLElement {
    let name: String
    let text: String?
    lazy var asHTML: (Void) -> String = {
//        少了这行代码，会引起闭包强引用
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        }
        else {
            return "<\(self.name)/>"
        }
    }
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}

class Customer {
    let name: String
    var card:CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit {
        print("Card #\(number) is being deinitialized")
    }
}

class Person {
    let name: String
    init(name: String) {
        self.name = name
//        print("\(name) is being initialized")
    }
    var apartment: Apartment?
    deinit {
        print("\(name) is being deinitialized")
    }
}

class Apartment {
    let unit: String
    init(unit: String) {
        self.unit = unit
    }
//    var tenant: Person? // 导致循环引用
    weak var tenant: Person?
    deinit {
        print("Apartment \(unit) is being deinitialized");
    }
}

struct Bank {
    static var coinsInBank = 10_000
    static func vendCoins(_ numberOfCoinsToVend: Int) -> Int {
        var numberOfCoinsToVend = numberOfCoinsToVend
        numberOfCoinsToVend = min(numberOfCoinsToVend, coinsInBank)
        coinsInBank -= numberOfCoinsToVend
        return numberOfCoinsToVend
    }
    static func receiveCoins(_ coins: Int) {
        coinsInBank += coins
    }
}

class BankPlayer {
    var coinsInPurse: Int
    init(coins: Int) {
        coinsInPurse = Bank.vendCoins(coins)
    }
    func winCoins(_ coins: Int) {
        coinsInPurse += Bank.vendCoins(coins)
    }
    deinit {
        Bank.receiveCoins(coinsInPurse)
    }
}

class Document {
    var name: String?
    init() {
    }
    init?(name: String) {
        if name.isEmpty {
            return nil
        }
        self.name = name
    }
}

class AutomaticallyNamedDocument: Document {
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    override init?(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "[Untitled]"
        }
        else
        {
            self.name = name
        }
    }
}

class Product {
    let name: String!
    init?(name: String) {
        self.name = name
        if name.isEmpty {
            return nil
        }
    }
}

class CartItem: Product {
    let quantity: Int!
    init?(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
        if quantity < 1 {
            return nil
        }
    }
}

class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}

class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}

class ShoppingListItem: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? "✅":"❎"
        return output
    }
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }
        someFunctionWithNoescapeClosure({ x = 200 })
    }
    
}

class Counter {
    var count = 0
    func increment() {
        count += 1
    }
    func incrementBy(_ amount: Int) {
        count += amount
    }
    func incrementBy(_ amount: Int, numberOfTimes: Int) {
        count += amount * numberOfTimes
    }
    func reset() {
        count = 0
    }
}


struct LevelTracker {
    static var highestUnlockedLevel = 1
    static func unlockedLevel(_ level: Int) {
        if level > highestUnlockedLevel {
            highestUnlockedLevel = level
        }
    }
    static func levelIsUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    var currentLevel = 1
    mutating func advanceToLevel(_ level: Int) -> Bool {
        if LevelTracker.levelIsUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}

class Player {
    var tracker = LevelTracker()
    let playerName: String
    func completedLevel(_ level: Int) {
        LevelTracker.unlockedLevel(level + 1)
        tracker.advanceToLevel(level + 1)
    }
    
    init(name: String) {
        playerName = name
    }
}
class VehicleTwo {
    var numberOfWheels = 0
    var description:String {
        return "\(numberOfWheels) wheel(s)"
    }
}

class BicycleTwo: VehicleTwo {
    override init() {
        super.init()
        numberOfWheels = 2
    }
}

class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
        // do something
    }
}

class Bicycle: Vehicle {
    var hasBasket = false
}

class Tandem: Bicycle {
    var currentNumberOfPassengers = 0
}

class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo")
    }
}

class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}

class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}

class SurveyQuestion {
    let text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let name = "老镇";
//        let age = 35;
//          print("Hello,world");
//        let age:Float=4
//        print(age)
//        let label = "The width is "
//        let width = 94
//        let widthLabel = label + String(width)
//        print(widthLabel)
/*        let apples = 3
        let oranges = 5
        let appleSummary = "I have \(apples) apples."
        let fruitSummary = "I have \(apples + oranges) pieces of fruit."
        print(appleSummary)
        print(fruitSummary)*/
        
//        let optionalString : String?="Hello"
//        print(optionalString == nil)
//        var optionalName:String? = nil
//        var greeting = "Hello!"
//        if let name = optionalName {
//            greeting = "Hello,\(name)"
//        }
//        else
//        {
//            greeting = "good bye"
//        }

        
        /*
        let nickName : String? = nil
        let fullName : String = "John Applessed"
        let informalGreeting = "Hi \(nickName ?? fullName)"
        
        
        let statistics = calculateStatistics([5, 3, 100, 3, 9])
        print(statistics.sum)
        print(statistics.2)*/
        
        
        testVector()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testVector() {
        let vector = Vector2D(x: 3.0, y: 1.0)
        let anotherVector = Vector2D(x: 2.0, y: 4.0)
        let combinedVector = vector + anotherVector
        print(combinedVector)
        
        let positive = Vector2D(x: 3.0, y: 4.0)
        let nagative = -positive
        print(nagative)
        let alsoPositive = -nagative
        print(alsoPositive)
        
        var original = Vector2D(x: 1.0, y: 2.0)
        let vectorToAdd = Vector2D(x: 3.0, y: 4.0)
        original += vectorToAdd
        print(original)
        
        var toIncrement = Vector2D(x: 3.0, y: 4.0)
        let afterIncrement = ++toIncrement
        print(afterIncrement)
        
        let twoThree = Vector2D(x: 2.0, y: 3.0)
        let anotherTwoThree = Vector2D(x: 2.0, y: 3.0)
        if twoThree == anotherTwoThree {
            print("There two vectors are equivalent.")
        }
        
        var toBeDoubled = Vector2D(x: 1.0, y: 4.0)
        let afterDoubling = +++toBeDoubled
        print(toBeDoubled)
        print(afterDoubling)
        
        let firstVector = Vector2D(x: 1.0, y: 2.0)
        let secondVector = Vector2D(x: 3.0, y: 4.0)
        let plusMinusVector = firstVector +- secondVector
        print(plusMinusVector)
    }
    
    func testHighValue() {
        let initialBits: UInt8 = 0b00001111
        let invertedBits = ~initialBits
        print(invertedBits)
        
        let firstSixBits: UInt8 = 0b11111100
        let lastSixBits:UInt8 = 0b00111111
        let middleFourBits = firstSixBits & lastSixBits
        print(middleFourBits)
        
        let someBits: UInt8 = 0b10110010
        let moreBits: UInt8 = 0b01011110
        let combinedbits = someBits | moreBits
        print(combinedbits)
        
        let firstBits: UInt8 = 0b00010100
        let otherBits: UInt8 = 0b00000101
        let outputBits = firstBits ^ otherBits
        print(outputBits)
        
        let shiftBits: UInt8 = 0b00000100
        print(shiftBits << 1)
        print(shiftBits << 2)
        print(shiftBits << 5)
        print(shiftBits << 6)
        print(shiftBits >> 2)
        
        let pink: UInt32 = 0xcc6699
        let redComponent = (pink & 0xFF0000) >> 16
        let greenComponent = (pink & 0x00FF00) >> 8
        let blueComponent = pink & 0x0000FF
        
//        var potentialOverflow = Int16.max
//        potentialOverflow += 1
        
        var unsignedOverflow = UInt8.max
        unsignedOverflow = unsignedOverflow &+ 1
        print(unsignedOverflow)
        unsignedOverflow = UInt8.min
        unsignedOverflow = unsignedOverflow &- 1
        print(unsignedOverflow)
        
        var signedOverflow = Int8.min // 1 0000000 = -128
        signedOverflow = signedOverflow &- 1 // 0 1111111 = 127
        print(signedOverflow)
    }
    
    func testPrivateEdit() {
        var stringToEdit = TrackedString()
        stringToEdit.value = "This string will be tracked."
        stringToEdit.value += " This edit will increment numberOfEdits."
        stringToEdit.value += " So will this one."
        print("The number of edits is \(stringToEdit.numberOfEdits)")
    }
    
    func testAllMatch() {
        var stackOfStrings = Stack<String>()
        stackOfStrings.push(item: "uno")
        stackOfStrings.push(item: "dos")
        stackOfStrings.push(item: "tres")
        
        var arrayOfStrings = ["uno", "dos", "tres"]
        if allItemsMatch(someContainer: stackOfStrings, anotherContainer: arrayOfStrings) {
            print("All items match.")
        } else {
            print("Not all items match.")
        }
    }
    
    
//    func allItemsMatch<
//        C1: Container, C2: Container
//        where C1.ItemType == C2.ItemType, C1.ItemType: Equatable>
//        (someContainer: C1, anotherContainer: C2) -> Bool
    func allItemsMatch<C1: Container, C2: Container>(someContainer: C1, anotherContainer: C2) -> Bool where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
        // 检查两个Container的元素个数是否相同
        if someContainer.count != anotherContainer.count {
            return false
        }
        // 检查两个container相应位置的元素彼此是否相等
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        // 如果所有元素检查都相同则返回true
        return true
    }
    
    func testFindString() {
        let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
        if let foundIndex = findStringIndex(array: strings, "llama") {
            print("The index of llama is \(foundIndex)")
        }
        
        let doubleIndex = findIndex(array: [3.14159, 0.1, 0.25], 9.3)
        print(doubleIndex)
        let stringIndex = findIndex(array: ["Mike", "Malcolm", "Andrea"], "Andrea")
        print(stringIndex)
    }
    
    func findIndex<T: Equatable>(array: [T], _ valueToFind: T) -> Int? {
        for (index, value) in array.enumerated() {
            if value == valueToFind {
                return index
            }
        }
        return nil
    }
    
    func findStringIndex(array: [String], _ valueToFind: String) -> Int? {
        for (index, value) in array.enumerated() {
            if value == valueToFind {
                return index
            }
        }
        return 0
    }
    
    func testStack() {
        var stackOfStrings = Stack<String>()
        stackOfStrings.push(item: "uno")
        stackOfStrings.push(item: "dos")
        stackOfStrings.push(item: "tres")
        stackOfStrings.push(item: "cuatro")
        let fromTheTop = stackOfStrings.pop()
        print(fromTheTop)
        
        if let topItem = stackOfStrings.topItem {
            print("The top item on the stack is \(topItem).")
        }
    }
    
    func testSwap() {
        var someInt = 3
        var otherInt = 107
        swapTwoInts(a: &someInt, &otherInt)
        print("someInt is now \(someInt), and anotherInt is now \(otherInt)")
        
        swapTwoValues(a: &someInt, &otherInt)
        var someString = "hello"
        var anotherString = "world"
        swapTwoValues(a: &someString, &anotherString)
        
    }
    
    func swapTwoInts( a: inout Int, _ b: inout Int) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    
    func swapTwoValues<T>( a: inout T, _ b: inout T) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    
    func testThreeSource() {
        let counter = MyCounter()
        counter.dataSource = ThreeSource()
        for _ in 1...4 {
            counter.increment()
            print(counter.count)
        }
        
        counter.count = -4
        counter.dataSource = TowardsZeroSource()
        for _ in 1...5 {
            counter.increment()
            print(counter.count)
        }
        
        let generator = LinearCongruentialGenerator()
        print("Here's a random number: \(generator.random())")
        print("And here's a random Boolean: \(generator.randomBool())")
    }
    
    func testHasArea() {
        let objects: [AnyObject] = [
            HasAreaCircle(radius: 2.0),
            HasAreaCountry(area: 243_610),
            NotAreaAnimal(legs: 4)
        ]
        for object in objects {
            if let objectWithArea = object as? HasArea {
                print("Area is \(objectWithArea.area)")
            } else {
                print("Something that doesn't have an area")
            }
        }
    }
    
    func testTwoProtocol() {
        let birthdayPerson = AgedPerson(name: "Malcolm", age: 21)
        wishHappyBirthday(celebrator: birthdayPerson)
    }
    
    //func wishHappyBirthday(celebrator: protocol<Named, Aged>)
    func wishHappyBirthday(celebrator: Named & Aged) {
        print("Happy birthday \(celebrator.name) - you're \(celebrator.age)!")
    }
    
    func testDice() {
        let d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
        for _ in 1...5 {
            print("Random dice roll is \(d6.roll())")
        }
        
        let tracker = DiceGameTracker()
        let game = SnakesAndLadders()
        game.delegate = tracker
        game.play()
        print(game.textualDescription)
        print(game.prettyTextualDescription)
        
        let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
        print(d12.textualDescription)
        
        let simonTheHamster = Hamster(name: "Simon")
        let somethingTextRepresentable: TextRepresentable = simonTheHamster
        print(somethingTextRepresentable.textualDescription)
        
        let things: [TextRepresentable] = [game,d12,simonTheHamster]
        for thing in things {
            print(thing.textualDescription)
        }
    }
    
    func testLightSwitch() {
        var lightSwitch = OnOffSwitch.Off
        lightSwitch.toggle()
    }
    func testLinear() {
        let generator = LinearCongruentialGenerator()
        print("Here' s a random number: \(generator.random())")
        print("And another one: \(generator.random())")
        print("And another one: \(generator.random())")
    }
    
    func testProtocol() {
        struct Person: FullyNamed {
            var fullName: String
        }
        let john = Person(fullName: "John Appleseed")
        print(john.fullName)
        
        let ncc1701 = Starship(name: "Enterprise", prefix: "USS")
        print(ncc1701.fullName)
    }
    
    func testMethodsExtension() {
        3.repetitions { 
            print("Hello!")
        }
        var someInt = 3
        someInt.square()
        
        let otherInt = 746381295
        print(otherInt[0])
        print(otherInt[1])
        print(otherInt[2])
        print(otherInt[3])
        print(otherInt[4])
        print(otherInt[5])
        print(otherInt[6])
        print(otherInt[7])
        print(otherInt[8])
        print(otherInt[9])
        
        printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
    }
    
    func printIntegerKinds(_ numbers: [Int])  {

        //print("- ", separator: ", ", terminator: " ")
// http://ericasadun.com/2015/08/24/how-to-print-the-beta-6-edition-swiftlang/
        for number in numbers {
            switch number.kind {
            case .negative:
          //      print("- ", appendNewline: false)
                print("- ", terminator: "")
            case .zero:
                print("0 ", terminator: "")
            case .positive:
                print("+ ", terminator: "")
            }
        }
        print("")
    }
    
    func testRect() {
        let defaultRect = Rect()
        print(defaultRect)
        let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0), size: Size(width: 5.0, height: 5.0))
        print(memberwiseRect)
        let centerRect = Rect(center: Point(x: 4.0, y: 4), size: Size(width: 3.0, height: 3.0))
        print(centerRect)
    }
    
    func testExtension() {
        let oneInch = 25.4.mm
        print("One inch is \(oneInch) meters")
        let threeFeet = 3.ft
        print("Three feet is \(threeFeet) meters")
        let aMarathon = 42.km + 195.m
        print("A marathon is \(aMarathon) meters long")
    }
    
    func testBackJack() {
        struct BlackjackCard {
            // 嵌套定义枚举型Suit
            enum Suit: Character {
                case spades = "S", hearts = "H", diamonds = "D", clubs = "C"
            }
            // 嵌套定义枚举型Rank
            enum Rank: Int {
                case two = 2, three, four, five, six, seven, eight, nine, ten
                case jack, queen, king, ace
                struct Values {
                    let first: Int, second: Int?
                }
                var values:Values {
                    switch self {
                    case .ace:
                        return Values(first: 1, second: 11)
                    case .jack, .queen, .king:
                        return Values(first: 10, second: nil)
                    default:
                        return Values(first: self.rawValue, second: nil)
                    }
                }
            }
            // BlackjackCard 的属性和方法 
            let rank: Rank, suit: Suit
            var description: String {
                var output = "suit is \(suit.rawValue),"
                 output += " value is \(rank.values.first)"
                if let second = rank.values.second {
                    output += " or \(second)"
                }
                return output
            }
        }
        let theAceOfSpades = BlackjackCard(rank: .ace, suit: .spades)
        print("theAceOfSpades: \(theAceOfSpades.description)")
        let heartsSymbol = BlackjackCard.Suit.hearts.rawValue
        print(heartsSymbol)
    }
    
    func testCheckType() {
        let library = [
            Movie(name: "Casablanca", director: "Michael Curtiz"),
            Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
            Movie(name: "Citizen Kane", director: "Orson Welles"),
            Song(name: "The One And Only", artist: "Chesney Hawkes"),
            Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
        ]
        var movieCount = 0
        var songCount = 0
        for item in library {
            if item is Movie {
                movieCount += 1
            } else if item is Song {
                songCount += 1
            }
            
            if let movie = item as? Movie {
                print("Movie: '\(movie.name)', dir. \(movie.director)")
            } else if let song = item as? Song {
                print("Song: '\(song.name)', by \(song.artist)")
            }
        }
        print("Media library contains \(movieCount) movies and \(songCount) songs")
    
        let someObjects: [AnyObject] = [
            Movie(name: "2001: A Space Odyssey", director: "Stanley Kubrick"),
            Movie(name: "Moon", director: "Duncan Jones"),
            Movie(name: "Alien", director: "Ridley Scott")
        ]
        for object in someObjects {
            let movie = object as! Movie
            print("Movie: '\(movie.name)', dir. \(movie.director)")
        }
        
        for movie in someObjects as! [Movie] {
            print("#2# Movie: '\(movie.name)', dir. \(movie.director)")
        }
        
        var things = [Any]()
        things.append(0)
        things.append(0.0)
        things.append(42)
        things.append(3.14159)
        things.append("hello")
        
//        things.append((3.0, 5.0))
//        let point = (3.0 ,5.0)
//        things.append(point)// Ambiguous reference to member 'append'
//        things.append((3.0,5.0))
        things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
        things.append({(name: String) -> String in "Hello, \(name)"})
        
        for thing in things {
            switch thing {
            case 0 as Int:
                print("zero as an Int")
            case 0 as Double:
                print("zero as a Double")
            case let someInt as Int:
                print("an integer value of \(someInt)")
            case let someDouble as Double where someDouble > 0:
                print("a positive double value of \(someDouble)")
            case is Double:
                print("some other double value that I don't want to print")
            case let someString as String:
                print("a string value of \"\(someString)\"")
            case let (x, y) as (Double, Double):
                print("an (x, y) point at \(x), \(y)")
            case let movie as Movie:
                print("a movie called '\(movie.name)', dir. \(movie.director)")
            case let stringConverter as (String) -> String:
                print(stringConverter("Michael"))
            default:
                print("something else")
            }
        }
    }
    
    let favoriteSnacks = [
        "Alice" : "Chips",
        "Bob"   : "Licorice",
        "Eve"   : "Pretzels",
        ]
    
    
    func testErrorThrow() {
//        throw VendingMachineError.InsufficientFunds(coinsNeeded: 5)
        
        
        
        func buyFavoriteSnack(_ person: String, vendingMachine: VendingMachine) throws {
            let snackName = favoriteSnacks[person] ?? "Candy Bar"
            try vendingMachine.vend(itemNamed: snackName)
        }
        
        let vendingMachine = VendingMachine()
        vendingMachine.coinsDeposited = 8
//        do {
//            try buyFavoriteSnack("Alice", vendingMachine: vendingMachine)
//        } catch VendingMachineError.InvalidSelection {
//            print("Invalid Selection.")
//        }
        do {
            try buyFavoriteSnack("Alice", vendingMachine: vendingMachine)
        } catch VendingMachineError.invalidSelection {
            print("Invalid Selection.")
        } catch VendingMachineError.outOfStock {
            print("Out of Stock.")
        } catch VendingMachineError.insufficientFunds(let coinsNeeded) {
            print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
        } catch {
            // if miss this will show 
            // 'Errors thrown from here are not handled because the enclosing catch is not exhaustive'
        }
    }
    
    func testResidence() {
        // ？ 表示 可空调用
        // ！ 表示 强制展开
        
        let john = ResidencePerson()
//        let roomCount = john.residence!.numberOfRooms
        // this triggers a runtime error
        john.residence = Residence()
        if let roomCount = john.residence?.numberOfRooms {
            print("John's residence has \(roomCount) room(s).")
        }
        else {
            print("Unable to retrieve the number of rooms.")
        }
        let someAddress = Address()
        someAddress.buildingNumber = "29"
        someAddress.street = "Acacia Road"
        john.residence?.address = someAddress
        
        if john.residence?.printNumberOfRooms() != nil {
            print("It was possible to print the number of rooms.")
        } else {
            print("It was not possible to print the number of rooms.")
        }
        
        if (john.residence?.address = someAddress) != nil {
            print("It was possible to set the address.")
        } else {
            print("It was not possible to set the address.")
        }
        john.residence?[0] = Room(name: "Bathroom")
        if let firstRoomName = john.residence?[0].name {
            print("The first room name is \(firstRoomName)")
        } else {
            print("Unable to retrieve the first room name.")
        }
       
        let johnsHouse = Residence()
        johnsHouse.rooms.append(Room(name: "Living Room"))
        johnsHouse.rooms.append(Room(name: "Kitchen"))
        john.residence = johnsHouse
        if let firstRoomName = john.residence?[0].name {
            print("The first room name is \(firstRoomName)")
        } else {
            print("Unable to retrieve the first room name.")
        }
    
//        var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
//        testScores["Dave"]?[0] = 91
//        testScores["Bev"]?[0]++
//        testScores["Brian"]?[0] = 72
        if let johnsStreet = john.residence?.address?.street {
            print("John's street name is \(johnsStreet).")
        } else {
            print("Unable to retrieve the address.")
        }
        let johnsAddress = Address()
        johnsAddress.buildingName = "The Larches"
        johnsAddress.street = "Laurel Street"
        john.residence?.address = johnsAddress
        if let johnsStreet = john.residence?.address?.street {
            print("John's street name is \(johnsStreet).")
        } else {
            print("Unable to retrieve the address.")
        }
        
        if let buildingIdentifier = john.residence?.address?.buildingIdentifier() {
            print("John's building identifier is \(buildingIdentifier).")
        }
        
        if let beginsWithThe = john.residence?.address?.buildingIdentifier()?.hasPrefix("The") {
            if beginsWithThe {
                print("John's building identifier begins with \"the\".")
            } else {
                print("John's building identifier does not begin with \"The\".")
            }
        }
    }
    
    func testClosureArc() {
        let heading = HTMLElement(name: "hi")
        let defaultText = "some default text"
        heading.asHTML = {
            return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
        }
        print(heading.asHTML())
        
        var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello,world")
        print(paragraph!.asHTML())
        paragraph = nil
    }
    
    func testNotObviousArc() {
        let country = Country(name: "Canada", capitalName: "Ottawa")
        print("\(country.name) 's capital city is called \(country.capitalCity.name)")
    }
    
    func testUnownedArc() {
        var john: Customer?
        john = Customer(name: "John Appleseed")
        john!.card = CreditCard(number: 1234_5678_9012_3456, customer: john!)
        john = nil
    }
    
    func testArc() {
//        var reference1: Person?
//        var reference2: Person?
//        var reference3: Person?
//        reference1 = Person(name: "John Appleseed")
//        reference2 = reference1
//        reference3 = reference2
//        reference1 = nil
//        reference2 = nil
//        reference3 = nil
        
        var john: Person?
        var unit4A: Apartment?
        john = Person(name: "John Appleseed")
        unit4A = Apartment(unit: "4A")
        john!.apartment = unit4A
        unit4A!.tenant = john
        
        
        unit4A = nil
        john = nil
    }
    
    func testDeinit()  {
        var playerOne: BankPlayer? = BankPlayer(coins: 100)
        print("A new player has joined the game with \(playerOne!.coinsInPurse) coins")
        print("There are now \(Bank.coinsInBank) coins left in the bank")
        
        playerOne!.winCoins(2_000)
        print("PlayerOne won 2000 coins & now has \(playerOne!.coinsInPurse) coins")
        print("The bank now only has \(Bank.coinsInBank) coins left")
        
        playerOne = nil
        print("The bank now has \(Bank.coinsInBank) coins")
    }
    
    func testCheckerBoard() {
        struct Checkerboard {
            let boardColors: [Bool] = {
                var temporaryBoard = [Bool]()
                var isBlack = false
                for i in 1...10 {
                    for j in 1...10 {
                        temporaryBoard.append(isBlack)
                        isBlack = !isBlack
                    }
                    isBlack = !isBlack
                }
                return temporaryBoard
            }()
            func squareIsBlackAtRow(_ row: Int, column: Int) -> Bool {
                return boardColors[(row*10) + column]
            }
        }
        let board = Checkerboard()
        print(board.squareIsBlackAtRow(0, column: 1))
        print(board.squareIsBlackAtRow(9, column: 9))
    }
    
    func testProduct() {
        if let bowTie = Product(name: "bow tie") {
            print("The product's name is\(bowTie.name)")
        }
        
        if let twoSocks = CartItem(name: "sock", quantity: 2) {
            print("item: \(twoSocks.name), quantity: \(twoSocks.quantity)")
        }
        
        if let zeroShirts = CartItem(name: "shirt", quantity: 0) {
            print("item: \(zeroShirts.name), quantity: \(zeroShirts.quantity)")
        }
        else
        {
            print("unable to initialize zero shirts")
        }
        
        if let oneUnnamed = CartItem(name: "", quantity: 1)  {
            print("item: \(oneUnnamed.name), quantity: \(oneUnnamed.quantity)")
        }
        else
        {
            print("unable to initialize one unnamed product")
        }
    }
    
    func testAnimal() {
        struct Animal {
            let species: String
            init?(species: String) {
                if species.isEmpty {
                    return nil
                }
                self.species = species
            }
        }
        let someCreature = Animal(species: "Giraffe")
        if let giraffe = someCreature {
            print("An animal was initialized with a species of \(giraffe.species)")
        }
        
        let anonymousCreature = Animal(species: "")
        if anonymousCreature == nil {
            print("The anonymous creature could not be initialized")
        }
        
//        enum TemperatureUnit {
//            case Kelvin, Celsius, Fahrenheit
//            init?(symbol: Character) {
//                switch symbol {
//                case "K":
//                    self = .Kelvin
//                case "C":
//                    self = .Celsius
//                case "F":
//                    self = .Fahrenheit
//                default:
//                    return nil
//                }
//            }
//        }
//        
//        let fahrenheitUnit = TemperatureUnit(symbol: "F")
//        if fahrenheitUnit != nil {
//            print("This is a defined temperature unit, so initialization succeeded.")
//        }
//        let unknownUnit = TemperatureUnit(symbol: "X")
//        if unknownUnit == nil {
//            print("This is not a defined temperature unit, so initialization failed")
//        }
        
        enum TemperatureUnit: Character {
            case kelvin = "K", celsius = "C", fahrenheit = "F"
        }
        let fahrenheitUnit = TemperatureUnit(rawValue: "F")
        if fahrenheitUnit != nil {
            print("This is a defined temperature unit, so initialization succeeded.")
        }
        let unknownUnit = TemperatureUnit(rawValue: "X")
        if unknownUnit == nil {
            print("This is not a defined temperature unit, so initialization failed")
        }
        
    }
    
    func testFood() {
        let namedMeat = Food(name: "Becon")
        print(namedMeat)
        let mysteryMeat = Food()
        print(mysteryMeat)
        let oneMysteryItem = RecipeIngredient()
        print(oneMysteryItem)
        let oneBacon = RecipeIngredient(name: "Becon")
        print(oneBacon)
        let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)
        print(sixEggs)
        var breakfastList = [
            ShoppingListItem(),
            ShoppingListItem(name: "Bacon"),
            ShoppingListItem(name: "Eggs", quantity: 6)
        ]
        breakfastList[0].name = "Orange juice"
        breakfastList[0].purchased = true
        for item in breakfastList {
            print(item.description)
        }
    }
    
    func testVehicleTwo() {
        let vehicle = VehicleTwo()
        print("Vehicle: \(vehicle.description)")
        
        let bicycle = BicycleTwo()
        print("Bicycle: \(bicycle.description)")
        
    }
    
    func testQuestion() {
        let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
        cheeseQuestion.ask()
        cheeseQuestion.response = "Yes, I do like cheese."
        
        let beetsQuestion = SurveyQuestion(text: "How about beets?")
        beetsQuestion.ask()
        beetsQuestion.response = "I also like beets. (But not with cheese.)"
    }
    
    func testColor() {
        struct Color {
            let red, green, blue: Double
            init(red: Double, green: Double, blue: Double) {
                self.red = red
                self.green = green
                self.blue = blue
            }
            init(white: Double) {
                red = white
                green = white
                blue = white
            }
        }
        
//        let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
//        let halfGray = Color(white: 0.5)
        
        
        struct Celsius {
            var temperatureCelsius: Double = 0.0
            init(fromFahrenheit fahrenheit: Double) {
                temperatureCelsius = (fahrenheit - 32.0) / 1.8
            }
            init(fromKelvin kelvin: Double) {
                temperatureCelsius = kelvin - 273.15
            }
            init(_ celsius: Double) {
                temperatureCelsius = celsius
            }
         }
        let bodyTemperature = Celsius(37.0)
        print("temperature : \(bodyTemperature.temperatureCelsius)")
        
    }
    
    func testInitialization() {
        struct Fahrenheit {
//            var temperature: Double
//            init() {
//                temperature = 32.0
//            }
            var temperature = 32.0
            
        }
        let f = Fahrenheit()
        print("The default temperature is \(f.temperature)° Fahrenheit")
        
        struct Celsius {
            var temperatureInCelsius: Double
            init(fromFahrenheit fahrenheit: Double) {
                temperatureInCelsius = (fahrenheit - 32.0) / 1.8
            }
            init(fromKelvin kelvin: Double) {
                temperatureInCelsius = kelvin - 273.15
            }
        }
        let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
        print("temperature \(boilingPointOfWater.temperatureInCelsius)")
        
        let freezingPointOfWater = Celsius(fromKelvin: 273.15)
        print("temperature \(freezingPointOfWater.temperatureInCelsius)")
        
    }
    
    func testVehicle() {
        let someVehicle = Vehicle()
        print("Vehicle: \(someVehicle.description)")
        
        let bicycle = Bicycle()
        bicycle.hasBasket = true
        bicycle.currentSpeed = 15.0
        print("Bicycle: \(bicycle.description)")
     
        let tandem = Tandem()
        tandem.hasBasket = true
        tandem.currentNumberOfPassengers = 2
        tandem.currentSpeed = 22.0
        print("Tandem: \(tandem.description)")
        
        let car = Car()
        car.currentSpeed = 25.0
        car.gear = 3
        print("Car: \(car.description)")
        
        let automatic = AutomaticCar()
        automatic.currentSpeed = 35.0
        print("AutomaticCar: \(automatic.description)")
    }
    
    func testMatrix() {
        struct Matrix {
            let rows: Int, columns: Int
            var grid: [Double]
            init(rows: Int, columns: Int) {
                self.rows = rows
                self.columns = columns
                grid = Array(repeating: 0.0, count: rows*columns)
            }
            func indexIsValidForRow(_ row: Int, column: Int) -> Bool {
                return row >= 0 && row < rows && column >= 0 && column < columns
            }
            
            subscript(row: Int, column: Int) -> Double {
                get {
                    assert(indexIsValidForRow(row, column: column))
                    return grid[(row * columns) + column]
                }
                set {
                    assert(indexIsValidForRow(row, column: column))
                    grid[(row * columns) + column] = newValue
                }
            }
        }
        var myMatrix = Matrix(rows: 2, columns: 2)
        myMatrix[0, 1] = 1.5
        myMatrix[1, 0] = 3.2
        
//        let someValue = myMatrix[2, 2]
    }
    
    func testTimesTable() {
        struct TimesTable {
            let multiplier: Int
            subscript(index: Int) -> Int {
                return multiplier * index
            }
        }
        let threeTimesTable = TimesTable(multiplier: 3)
        print("3的6倍是\(threeTimesTable[6])")
        
    }
    
    func testLevel() {
        var player = Player(name: "Argyrios")
        player.completedLevel(1)
        print("highest unlocked level is now \(LevelTracker.highestUnlockedLevel)")
        
        player = Player(name: "Beto")
        if player.tracker.advanceToLevel(6) {
            print("player is now no level 6")
        } else {
            print("level 6 has not yet been unlocked")
        }
    }
    
    func testModifyingValue() {
        struct Point {
            var x = 0.0, y = 0.0
            mutating func moveByX(_ deltaX: Double, y deltaY: Double) {
//                x += deltaX
//                y += deltaY
                self = Point(x: x+deltaX, y: y+deltaY)
            }
        }
        var somePoint = Point(x: 1.0,y: 1.0)
        somePoint.moveByX(2.0, y: 3.0)
        print("The point is now at (\(somePoint.x),\(somePoint.y))")
        
        
        enum TriStateSwitch {
            case off, low, high
            mutating func next() {
                switch self {
                case .off:
                    self = .low
                case .low:
                    self = .high
                case .high:
                    self = .off
                }
            }
        }
        var ovenLight = TriStateSwitch.low
        ovenLight.next()
        ovenLight.next()
        
    }
    
    func testCounter() {
        let counter = Counter()
        counter.increment()
        print(counter.count)
        counter.incrementBy(5)
        print(counter.count)
        counter.reset()
        print(counter.count)
        
        counter.incrementBy(5, numberOfTimes: 3)
        print(counter.count)
    }
    
    func testSetValue() {
        class StepCounter {
            var totalSteps: Int = 0 {
                willSet(newTotalSteps) {
                    print("About to set totalSteps to \(newTotalSteps)")
                }
                didSet {
                    if totalSteps > oldValue {
                        print("Added \(totalSteps - oldValue) steps")
                    }
                }
            }
            
        }
        let stepCounter = StepCounter()
        stepCounter.totalSteps = 200
        stepCounter.totalSteps = 360
        stepCounter.totalSteps = 896
        
    }
    
    func testEvaluate() {
        indirect enum ArithmeticExpression {
            case number(Int)
            case addition(ArithmeticExpression, ArithmeticExpression)
            case multiplication(ArithmeticExpression, ArithmeticExpression)
        }
        func evaluate(_ expression: ArithmeticExpression) -> Int {
            switch expression {
            case let .number(value):
                return value
            case let .addition(left, right):
                return evaluate(left) + evaluate(right)
            case let .multiplication(left, right):
                return evaluate(left) * evaluate(right)
            }
        }
        
        let five = ArithmeticExpression.number(5)
        let four = ArithmeticExpression.number(4)
        let sum = ArithmeticExpression.addition(five, four)
        let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))
        print(evaluate(product))

    }
    
    func testEnum() {
        enum Barcode {
            case upca(Int, Int, Int, Int)
            case qrCode(String)
        }
        var productBarcode = Barcode.upca(8, 85909, 51226, 3)
        productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
        
        switch productBarcode {
        case .upca(let numberSystem, let manufacturer, let product, let check):
            print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
        case .qrCode(let productCode):
            print("QR code: \(productCode)")
        }
        
        productBarcode = Barcode.upca(8, 85909, 51226, 3)
        switch productBarcode {
        case let .upca(numberSystem, manufacturer, product, check):
            print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
        case let .qrCode(productCode):
            print("QR code: \(productCode)")
        }

    }
    
    func testAutoClosueres() {
        var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Danilla"]
        print(customersInLine.count)
        
        let customerProvider = { customersInLine.remove(at: 0) }
        print(customersInLine.count)
        
        print("Now serving \(customerProvider())!")
        print(customersInLine.count)
        
        func serveCustomer(_ customerProvider: () -> String) {
            print("Now serving \(customerProvider())!")
        }
        serveCustomer( { customersInLine.remove(at: 0) })
        
        func serveCustomer2(_ customerProvider: @autoclosure () -> String) {
            print("Now serving \(customerProvider())!")
        }
        
        serveCustomer2(customersInLine.remove(at: 0))
        
        var customerProviders: [() -> String] = []
        func collectCustomerProviders( _ customerProvider: @autoclosure @escaping () -> String) {
            customerProviders.append(customerProvider)
        }
        collectCustomerProviders(customersInLine.remove(at: 0))
        collectCustomerProviders(customersInLine.remove(at: 0))
        
        print("Collected \(customerProviders.count) closures.")
        
        for customerProvider in customerProviders {
            print("Now serving \(customerProvider())!")
        }
        
    }
    
    func testNonescaping() {
        let instance = SomeClass()
        instance.doSomething()
        print(instance.x)
        
        completionHandlers.first?()
        print(instance.x)
        
    }
    
    
    
    func testMap() {
        let digitNames = [0: "Zero", 1: "One", 2: "Two", 3: "Three", 4: "Four", 5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
        ]
        let numbers = [16, 58, 510]
        let strings = numbers.map {
            (number) -> String in var output = ""
            var tempNumber = number
            while tempNumber > 0 {
                output = digitNames[tempNumber % 10]! + output
                tempNumber = tempNumber / 10
            }
            return output
        }
        print(strings)
    }
    
    
    func testSort() {
        let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
        func backwards(_ s1: String, s2: String) -> Bool {
            return s1 > s2
        }
        var reversed = names.sorted(by: backwards)
        
//        闭包表达式语法(Closure Expression Syntax)
        reversed = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 < s2
        })
        
//        根据上下文推断类型(Inferring Type From Context)
        reversed = names.sorted( by: {s1, s2 in return s1>s2} )
        
//        单表达式闭包隐式返回(Implicit Return From Single-Expression Clossures)
        reversed = names.sorted( by: {s1, s2 in s1>s2} )
        
//        参数名称缩写(Shorthand Argument Names)
        reversed = names.sorted( by: { $0 < $1 } )
        
//        运算符函数(Operator Functions)
        reversed = names.sorted(by: >)
        print(reversed)
    }
    
    func testAlignRight() {
        let originalString = "hello"
        let paddedString = alignRight(originalString, totalLength: 10, pad: "-")
        print(paddedString)
    }
    
    func alignRight(_ string: String, totalLength: Int, pad: Character) -> String {
        var string = string
        let amountToPad = totalLength - string.characters.count
        if amountToPad < 1 {
            return string
        }
        let padString = String(pad)
        for _ in 1...amountToPad {
            string = padString + string;
        }
        return string
    }
    
    func repeatItem<Item>(_ item: Item, numberOfTimes: Int) -> [Item] {
        var result = [Item]()
        for _ in 0..<numberOfTimes {
            result.append(item)
        }
        return result
    }
    
    func testFunctions() {
        repeatItem("knock", numberOfTimes: 4)
        // Reimplement the Swift standard library's optional type
        enum OptionalValue<Wrapped> {
            case none
            case some(Wrapped)
        }
        var possibleInteger: OptionalValue<Int> = .none
        print(possibleInteger)
        possibleInteger = .some(100)
        
        // 常量
        let maximumNumberOfLoginAttempts = 10
        // 变量
        var currentLoginAttempt = maximumNumberOfLoginAttempts+2
        currentLoginAttempt += 1
        //        maximumNumberOfLoginAttempts = 2
        //        currentLoginAttempt = 20
        
        
        if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber {
            print("\(firstNumber)<\(secondNumber)")
        }
        
        let possibleString: String? = "An optional string."
        let forcedString: String = possibleString!
        let assumedString: String! = "An implicitly unwrapped optional string."
        let implicitString: String = assumedString
        print("\(forcedString) --- \(implicitString)")
        
        if assumedString != nil {
            print(assumedString)
        }
        
        if let definiteString = assumedString {
            print(definiteString)
        }
        
        var threeDoubles = [Double](repeating: 0.0, count: 3)
        threeDoubles[2] += 5.5
        print(threeDoubles)
    }
    
    func printSimpleClass() {
        let a = SimpleClass()
        a.adjust()
        let aDescription = a.simpleDescription
        
        struct SimpleStructure: ExampleProtocol {
            var simpleDescription: String = "A simple structure"
            mutating func adjust() {
                simpleDescription += "(adjusted)"
            }
        }
        
        print(aDescription)
        var b = SimpleStructure()
        b.adjust()
        let bDescription = b.simpleDescription
        
        
        print(bDescription)
        
        let protocalValue: ExampleProtocol = a
        print(protocalValue.simpleDescription)
        
    }
    
    func printServer() {
        let success = ServerResponse.result("6:00 am", "8:09 pm")
        let failure = ServerResponse.error("Out of cheese")
        print(success)
        print(failure)
        switch success {
        case let .result(sunrise, sunset):
            let serverResponse = "Sunrise is at \(sunrise)"
            print(serverResponse)
            
        case let .error(error):
            let serverResponse = "Failure... \(error)"
            print(serverResponse)
        }
        
        switch failure {
        case let .result(sunrise, sunset):
            let serverResponse = "Sunrise is at \(sunrise)"
            print(serverResponse)
            
        case let .error(error):
            let serverResponse = "Failure... \(error)"
            print(serverResponse)
        }
    }
    
    enum ServerResponse {
        case result(String, String)
        case error(String)
    }
    
    struct Card {
        var rank: Rank
        var suit: Suit
        func simpleDescription() -> String {
            return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
        }
    }
    
    func printSuit() {
        let hearts = Suit.hearts
        let heartsDescription = hearts.simpleDescription()
        print(heartsDescription)
        
        let threeOfSpades = Card(rank: .three,suit:  .spades)
        let threeOfSpadesDescription = threeOfSpades.simpleDescription()
        print(threeOfSpadesDescription)
    }
    
    enum Suit {
        case spades, hearts, diamonds, clubs
        func simpleDescription() -> String {
            switch self {
            case .spades:
                return "spades"
            case .hearts:
                return "hearts"
            case .diamonds:
                return "diamonds"
            case .clubs:
                return "clubs"
            }
        }
    }
    
    func printAce() {
        let ace = Rank.ace
        let aceRawValue = ace.rawValue
        
        print("ace \(ace) , rawValue \(aceRawValue)");
        
        if let convertedRank = Rank(rawValue: 12) {
            let threeDescription = convertedRank.simpleDescription()
            print(threeDescription)
        }
    }
    
    enum Rank: Int {
        case ace = 1
        case two, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king
        
        func simpleDescription() -> String {
            switch self {
            case .ace:
                return "ace"
            case .jack:
                return "jack"
            case .queen:
                return "queen"
            case .king:
                return "king"
            default:
                return String(self.rawValue)
            }
        }
    }
    
    
    func printOptionalSquare() {
        let triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")
        print(triangleAndSquare.square.sideLength)
        print(triangleAndSquare.triangle.sideLength)
        triangleAndSquare.square = Square(sideLength: 50, name: "larger square")
        print(triangleAndSquare.triangle.sideLength)
        let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
        print(optionalSquare)
        let sideLength = optionalSquare?.sideLength
        print(sideLength)
    }
    
    class TriangleAndSquare {
        var triangle: EquilateralTriangle {
            willSet {
                square.sideLength = newValue.sideLength
            }
        }
        
        var square: Square {
            willSet {
                triangle.sideLength = newValue.sideLength
            }
        }
        init(size: Double, name: String) {
            square = Square(sideLength: size, name: name)
            triangle = EquilateralTriangle(sideLength: size, name: name)
        }
    }
    
    func printTriangle() {
        let triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
        print(triangle.perimeter)
        
        triangle.perimeter = 9.9
        print(triangle.sideLength)
    }
    
    class EquilateralTriangle: NamedShape {
        var sideLength: Double = 0.0
        
        init(sideLength: Double, name: String) {
            self.sideLength = sideLength
            super.init(name: name)
            numberOfSides = 3
        }
        
        var perimeter: Double {
            get {
                return 3.0 * sideLength
            }
            set {
                sideLength = newValue / 3.0
            }
        }
        
        override func simpleDescription() -> String {
            return "An equilateral triangle with sides of length \(sideLength)."
        }
    }
    
    func printSquare() {
        let test = Square(sideLength: 5.2, name: "my test square")
        test.area()
        test.simpleDescription()
        print(test.area())
    }
    
    class Square: NamedShape {
        var  sideLength: Double
        
        init(sideLength: Double, name: String) {
            self.sideLength = sideLength
            super.init(name: name)
            numberOfSides = 4
        }
        
        func area() -> Double {
            return sideLength * sideLength
        }
        
        override func simpleDescription() -> String {
            return "A square with sides of length \(sideLength)."
        }
    }
    
    class NamedShape {
        var numberOfSides: Int = 0
        var name: String
        
        init(name: String) {
            self.name = name
        }
        
        func simpleDescription() -> String {
            return "A shape with \(numberOfSides) sides."
        }
    }
    
    func printShape() {
        let shape = Shape()
        shape.numberOfSides = 7
        let shapeDescription = shape.simpleDescription()
        print(shapeDescription)
    }
    
    class Shape {
        var numberOfSides = 0
        func simpleDescription() -> String {
            return "A shape with \(numberOfSides) sides"
        }
    }
    
    func printHasAnyMatches() {
        let numbers = [20, 19, 7, 12]
        hasAnyMatches(numbers, condition: lessThanTen)
        print(hasAnyMatches(numbers, condition: lessThanTen))
        numbers.map({
            (number: Int) -> Int in
            let result = 3 * number
            return result
        })
        
        let mappedNumbers = numbers.map({ number in 3 * number})
        print(mappedNumbers)
        
        let sortedNumbers = numbers.sorted { $0 < $1}
        print(sortedNumbers)
    }
    
    func hasAnyMatches(_ list: [Int], condition: (Int) -> Bool) -> Bool {
        for item in list {
            if condition(item) {
                return true
            }
        }
        return false
    }
    
    func lessThanTen(_ number: Int) -> Bool {
        return number < 10
    }

    func printIncrement() {
        let increment = makeIncrementer()
        print(increment(7))
    }
    func makeIncrementer() -> ((Int) -> Int) {
        func addOne(_ number: Int) -> Int {
            return 1 + number
        }
        return addOne
    }
    
    func printFifteen() {
        returnFifteen()
        print(returnFifteen())
    }
    
    func returnFifteen() -> Int {
        var y = 10
        func add() {
            y += 5
        }
        add()
        return y
    }
    
    func calculateStatistics(_ scores: [Int]) -> (min: Int, max: Int, sum: Int) {
        var min = scores[0]
        var max = scores[0]
        var sum = 0
        
        for score in scores {
            if score > max {
                max = score
            } else if score < min {
                min = score
            }
            sum += score
        }
        return (min, max, sum)
    }
}

class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class."
    var anotherProperty: Int = 69105
    func adjust() {
        simpleDescription += " Now 100% adjusted."
    }
    
    
}

protocol ExampleProtocol {
    var simpleDescription: String { get }
    mutating func adjust()
}

extension Int: ExampleProtocol {
    var simpleDescription: String {
        return "The number \(self)"
    }
    mutating func adjust() {
        self += 42
    }
}

