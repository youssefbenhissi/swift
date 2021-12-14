//
//  map.swift
//  mini projet sim
//
//  Created by youssef benhissi on 10/01/2021.
//

import SwiftUI
import MapKit
struct map: View {
    var body: some View {
        mapView()
    }
}

struct map_Previews: PreviewProvider {
    static var previews: some View {
        map()
    }
}
struct mapView : UIViewRepresentable  {
    func makeCoordinator() -> mapView.Coordinator {
        return mapView.Coordinator()
    }
    
    func makeUIView(context: UIViewRepresentableContext<mapView>) -> MKMapView {
        let map = MKMapView()
        let sourceCoordinate = CLLocationCoordinate2D(latitude: 13.086, longitude: 80.2707)
        let destinationCoordinate = CLLocationCoordinate2D(latitude: 12.9830, longitude: 80.25994)
        let sourcePin = MKPointAnnotation()
        sourcePin.coordinate = sourceCoordinate
        sourcePin.title = "Source"
        map.addAnnotation(sourcePin)
        
        let destinationPin = MKPointAnnotation()
        destinationPin.coordinate = destinationCoordinate
        destinationPin.title = "Destination"
        map.addAnnotation(destinationPin)
        
        let region = MKCoordinateRegion(center: sourceCoordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        map.region = region
        map.delegate = context.coordinator
        let req =  MKDirections.Request()
        req.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinate))
        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        
        let directions = MKDirections(request: req)
        
        directions.calculate{ (direct, err) in
            if err != nil {
                print((err?.localizedDescription))
            }//Users/youssef/Desktop/mini projet sim backup/mini projet sim/ViewRestaurant/map.swift
            let polyliene = direct?.routes.first?.polyline
            map.addOverlay(polyliene!)
            map.setRegion(MKCoordinateRegion(polyliene!.boundingMapRect), animated: true)
        }
        return map
    }
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<mapView>) {
        
    }
    class Coordinator : NSObject,MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let render = MKPolylineRenderer(overlay: overlay)
            render.strokeColor  = .orange
            render.lineWidth = 4
            return render
        }
    }
    
    
}
