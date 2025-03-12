//
//  CourseName.swift
//  ParPals
//
//  Created by Nick Deda on 11/9/24.
//

import Foundation
import Swift
import SwiftUI
import MapKit

/// This extension of CourseName gives each course a String name, an Image, and a label some view
/// Used to represent the courses in SelectCourseView
extension CourseName {
    var courseName: String {
        switch self {
        case .castleBay: return "Castle Bay"
        case .wilmingtonMunicipal: return "Wilmington Municipal"
        case .ironclad: return "Ironclad"
        case .beauRivage: return "Beau Rivage"
        }
    }
    
    var courseImageSource: ImageResource {
        switch self {
        case .castleBay: return .castleBay
        case .wilmingtonMunicipal: return .wilmingtonMunicipal
        case .ironclad: return .ironclad
        case .beauRivage: return .beau
        }
    }
    
    var label: some View {
        VStack {
            Image(courseImageSource)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .cornerRadius(15)
                .clipped()
            Text(courseName)
                .font(.footnote)
                .foregroundColor(Color.black)
        }
    }
    var teeBox: [DemoHole] {
        switch self {
            case .castleBay: [
            DemoHole(id: 1, coordinate: CLLocationCoordinate2D(latitude: 34.4037, longitude: -77.70385)),
            DemoHole(id: 2, coordinate: CLLocationCoordinate2D(latitude: 34.40739, longitude: -77.69927)),
            DemoHole(id: 3, coordinate: CLLocationCoordinate2D(latitude: 34.40996, longitude: -77.70271)),
            DemoHole(id: 4, coordinate: CLLocationCoordinate2D(latitude: 34.40933, longitude: -77.70486)),
            DemoHole(id: 5, coordinate: CLLocationCoordinate2D(latitude: 34.40613, longitude: -77.70904)),
            DemoHole(id: 6, coordinate: CLLocationCoordinate2D(latitude: 34.40802, longitude: -77.70965)),
            DemoHole(id: 7, coordinate: CLLocationCoordinate2D(latitude: 34.4037, longitude: -77.71084)),
            DemoHole(id: 8, coordinate: CLLocationCoordinate2D(latitude: 34.40498, longitude: -77.70515)),
            DemoHole(id: 9, coordinate: CLLocationCoordinate2D(latitude: 34.4052, longitude: -77.70164)),
            DemoHole(id: 10, coordinate: CLLocationCoordinate2D(latitude: 34.40312, longitude: -77.70355)),
            DemoHole(id: 11, coordinate: CLLocationCoordinate2D(latitude: 34.40282, longitude: -77.69786)),
            DemoHole(id: 12, coordinate: CLLocationCoordinate2D(latitude: 34.4006, longitude: -77.69709)),
            DemoHole(id: 13, coordinate: CLLocationCoordinate2D(latitude: 34.39876, longitude: -77.69836)),
            DemoHole(id: 14, coordinate: CLLocationCoordinate2D(latitude: 34.39715, longitude: -77.70204)),
            DemoHole(id: 15, coordinate: CLLocationCoordinate2D(latitude: 34.39778, longitude: -77.70732)),
            DemoHole(id: 16, coordinate: CLLocationCoordinate2D(latitude: 34.39649, longitude: -77.70972)),
            DemoHole(id: 17, coordinate: CLLocationCoordinate2D(latitude: 34.39944, longitude: -77.7102)),
            DemoHole(id: 18, coordinate: CLLocationCoordinate2D(latitude: 34.40189, longitude: -77.70519))

        ]
        case .wilmingtonMunicipal: [
            DemoHole(id: 1, coordinate: CLLocationCoordinate2D(latitude: 34.20662, longitude: -77.87623)),
                DemoHole(id: 2, coordinate: CLLocationCoordinate2D(latitude: 34.20352, longitude: -77.8746)),
                DemoHole(id: 3, coordinate: CLLocationCoordinate2D(latitude: 34.20659, longitude: -77.8779)),
                DemoHole(id: 4, coordinate: CLLocationCoordinate2D(latitude: 34.20427, longitude: -77.88084)),
                DemoHole(id: 5, coordinate: CLLocationCoordinate2D(latitude: 34.20349, longitude: -77.87925)),
                DemoHole(id: 6, coordinate: CLLocationCoordinate2D(latitude: 34.20092, longitude: -77.8768)),
                DemoHole(id: 7, coordinate: CLLocationCoordinate2D(latitude: 34.20319, longitude: -77.87256)),
                DemoHole(id: 8, coordinate: CLLocationCoordinate2D(latitude: 34.20485, longitude: -77.87101)),
                DemoHole(id: 9, coordinate: CLLocationCoordinate2D(latitude: 34.2056, longitude: -77.87179)),
                DemoHole(id: 10, coordinate: CLLocationCoordinate2D(latitude: 34.2071, longitude: -77.87569)),
                DemoHole(id: 11, coordinate: CLLocationCoordinate2D(latitude: 34.20454, longitude: -77.8728)),
                DemoHole(id: 12, coordinate: CLLocationCoordinate2D(latitude: 34.2032, longitude: -77.87474)),
                DemoHole(id: 13, coordinate: CLLocationCoordinate2D(latitude: 34.20521, longitude: -77.87823)),
                DemoHole(id: 14, coordinate: CLLocationCoordinate2D(latitude: 34.20218, longitude: -77.87648)),
                DemoHole(id: 15, coordinate: CLLocationCoordinate2D(latitude: 34.20379, longitude: -77.87876)),
                DemoHole(id: 16, coordinate: CLLocationCoordinate2D(latitude: 34.20178, longitude: -77.87636)),
                DemoHole(id: 17, coordinate: CLLocationCoordinate2D(latitude: 34.20293, longitude: -77.87353)),
                DemoHole(id: 18, coordinate: CLLocationCoordinate2D(latitude: 34.20532, longitude: -77.87211))

        ]
        case .ironclad: [
            DemoHole(id: 1, coordinate: CLLocationCoordinate2D(latitude: 34.395019, longitude: -77.6505563)), DemoHole(id: 2, coordinate: CLLocationCoordinate2D(latitude: 34.3939294, longitude: -77.6463679)), DemoHole(id: 3, coordinate: CLLocationCoordinate2D(latitude: 34.3899666, longitude: -77.6444972)), DemoHole(id: 4, coordinate: CLLocationCoordinate2D(latitude: 34.3884498, longitude: -77.6429169)), DemoHole(id: 5, coordinate: CLLocationCoordinate2D(latitude: 34.385729, longitude: -77.64001)), DemoHole(id: 6, coordinate: CLLocationCoordinate2D(latitude: 34.3841486, longitude: -77.6431755)), DemoHole(id: 7, coordinate: CLLocationCoordinate2D(latitude: 34.3873605, longitude: -77.6456504)), DemoHole(id: 8, coordinate: CLLocationCoordinate2D(latitude: 34.3883321, longitude: -77.6477867)), DemoHole(id: 9, coordinate: CLLocationCoordinate2D(latitude: 34.3919952, longitude: -77.6496867)), DemoHole(id: 10, coordinate: CLLocationCoordinate2D(latitude: 34.3971267, longitude: -77.6508447)), DemoHole(id: 11, coordinate: CLLocationCoordinate2D(latitude: 34.3999412, longitude: -77.6519543)), DemoHole(id: 12, coordinate: CLLocationCoordinate2D(latitude: 34.4012326, longitude: -77.6523451)), DemoHole(id: 13, coordinate: CLLocationCoordinate2D(latitude: 34.4039086, longitude: -77.6549095)), DemoHole(id: 14, coordinate: CLLocationCoordinate2D(latitude: 34.4045808, longitude: -77.6598991)), DemoHole(id: 15, coordinate: CLLocationCoordinate2D(latitude: 34.4036038, longitude: -77.6615344)), DemoHole(id: 16, coordinate: CLLocationCoordinate2D(latitude: 34.4017941, longitude: -77.6588317)), DemoHole(id: 17, coordinate: CLLocationCoordinate2D(latitude: 34.399681, longitude: -77.6547285)), DemoHole(id: 18, coordinate: CLLocationCoordinate2D(latitude: 34.3986415, longitude: -77.6559285))
        ]
        case .beauRivage: [
            DemoHole(id: 1, coordinate: CLLocationCoordinate2D(latitude: 34.1145596, longitude: -77.9076991)),
            DemoHole(id: 2, coordinate: CLLocationCoordinate2D(latitude: 34.1155489, longitude: -77.9124882)),
            DemoHole(id: 3, coordinate: CLLocationCoordinate2D(latitude: 34.1215653, longitude: -77.9151552)),
            DemoHole(id: 4, coordinate: CLLocationCoordinate2D(latitude: 34.1181394, longitude: -77.921291)),
            DemoHole(id: 5, coordinate: CLLocationCoordinate2D(latitude: 34.1167648, longitude: -77.9187265)),
            DemoHole(id: 6, coordinate: CLLocationCoordinate2D(latitude: 34.1159746, longitude: -77.9166325)),
            DemoHole(id: 7, coordinate: CLLocationCoordinate2D(latitude: 34.1161282, longitude: -77.9203922)),
            DemoHole(id: 8, coordinate: CLLocationCoordinate2D(latitude: 34.113245, longitude: -77.918467)),
            DemoHole(id: 9, coordinate: CLLocationCoordinate2D(latitude: 34.1143172, longitude: -77.9133998)),
            DemoHole(id: 10, coordinate: CLLocationCoordinate2D(latitude: 34.1176816, longitude: -77.9058876)),
            DemoHole(id: 11, coordinate: CLLocationCoordinate2D(latitude: 34.1209092, longitude: -77.9062557)),
            DemoHole(id: 12, coordinate: CLLocationCoordinate2D(latitude: 34.1232718, longitude: -77.9072314)),
            DemoHole(id: 13, coordinate: CLLocationCoordinate2D(latitude: 34.1195139, longitude: -77.9079761)),
            DemoHole(id: 14, coordinate: CLLocationCoordinate2D(latitude: 34.1207529, longitude: -77.9117499)),
            DemoHole(id: 15, coordinate: CLLocationCoordinate2D(latitude: 34.1223337, longitude: -77.9132179)),
            DemoHole(id: 16, coordinate: CLLocationCoordinate2D(latitude: 34.1201835, longitude: -77.9140454)),
            DemoHole(id: 17, coordinate: CLLocationCoordinate2D(latitude: 34.1181127, longitude: -77.9145826)),
            DemoHole(id: 18, coordinate: CLLocationCoordinate2D(latitude: 34.1173831, longitude: -77.9102255))

        ]
        }
    }
    var holes: [DemoHole] {
        switch self {
            
        case .castleBay: [
            DemoHole(id: 1, coordinate: CLLocationCoordinate2D(latitude: 34.40495, longitude: -77.70083)),
            DemoHole(id: 2, coordinate: CLLocationCoordinate2D(latitude: 34.40935, longitude: -77.70168)),
            DemoHole(id: 3, coordinate: CLLocationCoordinate2D(latitude: 34.40923, longitude: -77.70399)),
            DemoHole(id: 4, coordinate: CLLocationCoordinate2D(latitude: 34.40588, longitude: -77.7084)),
            DemoHole(id: 5, coordinate: CLLocationCoordinate2D(latitude: 34.40743, longitude: -77.70859)),
            DemoHole(id: 6, coordinate: CLLocationCoordinate2D(latitude: 34.40588, longitude: -77.71156)),
            DemoHole(id: 7, coordinate: CLLocationCoordinate2D(latitude: 34.40402, longitude: -77.70703)),
            DemoHole(id: 8, coordinate: CLLocationCoordinate2D(latitude: 34.40636, longitude: -77.70105)),
            DemoHole(id: 9, coordinate: CLLocationCoordinate2D(latitude: 34.40392, longitude: -77.70451)),
            DemoHole(id: 10, coordinate: CLLocationCoordinate2D(latitude: 34.40427, longitude: -77.70051)),
            DemoHole(id: 11, coordinate: CLLocationCoordinate2D(latitude: 34.4015, longitude: -77.69441)),
            DemoHole(id: 12, coordinate: CLLocationCoordinate2D(latitude: 34.39947, longitude: -77.69661)),
            DemoHole(id: 13, coordinate: CLLocationCoordinate2D(latitude: 34.39755, longitude: -77.70099)),
            DemoHole(id: 14, coordinate: CLLocationCoordinate2D(latitude: 34.39736, longitude: -77.7068)),
            DemoHole(id: 15, coordinate: CLLocationCoordinate2D(latitude: 34.39659, longitude: -77.70924)),
            DemoHole(id: 16, coordinate: CLLocationCoordinate2D(latitude: 34.39795, longitude: -77.7099)),
            DemoHole(id: 17, coordinate: CLLocationCoordinate2D(latitude: 34.39953, longitude: -77.70624)),
            DemoHole(id: 18, coordinate: CLLocationCoordinate2D(latitude: 34.40357, longitude: -77.7056))
            ]
        case .wilmingtonMunicipal: [
            DemoHole(id: 1, coordinate: CLLocationCoordinate2D(latitude: 34.20391, longitude: -77.8739)),
            DemoHole(id: 2, coordinate: CLLocationCoordinate2D(latitude: 34.2064, longitude: -77.87762)),
            DemoHole(id: 3, coordinate: CLLocationCoordinate2D(latitude: 34.20454, longitude: -77.88074)),
            DemoHole(id: 4, coordinate: CLLocationCoordinate2D(latitude: 34.20372, longitude: -77.87928)),
            DemoHole(id: 5, coordinate: CLLocationCoordinate2D(latitude: 34.20096, longitude: -77.87739)),
            DemoHole(id: 6, coordinate: CLLocationCoordinate2D(latitude: 34.20232, longitude: -77.87415)),
            DemoHole(id: 7, coordinate: CLLocationCoordinate2D(latitude: 34.20446, longitude: -77.87081)),
            DemoHole(id: 8, coordinate: CLLocationCoordinate2D(latitude: 34.20585, longitude: -77.87154)),
            DemoHole(id: 9, coordinate: CLLocationCoordinate2D(latitude: 34.208, longitude: -77.87535)),
            DemoHole(id: 10, coordinate: CLLocationCoordinate2D(latitude: 34.20479, longitude: -77.87306)),
            DemoHole(id: 11, coordinate: CLLocationCoordinate2D(latitude: 34.20345, longitude: -77.87365)),
            DemoHole(id: 12, coordinate: CLLocationCoordinate2D(latitude: 34.20577, longitude: -77.87796)),
            DemoHole(id: 13, coordinate: CLLocationCoordinate2D(latitude: 34.20248, longitude: -77.876212)),
            DemoHole(id: 14, coordinate: CLLocationCoordinate2D(latitude: 34.20435, longitude: -77.8787)),
            DemoHole(id: 15, coordinate: CLLocationCoordinate2D(latitude: 34.20148, longitude: -77.87728)),
            DemoHole(id: 16, coordinate: CLLocationCoordinate2D(latitude: 34.20297, longitude: -77.87489)),
            DemoHole(id: 17, coordinate: CLLocationCoordinate2D(latitude: 34.20511, longitude: -77.87172)),
            DemoHole(id: 18, coordinate: CLLocationCoordinate2D(latitude: 34.20739, longitude: -77.87534))
            ]
        case .ironclad: [
            DemoHole(id: 1, coordinate: CLLocationCoordinate2D(latitude: 34.395019, longitude: -77.6505563)),
            DemoHole(id: 2, coordinate: CLLocationCoordinate2D(latitude: 34.3939294, longitude: -77.6463679)),
            DemoHole(id: 3, coordinate: CLLocationCoordinate2D(latitude: 34.3899666, longitude: -77.6444972)),
            DemoHole(id: 4, coordinate: CLLocationCoordinate2D(latitude: 34.3884498, longitude: -77.6429169)),
            DemoHole(id: 5, coordinate: CLLocationCoordinate2D(latitude: 34.385729, longitude: -77.64001)),
            DemoHole(id: 6, coordinate: CLLocationCoordinate2D(latitude: 34.3841486, longitude: -77.6431755)),
            DemoHole(id: 7, coordinate: CLLocationCoordinate2D(latitude: 34.3873605, longitude: -77.6456504)),
            DemoHole(id: 8, coordinate: CLLocationCoordinate2D(latitude: 34.3883321, longitude: -77.6477867)),
            DemoHole(id: 9, coordinate: CLLocationCoordinate2D(latitude: 34.3919952, longitude: -77.6496867)),
            DemoHole(id: 10, coordinate: CLLocationCoordinate2D(latitude: 34.3971267, longitude: -77.6508447)),
            DemoHole(id: 11, coordinate: CLLocationCoordinate2D(latitude: 34.3999412, longitude: -77.6519543)),
            DemoHole(id: 12, coordinate: CLLocationCoordinate2D(latitude: 34.4012326, longitude: -77.6523451)),
            DemoHole(id: 13, coordinate: CLLocationCoordinate2D(latitude: 34.4039086, longitude: -77.6549095)),
            DemoHole(id: 14, coordinate: CLLocationCoordinate2D(latitude: 34.4045808, longitude: -77.6598991)),
            DemoHole(id: 15, coordinate: CLLocationCoordinate2D(latitude: 34.4036038, longitude: -77.6615344)),
            DemoHole(id: 16, coordinate: CLLocationCoordinate2D(latitude: 34.4017941, longitude: -77.6588317)),
            DemoHole(id: 17, coordinate: CLLocationCoordinate2D(latitude: 34.399681, longitude: -77.6547285)),
            DemoHole(id: 18, coordinate: CLLocationCoordinate2D(latitude: 34.3986415, longitude: -77.6559285))
        ]
        case .beauRivage: [
            DemoHole(id: 1, coordinate: CLLocationCoordinate2D(latitude: 34.11579, longitude: -77.91036)),
            DemoHole(id: 2, coordinate: CLLocationCoordinate2D(latitude: 34.11782, longitude: -77.91527)),
            DemoHole(id: 3, coordinate: CLLocationCoordinate2D(latitude: 34.12227, longitude: -77.91747)),
            DemoHole(id: 4, coordinate: CLLocationCoordinate2D(latitude: 34.11691, longitude: -77.92078)),
            DemoHole(id: 5, coordinate: CLLocationCoordinate2D(latitude: 34.11712, longitude: -77.91735)),
            DemoHole(id: 6, coordinate: CLLocationCoordinate2D(latitude: 34.11565, longitude: -77.91984)),
            DemoHole(id: 7, coordinate: CLLocationCoordinate2D(latitude: 34.11397, longitude: -77.91975)),
            DemoHole(id: 8, coordinate: CLLocationCoordinate2D(latitude: 34.11447, longitude: -77.91470)),
            DemoHole(id: 9, coordinate: CLLocationCoordinate2D(latitude: 34.11338, longitude: -77.90865)),
            DemoHole(id: 10, coordinate: CLLocationCoordinate2D(latitude: 34.12014, longitude: -77.90537)),
            DemoHole(id: 11, coordinate: CLLocationCoordinate2D(latitude: 34.12354, longitude: -77.90501)),
            DemoHole(id: 12, coordinate: CLLocationCoordinate2D(latitude: 34.12181, longitude: -77.90695)),
            DemoHole(id: 13, coordinate: CLLocationCoordinate2D(latitude: 34.11892, longitude: -77.91063)),
            DemoHole(id: 14, coordinate: CLLocationCoordinate2D(latitude: 34.12307, longitude: -77.91216)),
            DemoHole(id: 15, coordinate: CLLocationCoordinate2D(latitude: 34.12174, longitude: -77.91442)),
            DemoHole(id: 16, coordinate: CLLocationCoordinate2D(latitude: 34.11803, longitude: -77.91234)),
            DemoHole(id: 17, coordinate: CLLocationCoordinate2D(latitude: 34.11626, longitude: -77.91214)),
            DemoHole(id: 18, coordinate: CLLocationCoordinate2D(latitude: 34.11567, longitude: -77.90613))
            ]
        }
    }
    
    var region: MapCameraPosition {
        switch self {
            
        case .castleBay:

            MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.40419, longitude: -77.70344), span: MKCoordinateSpan(latitudeDelta: 0.024, longitudeDelta: 0.024)))
        case .wilmingtonMunicipal:
            MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.20526,  longitude: -77.87536), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
        case .ironclad:
            MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.39576, longitude: -77.65075), span: MKCoordinateSpan(latitudeDelta: 0.026, longitudeDelta: 0.026)))
        case .beauRivage:
            MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.11581, longitude: -77.90778), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
        }
    }
}
