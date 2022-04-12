//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 05/04/2022.
//

import Foundation
import UIKit

struct constants {
    static let API_KEY = "e53859ffccc2a7c27ed875387fd3177b"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyAUlHe7ZoXngU9GY7foBzcpA_I6-qDKhpg"
    static let baseYT = "https://youtube.googleapis.com/youtube/v3/search?maxResults=2&"
}

enum APIError: Error {
    case failedToLoadData
}

class APICaller {
    
    //Instrance
    static let shared = APICaller()
    
    //TMDB API CALL : Trending Movies
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(constants.baseURL)/3/trending/movie/day?api_key=\(constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TitlesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToLoadData))
            }
            
        }
        task.resume()
    }
    
    //TMDB API CALL : Trending Tv shows
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(constants.baseURL)/3/trending/tv/day?api_key=\(constants.API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TitlesResponse.self, from: data)
                completion(.success(results.results))
            } catch{
                print(APIError.failedToLoadData)
            }
        }
        task.resume()
    }
    
    //TMDB API CALL : Upcoming Movies
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(constants.baseURL)/3/movie/upcoming?api_key=\(constants.API_KEY)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TitlesResponse.self, from: data)
                completion(.success(results.results))
            } catch{
                print(APIError.failedToLoadData)
            }
        }
        task.resume()
    }
    
    //TMDB API CALL : Popular Movies
    func getPopular(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(constants.baseURL)/3/movie/popular?api_key=\(constants.API_KEY)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TitlesResponse.self, from: data)
                completion(.success(results.results))
            } catch{
                print(APIError.failedToLoadData)
            }
        }
        task.resume()
    }
    
    //TMDB API CALL : Top Rated Tv shows
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(constants.baseURL)/3/tv/top_rated?api_key=\(constants.API_KEY)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TitlesResponse.self, from: data)
                completion(.success(results.results))
            } catch{
                print(APIError.failedToLoadData)
            }
        }
        task.resume()
    }
    
    //TMDB API CALL : Discover Tv shows
    func getDiscoverTv(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(constants.baseURL)/3/discover/tv?api_key=\(constants.API_KEY)&language=en-US&sort_by=popularity.desc&page=1&timezone=America%2FNew_York&include_null_first_air_dates=false&with_watch_monetization_types=flatrate&with_status=0&with_type=0") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TitlesResponse.self, from: data)
                completion(.success(results.results))
            } catch{
                print(APIError.failedToLoadData)
            }
        }
        task.resume()
    }
    
    //TMDB API CALL : Search with query
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(constants.baseURL)/3/search/movie?api_key=\(constants.API_KEY)&query=\(query)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TitlesResponse.self, from: data)
                completion(.success(results.results))
            } catch{
                print(APIError.failedToLoadData)
            }
        }
        task.resume()
    }
    
    //YOUTUBE API CALL : Seach with query
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(constants.baseYT)q=\(query)&key=\(constants.YoutubeAPI_KEY)") else {return}
    
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResonse.self, from: data)
                completion(.success(results.items[0]))
            } catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}
