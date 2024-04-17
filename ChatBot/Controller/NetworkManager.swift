//
//  NetworkManager.swift
//  ChatBot
//
//  Created by Daming Wang on 4/9/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func fetchData(with requestBody: Data) async throws -> Data {
        
        let urlString = "https://api.openai.com/v1/chat/completions"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.httpBody = requestBody

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badResponse
        }

        return data
    }
    
    
    func fetchAudioData(with fileUrl: URL) async throws -> String {
        let urlString = "https://api.openai.com/v1/audio/transcriptions"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
       
        let boundary = "Boundary-\(UUID().uuidString)"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Model part
        let modelPart = "whisper-1"
        if let modelData = "--\(boundary)\r\nContent-Disposition: form-data; name=\"model\"\r\n\r\n\(modelPart)\r\n".data(using: .utf8) {
            body.append(modelData)
        }
        
        let formatPart = "text"
        if let formatData = "--\(boundary)\r\nContent-Disposition: form-data; name=\"response_format\"\r\n\r\n\(formatPart)\r\n".data(using: .utf8) {
            body.append(formatData)
        }

        // Audio file part
        let fileName = fileUrl.lastPathComponent
        guard let fileData = try? Data(contentsOf: fileUrl) else {
                throw NetworkError.fileError
        }
        if let filePartHeader = "--\(boundary)\r\nContent-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\nContent-Type: audio/mpeg\r\n\r\n".data(using: .utf8) {
            body.append(filePartHeader)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        let (data, response) = try await URLSession.shared.upload(for: request, from: body)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badResponse
        }

        guard let resultString = String(data: data, encoding: .utf8) else {
                throw URLError(.cannotParseResponse)
            }

        return resultString.trimmingCharacters(in: .newlines)
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case badResponse
    case fileError
}
