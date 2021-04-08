import 'dart:io';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

///Local imports
import 'save_file_mobile.dart'
    if (dart.library.html) 'helper/save_file_web.dart';

/// Render pdf with annotations
class AnnotationsPdf extends SampleView {
  /// Creates pdf with annotations
  const AnnotationsPdf() : super();

  @override
  _AnnotationsPdfState createState() => _AnnotationsPdfState();
}

class _AnnotationsPdfState extends SampleViewState {
  _AnnotationsPdfState();

  bool flatten = false;
  List<Offset> _points = <Offset>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  FutureBuilder(
       // future: _generatePDF(),
        builder: (context, snapshot) {
        /*  if(snapshot.hasData){
            return SfPdfViewer.file(File(snapshot.data),
              enableDocumentLinkAnnotation: true,
            );
          }*/
           return GestureDetector(
               onPanUpdate: (DragUpdateDetails details) {
                 setState(() {
                   RenderBox object = context.findRenderObject();
                   Offset _localPosition =
                   object.globalToLocal(details.globalPosition);
                   print('_localPosition---');
                   print(_localPosition);
                   _points = new List.from(_points)..add(_localPosition);
                   print('_points---------');
                   print(_points);
                 });
               },
               onPanEnd: (DragEndDetails details) {
                 _generatePDF();
                 //_points.add(null);
                 print('end-----------');
                // _points.clear();
               },
               child: Stack(
                 children: [

                   SfPdfViewer.asset('assets/aeen101.pdf'),
                   CustomPaint(
                     painter:  Signature(points: _points),
                     size: Size.infinite,
                   ),
                 ],
               ),);
          return Container();
        },
      ),

     /* body: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          FutureBuilder(
            future: _generatePDF(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return SfPdfViewer.file(File(snapshot.data),
                  enableDocumentLinkAnnotation: true,
                  );
                }
                // return SfPdfViewer.asset('assets/aeen101.pdf');
                return Container();
              },
               ),
          // PDF.file(
          // snapshot.data,
          //   height:MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          // );
              Text('',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              const SizedBox(height: 10, width: 30),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  *//*  Checkbox(
                      value: flatten,

                      onChanged: (bool value) {
                        setState(() {

                        });
                      }),*//*
                  Text('Generate annotated pdf',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                ],
              )),
              const SizedBox(height: 10, width: 30),
              Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15)),
                    ),
                    onPressed: _generatePDF,
                    child: const Text('Generate PDF',
                        style: TextStyle(color: Colors.blue)),
                  ))
            ],
          ),
        ),
      ),*/
    );
  }

  Future<String> _generatePDF() async {
    //Load the PDF document.
    final PdfDocument document =
        PdfDocument(inputBytes: await _readDocumentData('aeen101.pdf'));
    //Get the page.
    final PdfPage page = document.pages[0];
    /*  //Create a line annotation.
    final PdfLineAnnotation lineAnnotation = PdfLineAnnotation(
        [60, 710, 187, 710], 'Introduction',
        color: PdfColor(0, 0, 255),
        author: 'John Milton',
        border: PdfAnnotationBorder(2),
        lineCaption: false,
        setAppearance: true,
        lineIntent: PdfLineIntent.lineDimension);
    //Add the line annotation to the page.
    page.annotations.add(lineAnnotation);*/

      //Create a ellipse Annotation.
    final PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
        Rect.fromPoints(_points.first,_points[((_points.length-1)~/2)]), 'Page Number',
        author: 'John Milton',
        border: PdfAnnotationBorder(2),
        color: PdfColor(255, 0, 0),
        setAppearance: true);
    //Add the ellipse annotation to the page.
    page.annotations.add(ellipseAnnotation);

    // //Create a rectangle annotation.
    // final PdfRectangleAnnotation rectangleAnnotation = PdfRectangleAnnotation(
    //     Rect.fromPoints(_points[0],_points.last), 'Usage',
    //     color: PdfColor(255, 0, 0),
    //     border: PdfAnnotationBorder(5),
    //     author: 'John Milton',
    //     setAppearance: true);
    // _points.clear();
    // // final PdfRectangleAnnotation rectangleAnnotation2 = PdfRectangleAnnotation(
    // //     Rect.fromLTRB(10, 800, 565, 120), 'Usage',
    // //     color: PdfColor(0, 0, 255),
    // //     border: PdfAnnotationBorder(3),
    // //     author: 'John Milton',
    // //     setAppearance: true);
    //
    // //Add the rectangle annotation to the page.
    // page.annotations.add(rectangleAnnotation);
    // page.annotations.add(rectangleAnnotation2);

/*    //Create a polygon annotation.
    final PdfPolygonAnnotation polygonAnnotation = PdfPolygonAnnotation(
        [129, 356, 486, 356, 532, 333, 486, 310, 129, 310, 83, 333, 129, 356],
        'Chapter 1 Conceptual Overview',
        color: PdfColor(255, 0, 0),
        border: PdfAnnotationBorder(2),
        author: 'John Milton',
        setAppearance: true);
    //Add the polygon annotation to the page.
    page.annotations.add(polygonAnnotation);*/

    if (flatten) {
      //Flatten all the annotations.
      //page.annotations.flattenAllAnnotations();
    }

    //Save and dispose the document.
    final List<int> bytes = document.save();
    document.dispose();
    //Launch file.
     var path1=await FileSaveHelper.saveAndLaunchFile(bytes, 'aeen101.pdf');
     print('path--------');
     print(path1);
     return path1;
  }

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}

/// Base class of the sample's stateful widget class
abstract class SampleView extends StatefulWidget {
  /// base class constructor of sample's stateful widget class
  const SampleView({Key key}) : super(key: key);
}

/// Base class of the sample's state class
abstract class SampleViewState extends State<SampleView> {
  /// Holds the SampleModel information

  /// Holds the information of current page is card view or not

  @override
  void initState() {
    super.initState();
  }

  @override

  /// Must call super.
  void dispose() {
    super.dispose();
  }

  /// Get the settings panel content.
  Widget buildSettings(BuildContext context) {
    return null;
  }
}


class Signature extends CustomPainter {
  List<Offset> points;

  Signature({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.lightBlueAccent.withOpacity(0.08)
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 10.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}