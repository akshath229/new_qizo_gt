
import 'package:intl/intl.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

import 'Local_db.dart';

class Offline_Print{




  Future<Ticket> Printerticket( {dataForTicket}) async {
    // final ticket = Ticket(paper);
    print('in');


  var  _resCmpData=await Local_Db().GetCompanyMasterData();

  var Companydata=await _resCmpData[0];

    final ticket = Ticket(PaperSize.mm80);

    List<dynamic> slsDet = dataForTicket["salesDetails"] as List;
    dynamic VchNo = (dataForTicket["salesHeader"][0]["voucherNo"]) == null
        ? "00"
        : (dataForTicket["salesHeader"][0]["voucherNo"]).toString();
// dynamic date=(dataForTicket["salesHeader"][0]["voucherDate"])==null?"-:-:-": DateFormat("yyyy-MM-dd hh:mm:ss").format((dataForTicket["salesHeader"][0]["voucherDate"]));
    dynamic date = (DateFormat("dd/MM/yyy hh:mm:ss a").format(DateTime.now()).toString());
    dynamic partyName=(dataForTicket["salesHeader"][0]["partyName"]) == null ||
        (dataForTicket["salesHeader"][0]["partyName"])== ""
        ? ""
        : (dataForTicket["salesHeader"][0]["partyName"]).toString();



    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:Companydata.companyProfileName.toString(),
          width: 10,
          styles: PosStyles(bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(text: ' ', width: 1)
    ]);




    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:(Companydata.companyProfileAddress1).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,)),
      PosColumn(text: ' ', width: 1)
    ]);



    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text: (Companydata.companyProfileAddress2).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);

    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:  (Companydata.companyProfileAddress3).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);



    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:(Companydata.companyProfileMobile).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);




    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:  (Companydata.companyProfileEmail).toString(),
          width: 10,
          styles:PosStyles(bold: false,underline: true,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);





    ticket.text('GSTIN: ' +
        ( Companydata.companyProfileGstNo).toString()+' ',
        styles: PosStyles(bold: false,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));


    ticket.text('Inv.NO : ' + VchNo.toString(),
        styles: PosStyles(bold: true, width: PosTextSize.size1));
    //ticket.emptyLines(1);
    ticket.text('Date : $date');

    //---------------------------------------------------------
    if(partyName !="")
    {
      //ticket.emptyLines(1);
      ticket.text('Name : $partyName');
    }
    if((dataForTicket["salesHeader"][0]["gstNo"]) !=null)
    {
      // ticket.emptyLines(1);
      ticket.text('GST No :' +((dataForTicket["salesHeader"][0]["gstNo"])));
    }
    //---------------------------------------------------------

    ticket.hr(ch: '_');
    ticket.row([
      PosColumn(
        text:'No',
        styles: PosStyles(align: PosAlign.left),
        width:1,
      ),
      PosColumn(
        text:'Item',
        styles: PosStyles(bold: true,align: PosAlign.center),
        width: 2,
      ),
      PosColumn(text: 'Qt', width: 1,styles: PosStyles(align: PosAlign.right ),),
      PosColumn(text: 'Rate', width: 3,styles:PosStyles(align: PosAlign.center)),
      PosColumn(text: 'Tax', width: 2,styles: PosStyles(align: PosAlign.center ),),
      PosColumn(text: ' Amonunt', width: 3,styles: PosStyles(align: PosAlign.center ),),
    ]);
    ticket
        .hr(); // for dot line or set ticket.hr(ch: 'charecter', linesAfter: 1);
    var snlnum=0;
    dynamic total = 0.000;
    for (var i = 0; i < slsDet.length; i++) {
      total = slsDet[i]["amountIncludingTax"] + total;
      // ticket.emptyLines(1);
      snlnum=snlnum+1;
      ticket.row([
        PosColumn(text: (snlnum.toString()),width: 1,styles: PosStyles(
            align: PosAlign.left
        )),

        PosColumn(text: (slsDet[i]["itmName"]),
            width: 11,styles:
            PosStyles(align: PosAlign.left )),] );

      // for space
      ticket.row([
        PosColumn(
          text: (''),
          width: 1,
        ),
        PosColumn(
            text: (' '+((slsDet[i]["qty"])).toStringAsFixed(0)).toString(),styles:PosStyles(align: PosAlign.right ),
            width: 2),
        PosColumn(
            text: (((slsDet[i]["rate"])).toStringAsFixed(2)).toString(),
            width: 3,
            styles: PosStyles(
                align: PosAlign.right
            )),

        PosColumn(
            text: (' ' + ((slsDet[i]["taxPercentage"])).toStringAsFixed(2))
                .toString(),styles:PosStyles(align: PosAlign.right ),
            width: 2),
        PosColumn(
            text: ((slsDet[i] ["amountIncludingTax"])).toStringAsFixed(2)
            ,styles:PosStyles(align:PosAlign.right ),
            width:4),
      ]);
    }


    ticket.hr(ch:"=",len: 32);
    ticket.row([
      PosColumn(
          text: 'Total',
          width: 4,
          styles: PosStyles(
            bold: true,align:PosAlign.left,
          )),
      PosColumn(
          text:'Rs '+(total.toStringAsFixed(2)).toString(),
          width: 8,
          styles: PosStyles(bold: true,align: PosAlign.right,)),
    ]);
    ticket.hr(
        ch: '_',len: 32 );

    // ticket.row([
    //   PosColumn(text: ' ', width: 1),
    //   PosColumn(
    //       text: footerCaptions[0]['footerCaption'],
    //       width: 10,
    //       styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: ' ', width: 1)
    // ]);
    //
    // ticket.row([
    //   PosColumn(text: '  ', width: 1),
    //   PosColumn(
    //       text: footerCaptions[0]['footerText'],
    //       width: 10,
    //       styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: '  ', width: 1)
    // ]);

    ticket.feed(1);
    ticket.text('Thank You...Visit again !!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    print("Success");
    ticket.cut();
    return ticket;
  }
}