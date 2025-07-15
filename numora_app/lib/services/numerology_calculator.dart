class NumerologyCalculator {
  /// Tính số đường đời (Life Path Number)
  static int calculateLifePath(DateTime birthDate) {
    int day = birthDate.day;
    int month = birthDate.month;
    int year = birthDate.year;

    // Cộng tất cả các chữ số
    int sum = _reduceToSingleDigit(day) + 
              _reduceToSingleDigit(month) + 
              _reduceToSingleDigit(year);

    return _reduceToSingleDigitOrMaster(sum);
  }

  /// Tính số linh hồn (Soul Number)
  static int calculateSoulNumber(String fullName) {
    const vowels = 'AEIOUĂÂÊÔƠƯYIY';
    int sum = 0;
    
    for (String char in fullName.toUpperCase().split('')) {
      if (vowels.contains(char)) {
        sum += _getLetterValue(char);
      }
    }
    
    return _reduceToSingleDigitOrMaster(sum);
  }

  /// Tính số sứ mệnh (Destiny Number)
  static int calculateDestinyNumber(String fullName) {
    int sum = 0;
    
    for (String char in fullName.toUpperCase().split('')) {
      if (char.contains(RegExp(r'[A-ZĂÂÊÔƠƯĐ]'))) {
        sum += _getLetterValue(char);
      }
    }
    
    return _reduceToSingleDigitOrMaster(sum);
  }

  /// Tính số nhân cách (Personality Number)
  static int calculatePersonalityNumber(String fullName) {
    const consonants = 'BCDFGHJKLMNPQRSTVWXZĐ';
    int sum = 0;
    
    for (String char in fullName.toUpperCase().split('')) {
      if (consonants.contains(char)) {
        sum += _getLetterValue(char);
      }
    }
    
    return _reduceToSingleDigitOrMaster(sum);
  }

  /// Tính ngày cá nhân (Personal Day)
  static int calculatePersonalDay(DateTime birthDate, DateTime targetDate) {
    int lifePath = calculateLifePath(birthDate);
    int day = targetDate.day;
    int month = targetDate.month;
    int year = targetDate.year;
    
    int sum = lifePath + _reduceToSingleDigit(day) + 
              _reduceToSingleDigit(month) + _reduceToSingleDigit(year);
              
    return _reduceToSingleDigit(sum);
  }

  /// Rút gọn thành số đơn hoặc số chủ (11, 22, 33)
  static int _reduceToSingleDigitOrMaster(int number) {
    while (number > 9) {
      // Giữ lại số chủ 11, 22, 33
      if (number == 11 || number == 22 || number == 33) {
        return number;
      }
      number = _reduceToSingleDigit(number);
    }
    return number;
  }

  /// Rút gọn thành số đơn
  static int _reduceToSingleDigit(int number) {
    while (number > 9) {
      int sum = 0;
      while (number > 0) {
        sum += number % 10;
        number ~/= 10;
      }
      number = sum;
    }
    return number;
  }

  /// Chuyển đổi chữ cái thành số
  static int _getLetterValue(String letter) {
    const letterValues = {
      'A': 1, 'Ă': 1, 'Â': 1, 'B': 2, 'C': 3, 'D': 4, 'Đ': 4,
      'E': 5, 'Ê': 5, 'F': 6, 'G': 7, 'H': 8, 'I': 9,
      'J': 1, 'K': 2, 'L': 3, 'M': 4, 'N': 5, 'O': 6, 'Ô': 6, 'Ơ': 6,
      'P': 7, 'Q': 8, 'R': 9, 'S': 1, 'T': 2, 'U': 3, 'Ư': 3,
      'V': 4, 'W': 5, 'X': 6, 'Y': 7, 'Z': 8
    };
    
    return letterValues[letter] ?? 0;
  }

  /// Lấy ý nghĩa cơ bản của số
  static String getNumberMeaning(int number) {
    switch (number) {
      case 1:
        return "Lãnh đạo, Độc lập, Khởi đầu";
      case 2:
        return "Hợp tác, Cân bằng, Nhạy cảm";
      case 3:
        return "Sáng tạo, Giao tiếp, Vui vẻ";
      case 4:
        return "Ổn định, Thực tế, Chăm chỉ";
      case 5:
        return "Tự do, Phiêu lưu, Linh hoạt";
      case 6:
        return "Yêu thương, Chăm sóc, Trách nhiệm";
      case 7:
        return "Tâm linh, Trí tuệ, Huyền bí";
      case 8:
        return "Thành công, Quyền lực, Vật chất";
      case 9:
        return "Nhân đạo, Hoàn thiện, Phục vụ";
      case 11:
        return "Trực giác, Cảm hứng, Thầy dạy tâm linh";
      case 22:
        return "Kiến trúc sư chủ, Tầm nhìn lớn, Thực hiện ước mơ";
      case 33:
        return "Thầy dạy chủ, Yêu thương vô điều kiện, Chữa lành";
      default:
        return "Số đặc biệt";
    }
  }
}
