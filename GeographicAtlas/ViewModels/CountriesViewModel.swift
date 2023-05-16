//
//  CountriesViewModel.swift
//  GeographicAtlas
//
//  Created by Жаслан Танербергенов on 14.05.2023.
//

import Foundation
import UserNotifications

class CountriesViewModel: ObservableObject {
    @Published var items: [Country] = []
    @Published var country: Country?
    
    func fetchCountries(completion: @escaping () -> Void) {
        let url = URL(string: "https://restcountries.com/v3.1/all")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                do {
                    let decodedItems = try JSONDecoder().decode([Country].self, from: data)
                    DispatchQueue.main.async {
                        self.items = decodedItems
                        completion()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    private func parseCountryData(data: Data, completion: @escaping () -> Void) {
        do {
            let decodedItems = try JSONDecoder().decode([Country].self, from: data)
            DispatchQueue.main.async {
                self.items = decodedItems
                completion()
            }
        } catch {
            print(error)
        }
    }
    func fetchCountry(by countryCode: String) async -> Country? {
        do {
            let urlString = "https://restcountries.com/v3.1/alpha/"
            let url = URL(string: urlString + countryCode)!
            let (data, _) = try await URLSession.shared.data(from: url)
            let allCountry: [Country] = try JSONDecoder().decode(Array<Country>.self, from: data)
            if !allCountry.isEmpty {
                return allCountry.first
            }
        } catch {
        }
        return nil
        
    }
    
    func selectCountry(countryCode: String) {
        Task {
            if let country = await fetchCountry(by: countryCode) {
                dump(country)
            }
        }
    }
    func scheduleNotification(with country: Country) {
        let content = UNMutableNotificationContent()
        let randomIndex = Int.random(in: 0..<items.count)
        let randomCountry = items[randomIndex]
        
        content.title = "\(randomCountry.name.official)"
        content.body = "Страна: \(randomCountry.name.common), Столица: \(country.capital?.joined(separator: ", ") ?? "N/A"), Население: \(randomCountry.population.formatted())"
        
        let requestIdentifier = "NotificationIdentifier"
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Ошибка при добавлении уведомления: \(error.localizedDescription)")
                } else {
                    print("Уведомление успешно запланировано")
                }
            }
        }
    }
    
    
    func setupNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Ошибка при запросе разрешения на отправку уведомлений: \(error.localizedDescription)")
            } else if granted {
                print("Разрешение на отправку уведомлений получено")
            } else {
                print("Пользователь не дал разрешение на отправку уведомлений")
            }
        }
    }
    init() {
        setupNotificationPermissions()
    }
}

