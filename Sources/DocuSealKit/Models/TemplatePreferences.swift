//
//  TemplatePreferences.swift
//  docuseal-kit
//
//  Created by Stevenson Michel on 5/10/25.
//

//
//In DocuSeal, `preferences` is an object type that contains configuration settings for various field types. It allows you to customize how fields appear and behave in your documents.
//
//For example, within the `preferences` object, you can specify:
//
//- `font_size`: Integer value for text size in pixels
//- `font_type`: String value like "bold", "italic", or "bold_italic"
//- `font`: Font family such as "Times", "Helvetica", or "Courier"
//- `color`: Text color like "black", "white", or "blue"
//- `align`: Horizontal alignment ("left", "center", "right")
//- `valign`: Vertical alignment ("top", "center", "bottom")
//- `format`: Data format specifications for different field types
//- `price` and `currency`: For payment fields
//- `mask`: Boolean to indicate if sensitive data should be masked
//
//The `format` property is particularly useful as it allows you to specify formats for different field types, such as date formats (e.g., "DD/MM/YYYY"), signature formats (e.g., "drawn", "typed", "drawn_or_typed"), or currency formats for number fields.
//
//You can find more details about preferences in the API documentation at https://www.docuseal.com/docs/api.
public struct TemplatePreferences: Codable, Sendable {
    /// Font size of the field value in pixels.
    public let fontSize: Int?
    /// Font type of the field value.
    public let fontType: FontType?
    /// Font family of the field value.
    public let font: Font?
    /// Font color of the field value.
    public let color: Color?
    /// Horizontal alignment of the field text value.
    public let align: Align?
    /// Vertical alignment of the field text value.
    public let valign: VAlign?
    /// The data format for different field types.
    /// - Date field: accepts formats such as DD/MM/YYYY (default: MM/DD/YYYY).
    /// - Signature field: accepts drawn, typed, drawn_or_typed (default), or upload.
    /// - Number field: accepts currency formats such as usd, eur, gbp.
    /// Example: DD/MM/YYYY
    public let format: String?
    /// Price value of the payment field. Only for payment fields.
    /// Example: 99.99
    public let price: Double?
    /// Currency value of the payment field. Only for payment fields.
    /// Default: USD
    /// Possible values: USD, EUR, GBP, CAD, AUD
    public let currency: Currency?
    /// Set `true` to make sensitive data masked on the document.
    /// Default: false
    public let mask: Bool?
    
    public enum Currency: String, Codable, Sendable {
        case usd = "USD"
        case eur = "EUR"
        case gbp = "GBP"
        case cad = "CAD"
        case aud = "AUD"
    }
    
    public enum Align: String, Codable, Sendable {
        case left
        case center
        case right
    }
    
    public enum VAlign: String, Codable, Sendable {
        case top
        case center
        case bottom
    }
    
    public enum Color: String, Codable, Sendable {
        case black
        case white
        case blue
    }
    
    public enum Font: String, Codable, Sendable {
        case times = "Times"
        case helvetica = "Helvetica"
        case courier = "Courier"
    }
    
    public enum FontType: String, Codable, Sendable {
        case bold
        case italic
        case boldItalic = "bold_italic"
    }

    enum CodingKeys: String, CodingKey {
        case fontSize = "font_size"
        case fontType = "font_type"
        case font
        case color
        case align
        case valign
        case format
        case price
        case currency
        case mask
    }
}
