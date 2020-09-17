import Foundation

protocol DAOProtocol: class {
    func fetchHotels(completion: @escaping(_ hotels: Hotels?, _ errorMsg: String?) -> Void)
}

final class DAO: DAOProtocol {
    
    private let session = URLSession.shared
    private let urlString = "https://www.hurb.com/search/api?q=buzios&page=1"
    
    func fetchHotels(completion: @escaping(_ hotels: Hotels?, _ errorMsg: String?) -> Void) {
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = HTTPMethod.GET.rawValue
        
        let task = session.dataTask(with: request) { (data, urlResponse, error) in
            if let data = data {
                let response = try? JSONDecoder().decode(QueryResponse.self, from: data)
                print(response)
                print(try? JSONSerialization.jsonObject(with: data) as? [String:Any])
                return
            }
            
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
        }
        task.resume()
    }
}

enum HTTPMethod: String {
    case GET
    case POST
}
