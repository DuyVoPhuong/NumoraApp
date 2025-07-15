import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  static const String _apiKey = 'YOUR_OPENAI_API_KEY'; // Thay bằng API key thực

  /// Tạo diễn giải AI cho kết quả thần số học
  static Future<String> generateInterpretation({
    required int lifePathNumber,
    required int soulNumber,
    required int destinyNumber,
    required int personalityNumber,
    required DateTime birthDate,
  }) async {
    try {
      final prompt = _buildPrompt(
        lifePathNumber: lifePathNumber,
        soulNumber: soulNumber,
        destinyNumber: destinyNumber,
        personalityNumber: personalityNumber,
        birthDate: birthDate,
      );

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content': 'Bạn là một chuyên gia thần số học giàu kinh nghiệm, có khả năng phân tích tính cách và vận mệnh qua các con số. Hãy viết theo văn phong nhẹ nhàng, truyền cảm hứng và tích cực.'
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'max_tokens': 1000,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('Lỗi API: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback với diễn giải mặc định
      return _getDefaultInterpretation(
        lifePathNumber: lifePathNumber,
        soulNumber: soulNumber,
        destinyNumber: destinyNumber,
        personalityNumber: personalityNumber,
      );
    }
  }

  /// Tạo prompt cho AI
  static String _buildPrompt({
    required int lifePathNumber,
    required int soulNumber,
    required int destinyNumber,
    required int personalityNumber,
    required DateTime birthDate,
  }) {
    return '''
Phân tích tính cách và vận mệnh cho người có:
- Số Đường Đời: $lifePathNumber
- Số Linh Hồn: $soulNumber  
- Số Sứ Mệnh: $destinyNumber
- Số Nhân Cách: $personalityNumber
- Ngày sinh: ${birthDate.day}/${birthDate.month}/${birthDate.year}

Hãy viết một bài phân tích chi tiết (khoảng 300-400 từ) bao gồm:

1. **Tính cách tổng quan**: Mô tả những đặc điểm chính của tính cách
2. **Điểm mạnh**: Những tài năng và ưu điểm nổi bật
3. **Thách thức**: Những khó khăn có thể gặp phải và cách khắc phục
4. **Hướng phát triển**: Lời khuyên để phát huy tối đa tiềm năng
5. **Tình yêu & Mối quan hệ**: Cách tiếp cận trong các mối quan hệ
6. **Sự nghiệp**: Những lĩnh vực phù hợp để phát triển

Viết theo văn phong:
- Nhẹ nhàng, ấm áp và truyền cảm hứng
- Tích cực, tập trung vào tiềm năng thay vì hạn chế
- Dễ hiểu, gần gũi với người Việt
- Có tính thực tiễn, đưa ra lời khuyên cụ thể

Bắt đầu bằng: "Chào bạn! Qua những con số thần bí trong ngày sinh của bạn..."
''';
  }

  /// Diễn giải mặc định khi không có AI
  static String _getDefaultInterpretation({
    required int lifePathNumber,
    required int soulNumber,
    required int destinyNumber,
    required int personalityNumber,
  }) {
    return '''
Chào bạn! Qua những con số thần bí trong ngày sinh của bạn, tôi thấy bạn là một người đặc biệt với những tiềm năng tuyệt vời.

🌟 **Tính cách tổng quan**
Với số đường đời $lifePathNumber, bạn mang trong mình năng lượng ${_getEnergyDescription(lifePathNumber)}. Số linh hồn $soulNumber cho thấy bạn có khao khát sâu sắc về ${_getSoulDesire(soulNumber)}.

💪 **Điểm mạnh của bạn**
Số sứ mệnh $destinyNumber thể hiện bạn được sinh ra để ${_getDestinyPurpose(destinyNumber)}. Đây là tài năng tự nhiên mà bạn nên phát huy.

🎯 **Hướng phát triển**
Hãy tập trung vào việc ${_getDevelopmentAdvice(lifePathNumber)} để phát huy tối đa tiềm năng của mình.

💝 **Tình yêu & Mối quan hệ**
Trong các mối quan hệ, bạn thường ${_getRelationshipStyle(personalityNumber)}. Hãy học cách cân bằng giữa nhu cầu cá nhân và mong muốn của người khác.

🚀 **Sự nghiệp**
Những lĩnh vực phù hợp với bạn: ${_getCareerSuggestions(destinyNumber)}

Hãy tin tướng vào bản thân và bước đi với niềm tin! Những con số này chỉ là hướng dẫn, quyết định cuối cùng vẫn nằm trong tay bạn. 🌈
''';
  }

  static String _getEnergyDescription(int number) {
    switch (number) {
      case 1: return "của người lãnh đạo, độc lập và tiên phong";
      case 2: return "của người hòa giải, nhạy cảm và hợp tác";
      case 3: return "của người sáng tạo, vui vẻ và giao tiếp giỏi";
      case 4: return "của người thực tế, ổn định và chăm chỉ";
      case 5: return "của người tự do, phiêu lưu và linh hoạt";
      case 6: return "của người yêu thương, chăm sóc và có trách nhiệm";
      case 7: return "của người tâm linh, trí tuệ và thích khám phá";
      case 8: return "của người thành đạt, quyết đoán và tham vọng";
      case 9: return "của người nhân đạo, rộng lượng và phục vụ";
      case 11: return "của người có trực giác mạnh và khả năng truyền cảm hứng";
      case 22: return "của kiến trúc sư chủ với tầm nhìn lớn";
      case 33: return "của thầy dạy chủ với tình yêu vô điều kiện";
      default: return "độc đáo và đặc biệt";
    }
  }

  static String _getSoulDesire(int number) {
    switch (number) {
      case 1: return "sự độc lập và lãnh đạo";
      case 2: return "sự hòa hợp và kết nối";
      case 3: return "sự sáng tạo và biểu đạt";
      case 4: return "sự ổn định và trật tự";
      case 5: return "sự tự do và khám phá";
      case 6: return "việc chăm sóc và yêu thương";
      case 7: return "sự hiểu biết sâu sắc và tâm linh";
      case 8: return "sự thành công và quyền lực";
      case 9: return "việc phục vụ nhân loại";
      default: return "những điều cao cả và ý nghĩa";
    }
  }

  static String _getDestinyPurpose(int number) {
    switch (number) {
      case 1: return "dẫn dắt và khởi đầu những điều mới mẻ";
      case 2: return "hòa giải và tạo ra sự cân bằng";
      case 3: return "truyền cảm hứng qua sự sáng tạo";
      case 4: return "xây dựng nền tảng vững chắc";
      case 5: return "khám phá và mang lại sự đổi mới";
      case 6: return "chăm sóc và nuôi dưỡng";
      case 7: return "tìm kiếm và chia sẻ tri thức";
      case 8: return "đạt được thành công vật chất";
      case 9: return "phục vụ và giúp đỡ mọi người";
      default: return "thực hiện sứ mệnh đặc biệt";
    }
  }

  static String _getDevelopmentAdvice(int number) {
    switch (number) {
      case 1: return "phát triển kỹ năng lãnh đạo và tự tin hơn";
      case 2: return "học cách hợp tác và lắng nghe";
      case 3: return "phát huy khả năng sáng tạo và giao tiếp";
      case 4: return "xây dựng kỷ luật và kiên nhẫn";
      case 5: return "mở rộng tầm nhìn và trải nghiệm";
      case 6: return "cân bằng giữa cho đi và nhận lại";
      case 7: return "phát triển trực giác và tĩnh tâm";
      case 8: return "học cách quản lý và đầu tư";
      case 9: return "mở rộng lòng bao dung";
      default: return "phát triển những tài năng độc đáo";
    }
  }

  static String _getRelationshipStyle(int number) {
    switch (number) {
      case 1: return "thích độc lập nhưng cũng rất trung thành";
      case 2: return "quan tâm sâu sắc và luôn muốn hòa thuận";
      case 3: return "mang lại niềm vui và sự sáng tạo";
      case 4: return "đáng tin cậy và cam kết lâu dài";
      case 5: return "cần không gian tự do và đa dạng";
      case 6: return "yêu thương sâu sắc và chăm sóc tận tụy";
      case 7: return "cần thời gian một mình để suy ngẫm";
      case 8: return "tham vong và muốn có địa vị";
      case 9: return "rộng lượng và hiểu biết";
      default: return "có cách yêu độc đáo riêng";
    }
  }

  static String _getCareerSuggestions(int number) {
    switch (number) {
      case 1: return "kinh doanh, lãnh đạo, khởi nghiệp";
      case 2: return "tư vấn, hòa giải, dịch vụ khách hàng";
      case 3: return "nghệ thuật, truyền thông, giải trí";
      case 4: return "kế toán, xây dựng, quản lý";
      case 5: return "du lịch, bán hàng, marketing";
      case 6: return "giáo dục, y tế, dịch vụ xã hội";
      case 7: return "nghiên cứu, tâm linh, công nghệ";
      case 8: return "tài chính, bất động sản, quản lý";
      case 9: return "từ thiện, luật, tổ chức phi lợi nhuận";
      default: return "các lĩnh vực đặc biệt và sáng tạo";
    }
  }
}
