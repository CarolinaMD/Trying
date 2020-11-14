import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'model.dart';
import 'text_load_layout.dart';

class ChapterPage extends StatelessWidget {
  ChapterPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final ValueNotifier<int> searchIndex = ValueNotifier<int>(-1);
  final ScrollController _scrollController = ScrollController();

  String markdownSearch(String text, String substr) {
    return text.replaceAllMapped(new RegExp('($substr)', caseSensitive: false),
        (Match m) => "^^${m[1]}^^");
  }

  Widget sectionWidget(BuildContext context, Section section) {
    return Card(
      margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
      color: Theme.of(context).accentColor,
      child: ExpansionTile(
          backgroundColor: Theme.of(context).accentColor,
          leading: Icon(Icons.question_answer_rounded),
          title: Container(
              child: Text(
            section.title,
            style: Theme.of(context).accentTextTheme.subtitle1,
          )),
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 2, 10, 10),
              child: MarkdownBody(data: section.fullText),
              color: Theme.of(context).canvasColor,
            )
          ]),
    );
  }

  Widget buildMainView(BuildContext context, Chapter chapter) {
    List<Widget> widgets = [];
    if (chapter.description != null) {
      widgets.add(Container(
          color: Theme.of(context).canvasColor,
          padding: EdgeInsets.fromLTRB(10, 15, 0, 10),
          child: MarkdownBody(data: chapter.description)));
    }

    List<Widget> sections = chapter.sections
        .map<Widget>((section) => sectionWidget(context, section))
        .toList();
    widgets.add(Container(
        // color: Theme.of(context).highlightColor,
        child: Column(children: sections)));
    return Container(
      constraints: BoxConstraints(minWidth: 300, maxWidth: 800),
      child: Scrollbar(
          child: ListView(children: widgets, controller: _scrollController)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextLoadLayout(builder: (context, chapters) {
      String chapterId = ModalRoute.of(context).settings.name;
      if (chapterId.startsWith("/")) chapterId = chapterId.substring(1);
      Chapter chapter = chapters.firstWhere((c) => c.id == chapterId);
      return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Icon(chapter.image),
            Container(width: 10),
            Text(chapter.title)
          ]),
        ),
        body: Container(
            color: Theme.of(context).highlightColor,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Center(
              child: buildMainView(context, chapter),
            )),
      );
    });
  }
}