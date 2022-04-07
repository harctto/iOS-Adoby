//
//  SearchViewController.swift
//  Adopby
//
//  Created by Hatto on 7/4/2565 BE.
//

import UIKit
import MapKit
import Alamofire

class SearchViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    fileprivate var locationManager: CLLocationManager?
    
    func fetchData() {
        //pet shops
        guard let pet_url = URL(string: "https://adoby.glitch.me/petshops") else { return }
        AF.request(pet_url,method: .get)
            .responseDecodable(of: [PetShop].self)
        { response in
            response.value?.forEach { data in
                let mapAnno = PetShopLocation(
                    title: data.shopName,
                    address: data.address,
                    shop_tel: data.shopTel,
                    coordinate: CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
                )
                self.map.addAnnotation(mapAnno)
            }
        }
        //pet hospitals
        guard let hospitals_url = URL(string: "https://adoby.glitch.me/hospitals") else { return }
        AF.request(hospitals_url,method: .get)
            .responseDecodable(of: [Hospital].self)
        { response in
            response.value?.forEach { data in
                let mapAnno = HospitalLocation(
                    title: data.hospitalName,
                    address: data.address,
                    hospital_tel: data.hospitalTel,
                    coordinate: CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
                )
                self.map.addAnnotation(mapAnno)
            }
        }
    }
    
    func getLocation () {
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
        fetchData()
        map.delegate = self
        map.centerCoordinate = CLLocationCoordinate2D(
            latitude: (locationManager?.location?.coordinate.latitude) ?? 0,
            longitude: (locationManager?.location?.coordinate.longitude) ?? 0
        )
        map.setCameraZoomRange(
            MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 100000),
            animated: true
        )
        map.showsUserLocation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }
}

class PetShopLocation: NSObject, MKAnnotation {
    let title: String?
    let address: String?
    let shop_tel: String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        title: String?,
        address: String?,
        shop_tel: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.address = address
        self.shop_tel = shop_tel
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return address
    }
}

class HospitalLocation: NSObject, MKAnnotation {
    let title: String?
    let address: String?
    let hospital_tel: String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        title: String?,
        address: String?,
        hospital_tel: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.address = address
        self.hospital_tel = hospital_tel
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return address
    }
}

extension SearchViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotation = annotation
        let identifier = "mapAnno"
        var view: MKMarkerAnnotationView
        //
        view = MKMarkerAnnotationView(
            annotation: annotation,
            reuseIdentifier: identifier
        )
        switch annotation {
        case is PetShopLocation:
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.markerTintColor = UIColor.init(rgb: 0x7E6514)
            view.glyphImage = UIImage.init(systemName: "pawprint.circle.fill")
        case is HospitalLocation:
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.markerTintColor = UIColor.init(rgb: 0xB80F0A)
            view.glyphImage = UIImage.init(systemName: "cross.circle.fill")
        case is MKUserLocation:
            view.markerTintColor = UIColor.init(rgb: 0xF7D154)
            view.glyphImage = UIImage.init(systemName: "person.circle.fill")
        default:
            break
        }
        return view
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view)
    }
}
