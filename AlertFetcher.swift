//
//  AlertFetcher.swift
//  cisco
//
//  Created by suma Ambadipudi on 29/06/25.
//
import Foundation
func loadAlerts() {
    let simulatedAlerts = [
        AlertItem(message: "🔥 Fire detected in Zone A", severity: "high", timestamp: formattedNow()),
        AlertItem(message: "🧯 Smoke sensor triggered near Exit 3", severity: "medium", timestamp: formattedNow(-300)),
        AlertItem(message: "🚷 Unauthorized access to restricted area", severity: "high", timestamp: formattedNow(-600)),
        AlertItem(message: "📉 Vibration level exceeds threshold on North Stage", severity: "medium", timestamp: formattedNow(-900)),
        AlertItem(message: "👥 Crowd density critical in Sector C", severity: "high", timestamp: formattedNow(-1200)),
        AlertItem(message: "🌡️ Elevated temperature near generator room", severity: "medium", timestamp: formattedNow(-1500)),
        AlertItem(message: "🧪 Gas leak detected in Chemical Storage", severity: "high", timestamp: formattedNow(-1800))
    ]

    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        //self.alerts = simulatedAlerts
    }
}

func formattedNow(_ offset: Int = 0) -> String {
    let date = Date().addingTimeInterval(TimeInterval(offset))
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter.string(from: date)
}

struct AlertItem: Identifiable {
    let id = UUID()
    let message: String
    let severity: String
    let timestamp: String
}

struct CiscoAPIResponse: Codable {
    let alerts: [CiscoAlert]
}

struct CiscoAlert: Codable {
    let message: String
    let severity: String
    let timestamp: String
}

class AlertFetcher: ObservableObject {
    @Published var alerts: [AlertItem] = []

    func loadAlerts() {
        // ⚠️ Replace this mock with your real Cisco API call
        // Example for now:
        let exampleAlerts = [
            AlertItem(message: "Air quality critical", severity: "high", timestamp: Date().formatted()),
            AlertItem(message: "High temperature detected", severity: "medium", timestamp: Date().formatted()),
            AlertItem(message: "Crowd density elevated", severity: "low", timestamp: Date().formatted())
        ]

        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.alerts = exampleAlerts
        }
    }

    // For future: use this to call the real Cisco API
    func loadFromAPI() {
        guard let url = URL(string: "https://your-cisco-api-endpoint.com/api/alerts") else { return }

        var request = URLRequest(url: url)
        request.setValue("Bearer YOUR_API_KEY_HERE", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(CiscoAPIResponse.self, from: data)
                let fetchedAlerts = decoded.alerts.map {
                    AlertItem(message: $0.message, severity: $0.severity, timestamp: $0.timestamp)
                }
                DispatchQueue.main.async {
                    self.alerts = fetchedAlerts
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
}

