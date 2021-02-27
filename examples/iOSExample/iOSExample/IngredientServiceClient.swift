import Foundation

protocol IngredientServiceClient {
    typealias FetchIngredientsResponseHandler = (Result<[Ingredient], Error>) -> Void
    typealias CreateIngredientResponseHandler = (Result<Ingredient, Error>) -> Void

    func fetchIngredients(onResponse: @escaping FetchIngredientsResponseHandler)
    func createIngredient(withName name: String, onResponse: @escaping CreateIngredientResponseHandler)
}

final class HttpIngredientServiceClient: IngredientServiceClient {
    let baseUrl: String

    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }

    convenience init() {
        self.init(baseUrl: Config.baseUrl)
    }

    func fetchIngredients(onResponse: @escaping FetchIngredientsResponseHandler) {
        guard let request = getRequest(to: "/ingredients") else { return }
        perform(request: request, onResponse: onResponse)
    }

    func createIngredient(withName name: String, onResponse: @escaping CreateIngredientResponseHandler) {
        let body = CreateIngredientRequestBody(name: name)
        guard let request = postRequest(to: "/ingredients", with: body) else { return }
        perform(request: request, onResponse: onResponse)
    }

    private struct CreateIngredientRequestBody: Codable {
        let name: String
    }

    private func getRequest(to path: String) -> URLRequest? {
        guard let url = URL(string: baseUrl + "/ingredients") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    private func postRequest<T>(to path: String, with body: T) -> URLRequest? where T: Encodable {
        guard let url = URL(string: baseUrl + path) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try self.jsonEncoder.encode(body)
            return request
        } catch {
            return nil
        }
    }

    private func perform<ResponseBody: Decodable>(
        request: URLRequest,
        onResponse: @escaping (Result<ResponseBody, Error>
    ) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async { onResponse(.failure(error!)) }
                return
            }
            do {
                let responseBody = try self.jsonDecoder.decode(ResponseBody.self, from: data)
                DispatchQueue.main.async { onResponse(.success(responseBody)) }
            } catch {
                DispatchQueue.main.async { onResponse(.failure(error)) }
                return
            }
        }.resume()
    }
}
