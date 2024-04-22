//
//  ManualListViewModel.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/11/24.
//

import Foundation
import PDFKit

final class ManualListViewModel {
    func checkPdf(_ searchWord: String) -> Bool {
        let fileName: String = Preferences.selectedUserType?.rawValue ?? ""
        
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "pdf"),  let document = PDFDocument(url: fileURL) else { return false }
            
        let searchSelections = document.findString(searchWord, withOptions: .caseInsensitive)
        
        return searchSelections.isNotEmpty
    }
}
