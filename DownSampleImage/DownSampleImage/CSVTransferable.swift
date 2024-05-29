//
//  CSVTransferable.swift
//  DownSampleImage
//
//  Created by 김태윤 on 12/14/23.
//

import Foundation
import CoreTransferable
struct Archive {
    var supportsCSV: Bool = false
    func csvData() -> Data{
        Data()
    }
    init(csvData: Data){
        let data = csvData
    }
}


extension Archive: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(contentType: .commaSeparatedText) { archive in
            archive.csvData()
        } importing: { data in Archive(csvData: data) }
            .exportingCondition { archive in archive.supportsCSV }
    }
}
