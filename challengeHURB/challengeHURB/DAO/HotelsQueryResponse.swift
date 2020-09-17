import Foundation

struct QueryResponse: Codable {
    var results: [Hotel]?
    
    enum QueryResponseKeys: String, CodingKey {
        case results
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: QueryResponseKeys.self)
        results = try? container.decode(Hotels.self, forKey: .results)
        results = results?.filter({$0.category == Categories.hotel.rawValue})
    }
}

enum Categories: String {
    case hotel
}

struct Meta: Codable {
    var count: Double
}
