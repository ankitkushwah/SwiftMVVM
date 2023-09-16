//
//  UserViewModel.swift
//  SwiftUIMVVM
//
//  Created by Ankit kushwah on 16/09/23.
//

import Foundation
struct GitHubUser: Codable {
    let login: String
    let avatarUrl: String
    let bio: String
}

enum GHError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

extension UserView {
    @MainActor
    class UserViewModel: ObservableObject {
        @Published var user: GitHubUser?
        
        init() {
        }
        
        func callgetUserAPI() async {
            do {
                self.user = try await getUser()
            } catch GHError.invalidURL{
                print("invalidURL")
            } catch GHError.invalidResponse{
                print("invalidResponse")
            } catch GHError.invalidData{
                print("invalidData")
            } catch {
                print("unexpected")
            }
        }
        
        private func getUser()async throws -> GitHubUser {
            let endpoint = "https://api.github.com/users/ankitkushwah"
            guard let url = URL(string: endpoint) else {
                print("url not initialised")
                throw GHError.invalidURL
            }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw GHError.invalidResponse
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return  try decoder.decode(GitHubUser.self, from: data)
            } catch {
                throw GHError.invalidData
            }
        }
    }
}
