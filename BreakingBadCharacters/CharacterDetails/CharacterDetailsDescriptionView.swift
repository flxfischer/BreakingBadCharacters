//
//  CharacterDetailsDescriptionView.swift
//  BreakingBadCharacters
//
//  Created by Felix Fischer on 06/08/2021.
//

import SwiftUI

struct CharacterDetailsDescriptionView: View {
    let viewModel: CharacterDetailsViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Group {
                Text("Occupation:").font(.headline)
                Text(viewModel.occupationString)
                Spacer()
            }
            Group {
                Text("Status:").font(.headline)
                Text(viewModel.character.status)
                Spacer()
            }
            Group {
                Text("Nickname:").font(.headline)
                Text(viewModel.character.nickname)
                Spacer()
            }
            Group {
                Text("Season appearance:").font(.headline)
                Text(viewModel.appearanceString)
                Spacer()
            }
        }
        .padding()
        .background(Color("backgroundWhite"))
    }
}

struct CharacterDetailsDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        let c = Character(char_id: 0, name: "Name", occupation: ["Occ1", "Occ2"], img: "img", status: "Status", nickname: "Nickname", appearance: [1,2,3])
        let vm = CharacterDetailsViewModel(character: c)
        CharacterDetailsDescriptionView(viewModel: vm)
    }
}
