//
//  DataPersistantManager.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 11/04/2022.
//

import Foundation
import UIKit
import CoreData

class DataPersistantManager {
    
    
    
    static let shared = DataPersistantManager()
    
    //CoreData : Insert into Local
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.overview = model.overview
        item.original_name = model.original_name
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToSaveData))
        }
    }
    
    //CoreData : Fetch all
    func fetchingTitlesFromDatabase(completion: (Result<[TitleItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DataBaseError.failedToFetchData))
        }
    }
    
    //CoreData : Delete
    func deleteTitileWith(model : TitleItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model) // asking database manager to delete object
        
        do {
            
            try context.save()
            completion(.success(()))
            
        } catch {
            completion(.failure(DataBaseError.failedToDelete))
        }
    }
    
    func deleteAllTitles(items: [TitleItem],completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        for item in items {
            context.delete(item)
        }
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToDelete))
        }
        
    }
    
}

extension DataPersistantManager {
    
    enum DataBaseError: LocalizedError {
        case failedToSaveData
        case failedToFetchData
        case failedToDelete
        
        var errorDescription: String? {
            switch self {
            case.failedToDelete :
                return "Failed to remove title"
            case.failedToSaveData :
                return "Failed to save title"
            case.failedToFetchData :
                return "Failed to fetch titles"
            }
        }
    }
    
}
