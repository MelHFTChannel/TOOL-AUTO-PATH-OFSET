// FILE_UPDATE: LunarDateConverter.swift
// File này chứa logic chuyển đổi ngày dương lịch sang ngày âm lịch và tính toán Can Chi.
// LƯU Ý QUAN TRỌNG: Phần chuyển đổi ngày/tháng/năm âm lịch trong ví dụ này chỉ là MỘT PHIÊN BẢN ĐƠN GIẢN HÓA (PLACEHOLDER).
// Việc tính toán lịch âm chính xác đòi hỏi các thuật toán thiên văn phức tạp hoặc bảng tra cứu rộng lớn,
// tính đến các pha trăng mới, điểm chí, và các quy tắc cụ thể cho tháng nhuận, điều này vượt quá phạm vi
// một bản demo đơn giản. Phần tính toán Can Chi được thực hiện một cách xác định hơn dựa trên một mốc thời gian đã biết.

import Foundation

struct LunarDate {
    let day: Int
    let month: Int
    let year: Int
    let isLeapMonth: Bool // Cho biết liệu tháng có phải là tháng nhuận hay không

    let canChiDay: String // Can Chi của ngày
    let canChiMonth: String // Can Chi của tháng (theo tháng âm lịch, nhưng ở đây được suy ra từ tháng dương lịch đơn giản)
    let canChiYear: String // Can Chi của năm (theo năm âm lịch, nhưng ở đây được suy ra từ năm dương lịch)
}

class LunarDateConverter {
    static let shared = LunarDateConverter()

    private init() {}

    // MARK: - Core Conversion

    func convertSolarToLunar(date: Date) -> LunarDate? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        guard let solarYear = components.year,
              let solarMonth = components.month,
              let solarDay = components.day else {
            return nil
        }

        // --- PHIÊN BẢN ĐƠN GIẢN HÓA (PLACEHOLDER) CHO NGÀY/THÁNG/NĂM ÂM LỊCH ---
        // Việc chuyển đổi lịch âm thực sự liên quan đến các tính toán thiên văn phức tạp (pha trăng mới, điểm chí).
        // Đối với bản demo này, chúng ta sử dụng một logic cực kỳ đơn giản để hiển thị cấu trúc.
        // CÁC GIÁ TRỊ NÀY KHÔNG CHÍNH XÁC VỀ THIÊN VĂN đối với ngày, tháng, năm, hoặc việc phát hiện tháng nhuận.
        // Đối với một ứng dụng thực tế, hãy tích hợp một thư viện hoặc thuật toán lịch âm mạnh mẽ.

        // Ví dụ: Một "offset" rất đơn giản để làm cho nó khác biệt so với dương lịch.
        // Điều này hoàn toàn mang tính minh họa và không dựa trên bất kỳ sự thật thiên văn nào.
        let simplifiedLunarDay = (solarDay + 1) % 30 == 0 ? 30 : (solarDay + 1) % 30
        let simplifiedLunarMonth = (solarMonth + 1) % 12 == 0 ? 12 : (solarMonth + 1) % 12
        let simplifiedLunarYear = solarYear // Năm âm lịch thường khác, nhưng đơn giản hóa cho demo
        let simplifiedIsLeapMonth = simplifiedLunarMonth == 3 && simplifiedLunarDay % 7 == 0 // Điều kiện tùy ý cho demo

        // --- TÍNH TOÁN CAN CHI (Xác định hơn dựa trên ngày dương lịch cho demo này) ---
        // Phần này là một phép tính trực tiếp hơn dựa trên kỷ nguyên Gregorian.

        let canChiDay = calculateCanChiDay(solarYear: solarYear, solarMonth: solarMonth, solarDay: solarDay)
        let canChiMonth = calculateCanChiMonth(solarMonth: solarMonth, solarDay: solarDay, solarYear: solarYear)
        let canChiYear = calculateCanChiYear(solarYear: solarYear)

        return LunarDate(
            day: simplifiedLunarDay,
            month: simplifiedLunarMonth,
            year: simplifiedLunarYear,
            isLeapMonth: simplifiedIsLeapMonth,
            canChiDay: canChiDay,
            canChiMonth: canChiMonth,
            canChiYear: canChiYear
        )
    }

    // MARK: - Hàm hỗ trợ Can Chi
    // Các hàm này cung cấp một phép tính xác định cho Can Chi dựa trên ngày dương lịch.
    // Chúng tương đối chính xác cho mục đích này, giả sử một kỷ nguyên nhất quán.

    private let thienCan = ["Giáp", "Ất", "Bính", "Đinh", "Mậu", "Kỷ", "Canh", "Tân", "Nhâm", "Quý"]
    private let diaChi = ["Tý", "Sửu", "Dần", "Mão", "Thìn", "Tỵ", "Ngọ", "Mùi", "Thân", "Dậu", "Tuất", "Hợi"]

    // Tính toán Can Chi của NĂM
    // Dựa trên năm dương lịch, tương đối với một kỷ nguyên đã biết (ví dụ: năm 4 là Giáp Tý, 1984 là Giáp Tý)
    private func calculateCanChiYear(solarYear: Int) -> String {
        // Điều chỉnh cho một kỷ nguyên đã biết. Để đơn giản, giả sử 1984 (Giáp Tý) là một tham chiếu tốt.
        // (1984 - 4) % 60 = 0. Vì vậy (năm - 4) % 10 và (năm - 4) % 12 cho ra chỉ số.
        let canIndex = (solarYear - 4) % 10 // Thiên Can
        let chiIndex = (solarYear - 4) % 12 // Địa Chi

        // Đảm bảo các chỉ số không âm
        let finalCanIndex = (canIndex + 10) % 10
        let finalChiIndex = (chiIndex + 12) % 12
        
        return "\(thienCan[finalCanIndex]) \(diaChi[finalChiIndex])"
    }

    // Tính toán Can Chi của THÁNG
    // Điều này thường phụ thuộc vào tháng âm lịch, nhưng để đơn giản, chúng ta ánh xạ nó vào các tháng dương lịch.
    // Đây là một sự đơn giản hóa; tính toán chính xác thường phụ thuộc vào khởi đầu của năm âm lịch và các 'tiết khí' cụ thể.
    private func calculateCanChiMonth(solarMonth: Int, solarDay: Int, solarYear: Int) -> String {
        // Đây là một ánh xạ đơn giản dựa trên tháng dương lịch.
        // Một phép tính chính xác thực sự sẽ phụ thuộc vào Can Chi của năm âm lịch và "Tiết Khí".
        // Ví dụ: 5 tháng 1 - 4 tháng 2 là Dần, 5 tháng 2 - 4 tháng 3 là Mão, v.v.
        // Điều này được đơn giản hóa cao độ cho mục đích demo.
        // Chúng ta sẽ sử dụng một ánh xạ nơi tháng đầu tiên của năm âm lịch (Dần) khớp lỏng lẻo với tháng 2 dương lịch.
        
        let lunarMonthIndexOffset: Int
        switch solarMonth {
        case 1: lunarMonthIndexOffset = 11 // Tý (tháng cuối của năm trước)
        case 2: lunarMonthIndexOffset = 0  // Sửu (khởi đầu năm âm lịch mới)
        case 3: lunarMonthIndexOffset = 1  // Dần
        case 4: lunarMonthIndexOffset = 2  // Mão
        case 5: lunarMonthIndexOffset = 3  // Thìn
        case 6: lunarMonthIndexOffset = 4  // Tỵ
        case 7: lunarMonthIndexOffset = 5  // Ngọ
        case 8: lunarMonthIndexOffset = 6  // Mùi
        case 9: lunarMonthIndexOffset = 7  // Thân
        case 10: lunarMonthIndexOffset = 8 // Dậu
        case 11: lunarMonthIndexOffset = 9 // Tuất
        case 12: lunarMonthIndexOffset = 10 // Hợi
        default: lunarMonthIndexOffset = 0 // Không nên xảy ra
        }
        
        // Thiên Can của tháng phụ thuộc vào Thiên Can của năm và Địa Chi của tháng.
        // Đơn giản hóa: Giả sử một điểm khởi đầu cố định cho chu kỳ Can Chi tháng,
        // thay đổi theo Can của năm. Đối với demo, chúng ta sẽ tạo một ánh xạ cơ bản.
        // (Can năm - 0 đối với Giáp/Kỷ bắt đầu bằng Bính Dần; 1 đối với Ất/Canh bắt đầu bằng Mậu Dần, v.v.)
        
        let yearCanIndex = (solarYear - 4) % 10 // Lấy chỉ số Thiên Can của năm
        let startCanForMonth: Int // Thiên Can khởi đầu cho tháng Dần (tháng âm lịch 1)
        
        switch yearCanIndex {
        case 0, 5: startCanForMonth = 2 // Giáp, Kỷ => Bính Dần
        case 1, 6: startCanForMonth = 4 // Ất, Canh => Mậu Dần
        case 2, 7: startCanForMonth = 6 // Bính, Tân => Canh Dần
        case 3, 8: startCanForMonth = 8 // Đinh, Nhâm => Nhâm Dần
        case 4, 9: startCanForMonth = 0 // Mậu, Quý => Giáp Dần
        default: startCanForMonth = 0 // Dự phòng
        }
        
        // Địa Chi cho tháng (đơn giản hóa, giả sử ánh xạ tháng dương lịch)
        let chiOfMonthIndex = (lunarMonthIndexOffset + 2) % 12 // Dần là Địa Chi thứ 3 (chỉ số 2)
        
        // Thiên Can cho tháng
        let canOfMonthIndex = (startCanForMonth + chiOfMonthIndex - 2 + 10) % 10 // -2 vì Dần có chiIndex là 2
        
        return "\(thienCan[canOfMonthIndex]) \(diaChi[chiOfMonthIndex])"
    }

    // Tính toán Can Chi của NGÀY
    // Đây là phần phức tạp nhất vì nó yêu cầu đếm số ngày từ một kỷ nguyên cố định.
    // Đối với bản demo này, chúng ta sử dụng một phép gần đúng dựa trên 1/1/1900 (Ất Sửu) làm điểm tham chiếu.
    
    private func calculateCanChiDay(solarYear: Int, solarMonth: Int, solarDay: Int) -> String {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = solarYear
        dateComponents.month = solarMonth
        dateComponents.day = solarDay
        
        guard let currentDate = calendar.date(from: dateComponents) else { return "N/A" }
        
        var referenceComponents = DateComponents()
        referenceComponents.year = 1900
        referenceComponents.month = 1
        referenceComponents.day = 1
        
        guard let referenceDate = calendar.date(from: referenceComponents) else { return "N/A" }
        
        let daysSinceReference = calendar.dateComponents([.day], from: referenceDate, to: currentDate).day ?? 0
        
        // 1900-01-01 là ngày Ất Sửu, là chỉ số 1 trong chu kỳ Can Chi (Giáp Tý là 0).
        let canChiCycleIndex = (1 + daysSinceReference % 60 + 60) % 60
        
        let canIndex = canChiCycleIndex % 10
        let chiIndex = canChiCycleIndex % 12
        
        return "\(thienCan[canIndex]) \(diaChi[chiIndex])"
    }
}