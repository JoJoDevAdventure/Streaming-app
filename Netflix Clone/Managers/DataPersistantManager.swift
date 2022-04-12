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
    
    enum DataBaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDelete
    }
    
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
            print(error.localizedDescription)
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
            print(error.localizedDescription)
            completion(.failure(DataBaseError.failedToFetchData))
        }
    }
    
    //CoreData : Delete
    func deleteTitileWith(model : TitleItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
            
        } catch {
            print(error.localizedDescription)
            completion(.failure(DataBaseError.failedToDelete))
        }
    }
    
}
