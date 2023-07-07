//
//  HomeView.swift
//  SaveLink_1
//
//  Created by Oscar Valdes on 27/06/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @StateObject var linkViewModel: LinkViewModel = LinkViewModel()
    var body: some View {
        NavigationView{
            VStack{
                Text("Bienvenido \(authenticationViewModel.user?.email ?? "No usuario Master")")
                    .padding(.top,32)
                Spacer()
                LinkView(LinkViewModel: LinkViewModel())
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Home")
            .toolbar {
                Button("Logout"){
                    authenticationViewModel.logout()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(authenticationViewModel: AuthenticationViewModel())
    }
}
