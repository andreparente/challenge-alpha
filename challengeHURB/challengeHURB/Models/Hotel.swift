import Foundation

public typealias Hotels = [Hotel]

public class Hotel: Codable {
    var isHotel: Bool?
    var category: String?
    
    /* deve mostrar seu nome, preço, cidade, estado, uma foto e três amenidades. */
    var name: String?
    var price: Price?
    var address: Address?
    var image: String?
    var imageURL: URL? {
        URL(string: image ?? "")
    }
//    
    var amenities: Amenities?
}
