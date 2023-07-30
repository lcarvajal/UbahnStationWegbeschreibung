//
//  ContentView.swift
//  UbahnStationWegbeschreibung
//
//  Created by Lukas Carvajal on 7/29/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingSheet = false
    @StateObject var locationViewModel = CoreLocationViewModel()
    
    var body: some View {
        switch locationViewModel.authorizationStatus {
        case .notDetermined:
            AnyView(RequestLocationView())
                .environmentObject(locationViewModel)
        case .restricted:
            ErrorView(errorText: "Location use is restricted.")
        case .denied:
            ErrorView(errorText: "The app does not have location permissions. Please enable them in settings.")
        default:
            VStack {
                Button {
                    showingSheet.toggle()
                    
                } label: {
                    Image("Map")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.top)
                }
                .sheet(isPresented: $showingSheet) {
                    BeaconView()
                    
                }
            }
            .preferredColorScheme(.light)
        }
    }
}

struct BeaconView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var beaconViewModel = BeaconViewModel()
    
    var body: some View {
            VStack {
                Spacer()
                Image("Sunglasses")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .padding()
                Text("Station \(beaconViewModel.beacon.station)")
                    .font(.title2)
                    .padding(10)
                Text(beaconViewModel.beacon.description)
                    .font(.body)
                    .padding(20)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Dismiss")
                    .frame(maxWidth: .infinity)
                    .padding(15)
                }
                .background(Color(red: 0.906, green: 0.154, blue: 0.189))
                .foregroundStyle(.white)
                .clipShape(Capsule())
                Spacer()
            }
            .padding(20)
            .background(.white)
            .foregroundColor(.black)
            .onAppear {
                //                locationViewModel.locateBeacon()
                beaconViewModel.getBeacon(uuid: UUID(uuidString: "F9DF84FC-1145-4D0B-9AC7-F2FAD5EFF690")!)
            }
    }
}

struct RequestLocationView: View {
    @EnvironmentObject var locationViewModel: CoreLocationViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "location.circle")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            Button(action: {
                locationViewModel.requestPermission()
            }, label: {
                Label("Allow tracking", systemImage: "location")
            })
            .padding(10)
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Text("We need your permission to track you.")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}

struct ErrorView: View {
    var errorText: String
    
    var body: some View {
        VStack {
            Image(systemName: "xmark.octagon")
                    .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Text(errorText)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
