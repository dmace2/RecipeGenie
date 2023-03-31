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
                }.frame(maxWidth: .infinity).listRowBackground(Color.clear)
            }

            Section {
                CapabilityListView(withPadding: false)
            } header: {
                Label("Description", systemImage: "note.text")
                    .font(.headline).foregroundColor(.primary)
            }

            Section {
                Text("**NOTE**: These percentages are based a standard diet of 2000 calories per day. This may not match your needs as an individual and should not be taken as medical advice.").bold()
                Text("**NOTE**: These recipes are curated from a dataset collected by researchers at the Massachussetts Institute of Technology. No verification has been completed on the accuracy of the recipe ingredients, or of any nutrititional information associated with them. Incomplete recipes and inaccurate nutrition measurement may be present.").bold()
            } header: {
                Label("Disclaimers", systemImage: "exclamationmark.triangle")
                    .font(.headline).foregroundColor(.primary)
            }

            Section {
                TextSpacerTextView(label: "Created By", otherContent: "Dylan Mace")
                HStack {
                    Text("Dataset Credits").bold()
                    Spacer()
                    Link("MIT Research", destination: URL(string:"http://pic2recipe.csail.mit.edu/")!)
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
