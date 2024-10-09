//
//  LocationPickerController.swift
//  LocationPickerController
//
//  Created by koogawa on 2016/05/01.
//  Copyright © 2016 koogawa. All rights reserved.
//

import UIKit
import MapKit

enum UIBarButtonHiddenItem: Int {
    case locate = 100
    func convert() -> UIBarButtonItem.SystemItem {
        return UIBarButtonItem.SystemItem(rawValue: self.rawValue)!
    }
}

extension UIBarButtonItem {
    convenience init(barButtonHiddenItem item:UIBarButtonHiddenItem, target: AnyObject?, action: Selector) {
        self.init(barButtonSystemItem: item.convert(), target:target, action: action)
    }
}

public typealias successClosure = (CLLocationCoordinate2D) -> Void
public typealias failureClosure = (NSError) -> Void

open class LocationPickerController: UIViewController {

    private var addressLabel : UILabel!

    fileprivate var mapView: MKMapView!
    fileprivate var imageView: UIImageView!

//    fileprivate var pointAnnotation: MKPointAnnotation!
    fileprivate var userTrackingButton: MKUserTrackingBarButtonItem!

    fileprivate let locationManager: CLLocationManager = CLLocationManager()

    fileprivate var success: successClosure?
    fileprivate var failure: failureClosure?

    fileprivate var isInitialized = false

    var oldLatitude : Double!
    var oldLongitude : Double!
    
    
    var addressTitleLabel : UILabel!
    
    var delegate : LocationDelegate!
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    convenience public init(success: @escaping successClosure, failure: failureClosure? = nil) {
        self.init()
        self.success = success
        self.failure = failure
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

//    override open func loadView() {
//        super.loadView()

//        self.mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))

        
//        if oldLatitude != nil && oldLongitude != nil{
//
//            let center = CLLocationCoordinate2D(latitude: oldLatitude, longitude: oldLongitude)
//            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//            mapView.setRegion(region, animated: true)
//
//        }
        
        
//        imageView = UIImageView()
//        imageView.image = UIImage(named: "annotation")
//        imageView.sizeToFit()
//        imageView.contentMode = .scaleAspectFit
//        self.view.addSubview(imageView)
//
//        imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        imageView.center = mapView.center
//        self.view.bringSubviewToFront(imageView)
        
//        self.pointAnnotation = MKPointAnnotation()
//        self.pointAnnotation.coordinate = center
//        self.mapView.addAnnotation(self.pointAnnotation)
        
//        }

    override open func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = .white
        
        self.locationManager.requestWhenInUseAuthorization()


        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
                
        
        let saveButton = UIButton()
        saveButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        saveButton.backgroundColor = Color.red
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        saveButton.addTarget(self, action: #selector(self.saveButtonAction), for: .touchUpInside)
        self.view.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.bottom.equalTo(self.view).inset(20)
        }
        
        saveButton.layer.cornerRadius = 5.0
        saveButton.clipsToBounds = true
        
        let lineView = UIView()
        lineView.backgroundColor = Color.liteGray
        self.view.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(1)
            make.bottom.equalTo(saveButton.snp.top).offset(-10)
        }
        
        
        
        addressLabel = UILabel()
        addressLabel.font = UIFont(name: "AvenirLTStd-Heavy", size: 16)
        addressLabel.numberOfLines = 0
        addressLabel.text = "-----"
        self.view.addSubview(addressLabel)
        
        addressLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(lineView.snp.top).offset(-5)
        }
        
        addressTitleLabel = UILabel()
        addressTitleLabel.font = UIFont.systemFont(ofSize: 10)
        addressTitleLabel.textColor = UIColor.lightGray
        addressTitleLabel.text = NSLocalizedString("Complete Address", comment: "")
        self.view.addSubview(addressTitleLabel)
        
        addressTitleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().offset(20)
            make.bottom.equalTo(addressLabel.snp.top).offset(-5)
        }

        
        self.mapView = MKMapView()
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(self.mapView)

        mapView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(addressTitleLabel.snp.top).offset(-5)
        }
        
        
        
        // Top view
        
        let topView = UIView()
        topView.backgroundColor = .white
        self.view.addSubview(topView)
        self.view.bringSubviewToFront(topView)

        topView.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(self.view).offset(50)

        }
        
        topView.layer.cornerRadius = 10.0
        topView.clipsToBounds = true
        
        let backImage : UIImage!
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            backImage = UIImage(named: "back-R")
                //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        }else{
            backImage = UIImage(named: "back")
                //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        }
        
        let backButton = UIButton()
        backButton.addTarget(self, action: #selector(self.backButtonAction), for: .touchUpInside)
        backButton.setImage(backImage, for: .normal)
        topView.addSubview(backButton)
        
        
        backButton.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(topView)
            make.width.equalTo(44)
        }
        
        
        let gpsImage = UIImage(named: "gps")
            //?.sd_resizedImage(with: CGSize(width: 40, height: 40), scaleMode: .aspectFit)
        let gpsButton = UIButton()
        gpsButton.addTarget(self, action: #selector(self.gpsButtonAction), for: .touchUpInside)
        gpsButton.setImage(gpsImage, for: .normal)
        topView.addSubview(gpsButton)
        
        
        gpsButton.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalTo(topView)
            make.width.equalTo(44)
        }
        
//        self.view.bringSubviewToFront(backButton)
        
        
        let locationLabel = UILabel()
        locationLabel.text  = NSLocalizedString("Search for location", comment: "")
        locationLabel.textColor = Color.gray
        locationLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        topView.addSubview(locationLabel)
        
        locationLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(topView)
            make.leading.equalTo(backButton.snp.trailing)
            make.trailing.equalTo(gpsButton.snp.leading)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.addressAction))
        locationLabel.addGestureRecognizer(tapGesture)
        locationLabel.isUserInteractionEnabled = true
        
        
        let markerImageView = UIImageView()
        markerImageView.image = UIImage(named: "location_3")
        markerImageView.contentMode = .scaleAspectFit
        self.view.addSubview(markerImageView)
        
        markerImageView.snp.makeConstraints { (make) in
            make.width.equalTo(30)
            make.center.equalTo(mapView)
        }
        
        
    }

    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func gpsButtonAction(){
        if let location = mapView.userLocation.location{
            mapView.setCenter(location.coordinate, animated: true)
        }
        var isGranted = false
        if CLLocationManager.locationServicesEnabled() {
            if #available(iOS 14.0, *) {
                switch locationManager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                    isGranted = false
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    isGranted = true
                @unknown default:
                    break
                }
            } else {
                // Fallback on earlier versions
            }
        } else {
            isGranted = false
        }
        
        if !isGranted{
            
            let alert = UIAlertController(title: "Permission", message: "Please grant location permissions in settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Open", style: .default, handler: { _ in
//                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                
                if let bundleId = Bundle.main.bundleIdentifier,
                    let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
                {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }

            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
        
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    open override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @objc func addressAction(){
        print("nav")
        let vc = LocationPicker()
        vc.locationDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

// MARK: - Internal methods

internal extension LocationPickerController {
    
    @objc func saveButtonAction() {
        
//        newLocationDelegate.locationSelected(mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude, addressLabel.text ?? "")
        
     delegate.newLocation(address: addressLabel.text ?? "", latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        self.navigationController?.popViewController(animated: true)
    }
    

    
    func updateAddress(_ latitude:Double, _ longitude:Double){
        
        
        var address: String = ""
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        //selectedLat and selectedLon are double values set by the app in a previous process
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            // Location name
            if let locationName = placeMark?.addressDictionary?["Name"] as? String {
                address += locationName + ", "
            }
            
            // Street address
            if let street = placeMark?.addressDictionary?["Thoroughfare"] as? String {
                address += street + ", "
            }
            
            // City
            if let city = placeMark?.addressDictionary?["City"] as? String {
                address += city + ", "
            }
            
            // Zip code
            if let zip = placeMark?.addressDictionary?["ZIP"] as? String {
                address += zip + ", "
            }
            
            // Country
            if let country = placeMark?.addressDictionary?["Country"] as? String {
                address += country
            }
            
            self.addressLabel.text = address
            
        })
        
        
    }
}

// MARK: - MKMapView delegate

extension LocationPickerController: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        guard self.isInitialized else {
            return
        }
//        self.pointAnnotation = MKPointAnnotation()

//        self.pointAnnotation.coordinate = mapView.region.center
        
        self.updateAddress(mapView.region.center.latitude, mapView.region.center.longitude)
        
    }
    
    
}


// MARK: - CLLocationManager delegate

extension LocationPickerController: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last, !self.isInitialized else {
            return
        }

        let centerCoordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        self.mapView.setRegion(region, animated: true)

//        self.pointAnnotation = MKPointAnnotation()
//        self.pointAnnotation.coordinate = newLocation.coordinate
//        self.mapView.addAnnotation(self.pointAnnotation)

        self.isInitialized = true
        
        self.updateAddress(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        if let location = mapView.userLocation.location{
//            mapView.setCenter(location.coordinate, animated: true)
//        }
//        var isGranted = false
//        if CLLocationManager.locationServicesEnabled() {
//            if #available(iOS 14.0, *) {
//                switch locationManager.authorizationStatus {
//                case .notDetermined, .restricted, .denied:
//                    print("No access")
//                    isGranted = false
//                case .authorizedAlways, .authorizedWhenInUse:
//                    print("Access")
//                    isGranted = true
//                @unknown default:
//                    break
//                }
//            } else {
//                // Fallback on earlier versions
//            }
//        } else {
//            isGranted = false
//        }
        
            
            let alert = UIAlertController(title: "Permission", message: "Please grant location permissions in settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Open", style: .default, handler: { _ in
//                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                if let bundleId = Bundle.main.bundleIdentifier,
                    let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
                {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)

        
        
    }
}

protocol CustomLocationDelegate {
    
    func locationSelected(_ latitude:Double, _ longitude:Double)
}

extension LocationPickerController : CustomLocationDelegate{
    
    func locationSelected(_ latitude: Double, _ longitude: Double) {
        print("latitude \(latitude) longitude \(longitude)")
        
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        updateAddress(latitude, longitude)
    }
    
}
