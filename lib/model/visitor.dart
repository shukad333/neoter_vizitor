final String visitor_table = 'visitor';

class VisitorFields {
  static final List<String> values = [id, name, number, time];

  static final String id = "_id";
  static final String name = 'name';
  static final String number = 'number';
  static final String time = 'time';
}

class Visitor {
  final int? id;
  final String name;
  final String number;
  final DateTime time;

  const Visitor(
      {this.id, required this.name, required this.number, required this.time});

  Visitor copy({int? id, String? name, String? number, DateTime? time}) =>
      Visitor(
          id: id ?? this.id,
          number: number ?? this.number,
          name: name ?? this.name,
          time: time ?? this.time);

  static Visitor fromJson(Map<String, Object?> json) => Visitor(
        id: json[VisitorFields.id] as int?,
        name: json[VisitorFields.name] as String,
        number: json[VisitorFields.number] as String,
        time: DateTime.parse(json[VisitorFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        VisitorFields.id: id,
        VisitorFields.name: name,
        VisitorFields.number: number,
        VisitorFields.time: time.toIso8601String()
      };
}
