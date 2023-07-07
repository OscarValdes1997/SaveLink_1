//
//  linkDatasource.swift
//  SaveLink_1
//
//  Created by Oscar Valdes on 04/07/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


// esta estructura nos ayuda a almacenar los tados para posterirmente mandarlos a la base de datos
struct LinkModel: Decodable, Identifiable, Encodable{
    @DocumentID var id: String?
    let url: String
    let title: String
    let idFavorited: Bool
    let isCompleted: Bool
    
}

final class LinkDatasource {
    
    private let database = Firestore.firestore()
    private let collection = "links"
    
    
    //con este metodo se hace la coneccion ente los datos y la base de datos para posterimente usarlo en el repositorio o en la View
    
    func getAlllinks(completionBlock: @escaping (Result<[LinkModel], Error>) -> Void){
        database.collection(collection)
            .addSnapshotListener{ query, error in
                if let error = error{
                    print("Error al consefuir el link \(error.localizedDescription)")
                    completionBlock(.failure(error))
                    return
                }
                
                guard let documents = query?.documents.compactMap({ $0}) else{
                    completionBlock(.success([]))
                    return
                }
                
                let links = documents.map {try? $0.data(as: LinkModel.self)}
                    .compactMap{ $0 }
                completionBlock(.success(links))
                
            }
    }
    
    
    // con este metodo guardamos los datos que nos da el usuario en la base de datos
    func createNew(link: LinkModel, completionBlock:@escaping (Result<LinkModel, Error>) -> Void){
        do{
            
            _ = try database.collection(collection).addDocument(from: link)
            completionBlock(.success(link))
        }catch{
            completionBlock(.failure(error))
        }
    }
    //Con este metodo Actualizamos la Informacion de un registro ya existente.
    func update(link: LinkModel){
        guard let documentId = link.id else{
            return
        }
        do{
            _ = try database.collection(collection).document(documentId).setData(from: link)
        } catch {
            print("Error de Actualizacion en la Base de Datos")
        }
    }
    ////Con este metodo Eliminamos la Informacion de un registro ya existente.
    func delete(link: LinkModel){
        guard let documentId = link.id else{
            return
        }
        database.collection(collection).document(documentId).delete()
    }
}
