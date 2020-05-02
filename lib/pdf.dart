import 'dart:io';

import 'package:medplus/cartmodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:mailer2/mailer.dart';


Future<File> createpdf(List<cart> x,double ta,String emailid) async  {
  
  List<List<String>> y=[];
  y.add(<String>["Medicine name","Cost"]);
  for(int i=0;i<x.length;i++){
    y.add(<String>[x[i].name,x[i].cost.toString()]);

  }
  y.add(<String>["        Total Amount","$ta"]);

  final Document pdf = Document();
  Directory directory = await getExternalStorageDirectory();
  String path = directory.path;
  
 
  pdf.addPage(MultiPage(
      pageFormat:
      PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const BoxDecoration(
                border:
                BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)),
            child: Text('Order Receipt',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      footer: (Context context) {
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (Context context) => <Widget>[
        Header(
            level: 0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  
                  Text('Order Receipt', textScaleFactor: 2), 
                  
                  
                ])),
        Table.fromTextArray(context: context, data:y),
        
        Padding(padding: const EdgeInsets.all(10)),

      ]));
  final file = File("$path/invoice.pdf");
  await file.writeAsBytes(pdf.save());
  var options = new GmailSmtpOptions()
    ..username = 'noreply.medplus@gmail.com'
    ..password = 'Medplus1234'; 
  var emailTransport = new SmtpTransport(options);

  
  var envelope = new Envelope()
    ..from = 'foo@bar.com'
    ..recipients.add('$emailid')
    ..bccRecipients.add('hidden@recipient.com')
    ..subject = 'New Medplus Order Invoice'
    ..attachments.add(new Attachment(file: new File('$path/invoice.pdf')))
    ..text = 'This is a cool email message. Whats up?'
    ..html = '<h1>Invoice</h1><p>New Order Placed</p>';

  // Email it.
  emailTransport.send(envelope)
      .then((envelope) => print('Email sent!'))
      .catchError((e) => print('Error occurred: $e'));



  return file;
}