import SwiftUI
import PDFKit

// PDFViewer for Sponsorship
struct SponsorPDFViewer: UIViewRepresentable {
    let pdfDoc: PDFDocument
    
    init(showing pdfDoc: PDFDocument) {
        self.pdfDoc = pdfDoc
    }
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDoc
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDoc
    }
}

// PDF Viewer Sheet for Sponsorship
struct SponsorPDFViewerSheet: View {
    @Environment(\.presentationMode) var presentationMode
    let pdfName: String
    
    var body: some View {
        NavigationView {
            if let pdfDoc = loadPDF() {
                SponsorPDFViewer(showing: pdfDoc)
                    .navigationBarTitle("Sponsorship Packet", displayMode: .inline)
                    .navigationBarItems(trailing: Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    })
            } else {
                Text("Unable to load PDF")
                    .foregroundColor(.red)
            }
        }
    }
    
    private func loadPDF() -> PDFDocument? {
        if let url = ResourceManager.shared.getPDFURL(named: pdfName) {
            return PDFDocument(url: url)
        }
        return nil
    }
}
