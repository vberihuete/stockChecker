//
//  DeviceDto.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 09/10/2023.
//

import Foundation

struct DeviceContainerDto: Codable {
    struct RegionDto: Codable {
        let uk: [DeviceDto]
        let us: [DeviceDto]
    }
    let region: RegionDto
}

struct DeviceDto: Codable {
    let id: String
    let name: String
    let color: String
    let capacity: String
}

extension DeviceDto {
    func toDomain() -> Device {
        .init(id: id, name: name, color: color, capacity: capacity)
    }
}


extension DeviceContainerDto.RegionDto {
    func toDomain() -> DeviceContainer.Region {
        .init(uk: uk.map { $0.toDomain() }, us: us.map { $0.toDomain() })
    }
}

extension DeviceContainerDto {
    func toDomain() -> DeviceContainer {
        .init(region: region.toDomain())
    }
}
