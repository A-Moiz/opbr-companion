//
//  InfoButton.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 30/11/2024.
//

import SwiftUI

struct InfoButton: View {
    var infoMessage: String
    @ObservedObject var homeVM: HomeViewModel
    var body: some View {
        Button {
            homeVM.showAlert(message: infoMessage)
        } label: {
            HStack {
                Image(systemName: "info.circle")
                    .font(.title3)
                    .foregroundColor(.blue)
                Text("Info")
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.bottom)
    }
}

#Preview {
    InfoButton(infoMessage: "", homeVM: HomeViewModel())
}
