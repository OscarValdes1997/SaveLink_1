//
//  linkRepository.swift
//  SaveLink_1
//
//  Created by Oscar Valdes on 04/07/23.
//

import Foundation


//inicializamos los datos que nos mandan desde LinkData para poder hacer la coneccion con el View model, es como el puente de coneccion
final class LinkRepository {
    private let linkDatasource: LinkDatasource
    private let metadataDatasource: MetadataDatasource
    
    init(linkDatasource: LinkDatasource = LinkDatasource(),
         metadataDatasource: MetadataDatasource = MetadataDatasource()) {
        self.linkDatasource = linkDatasource
        self.metadataDatasource = metadataDatasource
    }
    
    //con este metodo conseguimos los datos que estan en la base de datos, los cuales mandaremos a la view
    
    func getAllLinks(completionBlock: @escaping (Result<[LinkModel], Error>) -> Void){
        linkDatasource.getAlllinks(completionBlock: completionBlock)
        }
    
    // con este metodo instanciamos un nuevo dato u objeto el cual sera mandado a la base de datos
    func createNewLink(withURL url: String, CompletionBlock: @escaping (Result<LinkModel, Error>)-> Void) {
        metadataDatasource.getMetadata(fromURL: url) { [weak self] result in
            
            switch result {
            case .success(let linkmodel):
                self?.linkDatasource.createNew(link: linkmodel, completionBlock: CompletionBlock)
            case.failure(let error):
                CompletionBlock(.failure(error))
            }
        }
    }
    
    func update(link: LinkModel){
        linkDatasource.update(link: link)
    }
    
    func delete(link: LinkModel){
        linkDatasource.delete(link: link)
    }
}


