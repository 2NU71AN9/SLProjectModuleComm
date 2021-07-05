//
//  FGMapChooseAddressViewController.swift
//  FBMerchant
//
//  Created by Kevin on 2019/7/1.
//  Copyright © 2019 cn. All rights reserved.
//

import UIKit
import RxSwift
import SLIKit
import AMapSearchKit

public extension AMapPOI {
    var addressDesc: String {
        city + district + address + name
    }
    var addressDetailDesc: String {
        if province == city { return addressDesc }
        return province + addressDesc
    }
}

public class FGMapChooseAddressViewController: UIViewController {
    
    public var selAddressCallback: ((AMapPOI) -> Void)?
    
    private lazy var headView: FGChoosCitySearchView = {
        let view = FGChoosCitySearchView.loadView()
        view.chooseCityCallback = { [weak self] in
            self?.chooseCityAction()
        }
        view.chooseAddressCallback = { [weak self] in
            self?.chooseAddressCallback()
        }
        view.cancelCallback = { [weak self] in
            self?.dissmiss()
        }
        return view
    }()
    private lazy var mapView: MAMapView = {
        let mapView = MAMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }()
    private lazy var bottomView: FGChooseAddressBgView = {
        let view = FGChooseAddressBgView.loadView()
        view.selAddressCallback = { [weak self] (poi) in
            self?.selAddressCallback?(poi)
            self?.dissmiss()
        }
        return view
    }()
    
    /// POI搜索
    private lazy var search: AMapSearchAPI? = {
        let search = AMapSearchAPI()
        search?.delegate = self
        return search
    }()
    ///
    private lazy var aroundRequest: AMapPOIAroundSearchRequest = {
        let request = AMapPOIAroundSearchRequest()
        request.requireExtension = true
//        request.city = city
        request.sortrule = 0
        request.requireExtension = true
        return request
    }()
    
    private lazy var reGeocodRequest: AMapReGeocodeSearchRequest = {
        let request = AMapReGeocodeSearchRequest()
        request.requireExtension = true
        return request
    }()
    
    /// 打点
    private let pointAnnotation = MAPointAnnotation()
    
    private var location: CLLocation? {
        didSet {
            mapView.removeAnnotation(pointAnnotation)
            moveMap()
            makePoint()
            
            if let coordinate = location?.coordinate {
                reGeocodRequest.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
                reGoecodeSearch()
            }
        }
    }
    
    /// 逆地理编码后的
    private var reGeocode: AMapReGeocode? {
        didSet {
            headView.city = reGeocode?.addressComponent.city
            pois = reGeocode?.pois ?? []
        }
    }
    
    private var pois: [AMapPOI] = [] {
        didSet {
            bottomView.pois = pois
        }
    }
    
    private var firstLocation = true
    private let bag = DisposeBag()
    
    init(complete: @escaping (AMapPOI) -> Void) {
        super.init(nibName: nil, bundle: nil)
        selAddressCallback = complete
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - life circle
extension FGMapChooseAddressViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.addSubview(mapView)
        view.addSubview(headView)
        view.addSubview(bottomView)
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        headView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
    }
}

// MARK: - MAMapViewDelegate
extension FGMapChooseAddressViewController: MAMapViewDelegate {
    public func mapView(_ mapView: MAMapView!, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
        bottomView.curPoi = nil
        location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    public func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            annotationView?.image = UIImage(named: "locationPoint")
            annotationView?.centerOffset = CGPoint(x: 0, y: -18)
            return annotationView!
        }
        return nil
    }
    public func mapView(_ mapView: MAMapView!, mapWillMoveByUser wasUserAction: Bool) {
        if wasUserAction { bottomView.tableViewShowPart() }
    }
    public func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        
    }
    public func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        if firstLocation {
            bottomView.curPoi = nil
            location = mapView.userLocation.location
            firstLocation = false
        }
    }
}
// MARK: - AMapSearchDelegate
extension FGMapChooseAddressViewController: AMapSearchDelegate {
    public func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        pois = response.pois
    }
    public func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        reGeocode = response.regeocode
    }
}

extension FGMapChooseAddressViewController {
    
    @objc private func dissmiss() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func chooseCityAction() {
//        let vc = SLCitySelectorViewController()
//        vc.selectCitySubject.subscribe(onNext: { [weak self] (city) in
//            self?.city = city
//            self?.poiKeywordsSearch()
//        }).disposed(by: bag)
//        let navi = UINavigationController(rootViewController: vc)
//        present(navi, animated: true, completion: nil)
    }
    
    /// 搜索
    private func chooseAddressCallback() {
        let vc = FGSearchAddressViewController(reGeocode?.addressComponent.city ?? "")
        vc.selectPoiCallback = { [weak self] (poi) in
            self?.bottomView.curPoi = poi
            self?.location = CLLocation(latitude: CLLocationDegrees(poi.location.latitude), longitude: CLLocationDegrees(poi.location.longitude))
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 打点
    private func makePoint() {
        if let latitude = location?.coordinate.latitude,
            let longitude = location?.coordinate.longitude {
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            mapView.addAnnotation(pointAnnotation)
        }
    }
    
    /// 逆地理编码查询
    private func reGoecodeSearch() {
        search?.aMapReGoecodeSearch(reGeocodRequest)
    }
    
    /// 移动地图
    private func moveMap() {
        if let coordinate = location?.coordinate {
            if mapView.zoomLevel <= 15 {
                mapView.setZoomLevel(17, animated: true)
            }
            let center = CLLocationCoordinate2D(latitude: coordinate.latitude - (mapView.zoomLevel <= 17 ? 0.001 : 0.0003), longitude: coordinate.longitude)
            mapView.setCenter(center, animated: true)
            
            let region = MACoordinateRegion(center: center, span: MACoordinateSpan(latitudeDelta: 0, longitudeDelta: 0))
            mapView.setRegion(region, animated: true)
        }
    }
}
