//
//  LinkView.swift
//  SaveLink_1
//
//  Created by Oscar Valdes on 05/07/23.
//

import SwiftUI

struct LinkView: View {
    @ObservedObject var LinkViewModel: LinkViewModel
    @State var text: String = ""
    //con esta variable hacemos que se oculte en automatico el teclado, pero se debe establecer tanto en el boton como en el textEditor
    @FocusState private var nameIsFocused: Bool
    
    
    var body: some View {
       
        VStack {
            TextEditor(text: $text)
                .focused($nameIsFocused)
                .frame(height: 100)
                .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.green, lineWidth: 2)
                )
                .padding(.horizontal, 12)
                .cornerRadius(3)
            Button(action: {
                
                nameIsFocused = false
                LinkViewModel.createNewLink(fromURL: text)
                text = ""
                
            }, label: {
                Label("Crear Link", systemImage: "link")
                
            })
            .tint(.green)
            .controlSize(.regular)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            
            if(LinkViewModel.messageError != nil){
                Text(LinkViewModel.messageError!)
                    .bold()
                    .foregroundColor(.red)
            }
            
            

            List {
                ForEach(LinkViewModel.links){ link in
                    VStack{
                        Text(link.title)
                            .bold()
                            .lineLimit(4)
                            .padding(.bottom, 8)
                        Text(link.url)
                            .foregroundColor(.gray)
                            .font(.caption)
                        
                        HStack{
                            Spacer()
                            if link.isCompleted{
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .foregroundColor(.blue)
                                    .frame(width: 15, height: 15)
                            }
                            if link.idFavorited{
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .foregroundColor(.yellow)
                                    .frame(width: 15, height: 15)
                            }
                        }
                    }
                    .swipeActions(edge: .leading){
                        Button(action: {
                            LinkViewModel.delete(link: link)
                        }, label: {
                            Label("Eliminar", systemImage: "trash.fill")
                        })
                        .tint(.red)
                }
                    .swipeActions(edge: .trailing){
                        Button(action: {
                            LinkViewModel.updateIsFavorited(link: link)
                        }, label: {
                            Label("Favorito", systemImage: "star.fill")
                        })
                        .tint(.yellow)
                        
                        Button(action: {
                            LinkViewModel.updateIsComplite(link: link)
                        }, label: {
                            Label("Completado", systemImage: "checkmark.circle.fill")
                        })
                        .tint(.blue)
                    }
                    
                }
            }
            .task {
                LinkViewModel.getAllLink()
        }
        }
    }
}

struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        LinkView(LinkViewModel: LinkViewModel())
    }
}
