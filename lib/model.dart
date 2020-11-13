class Chapter {
  String chapterNo;
  String title;
  String ebook;
  int items;
  List<Lecture> lecture;
  Chapter({this.chapterNo, this.title,this.ebook,this.items,this.lecture});
}

class Lecture {
  int id;
  String lectureId;
  String content;
  String title;
  String file;
  String description;
  Lecture({this.id, this.lectureId,this.content,this.title,this.file,this.description});
}
