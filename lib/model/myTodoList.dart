class Mytodolist {
  final int? seq;
  final String? contents;
  final String? checkBox;
  final String? insertDate;
  final String? deletDate;
  final String? finishDate;

  Mytodolist({
    this.seq,
    this.contents,
    this.checkBox,
    this.insertDate,
    this.deletDate,
    this.finishDate,
  });

  Mytodolist.fromMap(Map<String, dynamic> res)
  :seq = res['seq'],
  contents = res['contents'],
  checkBox = res['checkBox'],
  insertDate = res['insertDate'],
  deletDate = res['deletDate'],
  finishDate = res['finishDate'];
}
