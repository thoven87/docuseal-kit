//
//  DocusealError.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

import Foundation

/// A type-erased `Codable` value.
@frozen
public struct AnyCodable {
  public let value: Any

  /// Creates a new instance with the specified value.
  ///
  /// - Parameter value: The value to store.
  public init(_ value: Any) {
    self.value = value
  }
}

extension AnyCodable: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()

    if container.decodeNil() {
      self.value = NSNull()
    } else if let bool = try? container.decode(Bool.self) {
      self.value = bool
    } else if let int = try? container.decode(Int.self) {
      self.value = int
    } else if let uint = try? container.decode(UInt.self) {
      self.value = uint
    } else if let double = try? container.decode(Double.self) {
      self.value = double
    } else if let string = try? container.decode(String.self) {
      self.value = string
    } else if let array = try? container.decode([AnyCodable].self) {
      self.value = array.map({ $0.value })
    } else if let dict = try? container.decode([String: AnyCodable].self) {
      self.value = dict.mapValues({ $0.value })
    } else {
      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "AnyCodable cannot decode value"
      )
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()

    switch self.value {
    case is NSNull, is Void:
      try container.encodeNil()
    case let bool as Bool:
      try container.encode(bool)
    case let int as Int:
      try container.encode(int)
    case let int8 as Int8:
      try container.encode(int8)
    case let int16 as Int16:
      try container.encode(int16)
    case let int32 as Int32:
      try container.encode(int32)
    case let int64 as Int64:
      try container.encode(int64)
    case let uint as UInt:
      try container.encode(uint)
    case let uint8 as UInt8:
      try container.encode(uint8)
    case let uint16 as UInt16:
      try container.encode(uint16)
    case let uint32 as UInt32:
      try container.encode(uint32)
    case let uint64 as UInt64:
      try container.encode(uint64)
    case let float as Float:
      try container.encode(float)
    case let double as Double:
      try container.encode(double)
    case let string as String:
      try container.encode(string)
    case let date as Date:
      try container.encode(ISO8601DateFormatter().string(from: date))
    case let array as [Any]:
      try container.encode(array.map { AnyCodable($0) })
    case let dict as [String: Any]:
      try container.encode(dict.mapValues { AnyCodable($0) })
    default:
      let context = EncodingError.Context(
        codingPath: container.codingPath,
        debugDescription: "AnyCodable cannot encode value of type \(type(of: self.value))"
      )
      throw EncodingError.invalidValue(self.value, context)
    }
  }
}

extension AnyCodable: Equatable {
  public static func == (lhs: AnyCodable, rhs: AnyCodable) -> Bool {
    switch (lhs.value, rhs.value) {
    case is (NSNull, NSNull), is (Void, Void):
      return true
    case let (lhs as Bool, rhs as Bool):
      return lhs == rhs
    case let (lhs as Int, rhs as Int):
      return lhs == rhs
    case let (lhs as Int8, rhs as Int8):
      return lhs == rhs
    case let (lhs as Int16, rhs as Int16):
      return lhs == rhs
    case let (lhs as Int32, rhs as Int32):
      return lhs == rhs
    case let (lhs as Int64, rhs as Int64):
      return lhs == rhs
    case let (lhs as UInt, rhs as UInt):
      return lhs == rhs
    case let (lhs as UInt8, rhs as UInt8):
      return lhs == rhs
    case let (lhs as UInt16, rhs as UInt16):
      return lhs == rhs
    case let (lhs as UInt32, rhs as UInt32):
      return lhs == rhs
    case let (lhs as UInt64, rhs as UInt64):
      return lhs == rhs
    case let (lhs as Float, rhs as Float):
      return lhs == rhs
    case let (lhs as Double, rhs as Double):
      return lhs == rhs
    case let (lhs as String, rhs as String):
      return lhs == rhs
    case let (lhs as [String: AnyCodable], rhs as [String: AnyCodable]):
      return lhs == rhs
    case let (lhs as [AnyCodable], rhs as [AnyCodable]):
      return lhs == rhs
    default:
      return false
    }
  }
}

extension AnyCodable: CustomStringConvertible {
  public var description: String {
    switch value {
    case is NSNull:
      return "nil"
    case let value as CustomStringConvertible:
      return value.description
    default:
      return String(describing: value)
    }
  }
}

extension AnyCodable: CustomDebugStringConvertible {
  public var debugDescription: String {
    switch value {
    case let value as CustomDebugStringConvertible:
      return "AnyCodable(\(value.debugDescription))"
    default:
      return "AnyCodable(\(description))"
    }
  }
}

extension AnyCodable: ExpressibleByNilLiteral {
  public init(nilLiteral: ()) {
    self.init(NSNull())
  }
}

extension AnyCodable: ExpressibleByBooleanLiteral {
  public init(booleanLiteral value: Bool) {
    self.init(value)
  }
}

extension AnyCodable: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.init(value)
  }
}

extension AnyCodable: ExpressibleByFloatLiteral {
  public init(floatLiteral value: Double) {
    self.init(value)
  }
}

extension AnyCodable: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.init(value)
  }
}

extension AnyCodable: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: Any...) {
    self.init(elements)
  }
}

extension AnyCodable: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (String, Any)...) {
    self.init(Dictionary(uniqueKeysWithValues: elements))
  }
}
