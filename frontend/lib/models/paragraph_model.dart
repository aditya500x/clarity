/// Sensory Safe Reader data model
class ParagraphResult {
  final String? title;
  final String originalText;
  final String simplifiedText;
  final List<String>? keyPoints;
  
  ParagraphResult({
    this.title,
    required this.originalText,
    required this.simplifiedText,
    this.keyPoints,
  });
  
  factory ParagraphResult.fromJson(Map<String, dynamic> json) {
    return ParagraphResult(
      title: json['title'],
      originalText: json['original_text'] ?? json['input_data'] ?? '',
      simplifiedText: json['simplified_text'] ?? json['output_text'] ?? '',
      keyPoints: (json['key_points'] as List<dynamic>?)
          ?.map((point) => point.toString())
          .toList(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'original_text': originalText,
      'simplified_text': simplifiedText,
      'key_points': keyPoints,
    };
  }
}
