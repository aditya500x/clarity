/// Sensory Safe Reader data model
class ParagraphResult {
  final String originalText;
  final String simplifiedText;
  final List<String>? keyPoints;
  
  ParagraphResult({
    required this.originalText,
    required this.simplifiedText,
    this.keyPoints,
  });
  
  factory ParagraphResult.fromJson(Map<String, dynamic> json) {
    return ParagraphResult(
      originalText: json['original_text'] ?? json['input_data'] ?? '',
      simplifiedText: json['simplified_text'] ?? '',
      keyPoints: (json['key_points'] as List<dynamic>?)
          ?.map((point) => point.toString())
          .toList(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'original_text': originalText,
      'simplified_text': simplifiedText,
      'key_points': keyPoints,
    };
  }
}
