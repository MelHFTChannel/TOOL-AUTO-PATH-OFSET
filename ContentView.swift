// FILE_UPDATE: ContentView.swift
// View chính hiển thị bộ chọn lịch và thông tin ngày âm/dương lịch.

import SwiftUI

struct ContentView: View {
    @State private var selectedDate: Date = Date() // Ngày hiện tại được chọn ban đầu

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Chọn Ngày Dương Lịch")) {
                    DatePicker(
                        "Ngày",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical) // Kiểu graphical hiện đại cho trải nghiệm người dùng tốt hơn
                }

                Section(header: Text("Thông Tin Ngày")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Dương Lịch:")
                            .font(.headline)
                        Text(formatDate(selectedDate, style: .long)) // Hiển thị ngày dương lịch đầy đủ

                        Divider()

                        Text("Âm Lịch:")
                            .font(.headline)
                        if let lunarDate = LunarDateConverter.shared.convertSolarToLunar(date: selectedDate) {
                            Text("Ngày \(lunarDate.day) tháng \(lunarDate.month)\(lunarDate.isLeapMonth ? " (nhuận)" : "") năm \(lunarDate.year) (Tháng \(lunarDate.canChiMonth), Năm \(lunarDate.canChiYear))")
                            Text("Ngày: \(lunarDate.canChiDay)")
                        } else {
                            Text("Không thể chuyển đổi ngày âm lịch.")
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Lịch Âm Dương")
        }
    }

    private func formatDate(_ date: Date, style: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "vi_VN") // Sử dụng local tiếng Việt để định dạng ngày
        return formatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}