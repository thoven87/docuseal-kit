//
//  DocuSealClient+Submissions.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/3/25.
//

import Foundation

extension JSONDecoder {
  internal static var docuSealDecoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom { decoder in
      let container = try decoder.singleValueContainer()
      let string = try container.decode(String.self)

      if let date = ISO8601DateFormatter().date(from: string) {
        return date
      }

      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      if let date = formatter.date(from: string) {
        return date
      }

      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      if let date = formatter.date(from: string) {
        return date
      }

      throw DecodingError.dataCorruptedError(
        in: container, debugDescription: "Cannot decode date string \(string)")
    }
    return decoder
  }
}

extension JSONEncoder {
  internal static var docuSealEncoder: JSONEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    return encoder
  }
}
