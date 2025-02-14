import Foundation
import UIKit

class ResourceManager {
    static let shared = ResourceManager()
    
    private init() {}
    
    func getPDFURL(named fileName: String) -> URL? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "pdf") {
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    
    func openPDF(named fileName: String) {
        if let pdfUrl = getPDFURL(named: fileName) {
            UIApplication.shared.open(pdfUrl)
        }
    }
}
