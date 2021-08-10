//
//  CardView.swift
//  SetGame
//
//  Created by David Inga on 8/9/21.
//

import SwiftUI

struct CardView: View {
    let uniqueShape: String
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 10.0)
        ZStack {
            shape.foregroundColor(.blue)
            Text(uniqueShape)
        }
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(uniqueShape: "Description")
    }
}
