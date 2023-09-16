//
//  UserView.swift
//  SwiftUIMVVM
//
//  Created by Ankit kushwah on 16/09/23.
//

import SwiftUI

struct UserView: View {
    @StateObject private var viewModel = UserViewModel()
    var body: some View {
        VStack(spacing: 20){
            AsyncImage(url: URL(string: viewModel.user?.avatarUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle().foregroundColor(.secondary)
                
            }.frame(width: 120, height: 120)
            Text(viewModel.user?.login ?? "user name")
                .bold()
                .font(.title3)
                .foregroundColor(.red)
            Text( viewModel.user?.bio ?? "This is where th GitHub bio will go. Let's make it long so it snaps two lines.")
                .padding()
            Spacer()
        }
        .padding()
        .task {
            await viewModel.callgetUserAPI()
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
