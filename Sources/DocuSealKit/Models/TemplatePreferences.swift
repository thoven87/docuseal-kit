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
    public let fontSize: Int?
    public let fontType: String?
    public let font: String?
    public let color: String?
    public let align: String?
    public let valign: String?
    public let format: String?
    public let price: String?
    public let currency: String?
    public let mask: Bool?

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
