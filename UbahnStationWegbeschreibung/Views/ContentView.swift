//
//  ContentView.swift
//  UbahnStationWegbeschreibung
//
//  Created by Lukas Carvajal on 7/29/23.
//

import SwiftUI

struct ContentView: View {
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
        case .authorizedAlways, .authorizedWhenInUse:
            BeaconView()
        default:
            Text("Unexpected status")
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

struct BeaconView: View {
    @StateObject var beaconViewModel = BeaconViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("Sunglasses")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .padding(75)
                Text("Station \(beaconViewModel.beacon.station)")
                    .font(.title2)
                Text(beaconViewModel.beacon.description)
                    .font(.body)
                    .padding()
                    .lineSpacing(10)
                Spacer()
            }
            .onAppear {
                //                locationViewModel.locateBeacon()
                beaconViewModel.getBeacon(uuid: UUID(uuidString: "F9DF84FC-1145-4D0B-9AC7-F2FAD5EFF690")!)
            }
            .navigationTitle(Text("Orientation"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconView()
    }
}
