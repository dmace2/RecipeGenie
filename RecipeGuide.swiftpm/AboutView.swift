//
//  AboutView.swift
//  Recipe Genie
//
//  Created by Dylan Mace on 3/31/23.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            Section {
                VStack {
                    Image(systemName: "fork.knife").resizable().scaledToFit()
                        .frame(height: 150)
                    Text("RecipeGenie").font(.largeTitle.weight(.heavy))
                }.frame(maxWidth: .infinity)
            }

            Section {
                CapabilityListView(withPadding: false)
            } header: {
                Label("Description", systemImage: "note.text")
                    .font(.headline).foregroundColor(.primary)
            }

            Section {
                TextSpacerTextView(label: "Created By", otherContent: "Dylan Mace")
                HStack {
                    Text("Dataset Credits").bold()
                    Spacer()
                    Link("Massachusetts Institute of Technology", destination: URL(string:"http://pic2recipe.csail.mit.edu/")!)
                }
            } header: {
                Label("Credits", systemImage: "megaphone.fill")
                    .font(.headline).foregroundColor(.primary)
            }

            Section {
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    TextSpacerTextView(label: "Version Number", otherContent: version)
                }
            }
        }
        .navigationTitle("About")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
