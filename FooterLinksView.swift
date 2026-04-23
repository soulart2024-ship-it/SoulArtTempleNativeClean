import SwiftUI

struct FooterLinksView: View {
    let privacyURL: URL
    let medicalURL: URL
    let termsURL: URL
    let bookingsURL: URL

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Links")
                .font(.headline)
            

            VStack(alignment: .leading, spacing: 6) {
                
                Link("Privacy Policy", destination: privacyURL)
                    .font(.footnote)
                    .foregroundStyle(Theme.textPrimary)
                
                Link("Medical Disclaimer", destination: medicalURL)
                    .font(.footnote)
                    .foregroundStyle(Theme.textPrimary)
                
                Link("Terms & Conditions", destination: termsURL)
                    .font(.footnote)
                    .foregroundStyle(Theme.textPrimary)
                
                Link("Bookings / Contact", destination: bookingsURL)
                    .font(.footnote)
                    .foregroundStyle(Theme.textPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading) // ✅ FORCE LEFT ALIGN
            .font(.footnote)
            .foregroundStyle(Theme.textPrimary)
        }
    }
}
