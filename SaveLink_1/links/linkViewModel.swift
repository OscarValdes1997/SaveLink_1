//
//  linkViewModel.swift
//  SaveLink_1
//
//  Created by Oscar Valdes on 04/07/23.
//

import Foundation
//hacemos la coneccion entre la  el View model y el repositorio para posterirmente mandar esa informacion a la base de datos por medio del Datasource
final class LinkViewModel: ObservableObject {
    
    @Published var links: [LinkModel] = []
    @Published var messageError: String?
    
    private let linkRepository: LinkRepository
    
    init(linkRepository: LinkRepository = LinkRepository()){
    
        self.linkRepository = linkRepository
    }
    
    //obtenemos los datos del repositorio que contiene los datos provenientes de la base de datos
    func getAllLink(){
        linkRepository.getAllLinks { [weak self]result in
            switch result{
                
            case.success(let linkModels):
                self?.links = linkModels
                
            case.failure(let error):
                self?.messageError = error.localizedDescription
            }
        }
    }
    
    //con este metodo hacemos que la informacion que otorgo el usuario se mande al repoditorio para posterimente ser mandado a la base de datos
    func createNewLink(fromURL url: String){
        linkRepository.createNewLink(withURL: url){ [weak self] result in
            switch result{
            case .success(let link):
                //solo se manda un mensaje pues ladots se colocaran directamente de la base de datos
                print("nuevo link \(link.title) optenido")
            case .failure(let error):
                self?.messageError = error.localizedDescription
            }
        }
    }
    
    func updateIsFavorited(link: LinkModel){
        let updateLink = LinkModel(id: link.id,
                                   url: link.url,
                                   title: link.title,
                                   idFavorited: link.idFavorited ? false: true,
                                   isCompleted: link.isCompleted)
        
        linkRepository.update(link: updateLink)
    }
    
    func updateIsComplite(link: LinkModel){
        let updateLink = LinkModel(id: link.id,
                                   url: link.url,
                                   title: link.title,
                                   idFavorited: link.idFavorited ,
                                   isCompleted: link.isCompleted ? false: true)
        
        linkRepository.update(link: updateLink)
    }
    
    func delete(link: LinkModel){
        linkRepository.delete(link: link)
    }
}
