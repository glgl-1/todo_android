class TrushTodo {
  final int mytodo_seq;
  final String? contents;
  final String? deletDate;

  TrushTodo(
    {
    required this.mytodo_seq,
    this.contents,
    this.deletDate,
  }
  );
  
TrushTodo.fromMap(Map<String, dynamic> res)
    : mytodo_seq = res['mytodo_seq'],
      contents = res['contents'],
      deletDate = res['deletDate'];
}

