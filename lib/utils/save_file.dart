import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:gen_invo/Models/invoice_result_model.dart';
import 'package:gen_invo/utils/invoice_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SaveFile {
  static Future<List> saveFile(BuildContext context, String fileName,
      InvoiceResultModel invoiceData) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await SaveFile().requestPermission()) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/$folder";
            } else {
              break;
            }
          }
          newPath = "$newPath/GenInvo";
          var date = DateTime.parse(
              "${invoiceData.date!.split("-")[2]}-${invoiceData.date!.split("-")[1]}-${invoiceData.date!.split("-")[0]}");
          if (date.isAfter(DateTime(date.year, 3, 31)) &&
              date.isBefore(DateTime(date.year + 1, 4, 1))) {
            newPath =
                "$newPath/FY-${date.year}-${date.year + 1}/${SaveFile().getMonth(date.month.toString())}";
          } else {
            newPath =
                "$newPath/FY-${date.year - 1}-${date.year}/${SaveFile().getMonth(date.month.toString())}";
          }
          directory = Directory(newPath);
        } else {
          return [false, ""];
        }
      } else {}
      if (!await directory!.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File saveFile = File("${directory.path}/$fileName.pdf");

        await saveFile.writeAsBytes(await generateInvoice(invoiceData),
            flush: true);

        return [true, saveFile.path];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
    return [false, ""];
  }

  static Future<bool> deleteFile(BuildContext context, String fileName,
      InvoiceResultModel invoiceData) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await SaveFile().requestPermission()) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/$folder";
            } else {
              break;
            }
          }
          newPath = "$newPath/GenInvo";
          var date = DateTime.parse(
              "${invoiceData.date!.split("-")[2]}-${invoiceData.date!.split("-")[1]}-${invoiceData.date!.split("-")[0]}");
          if (date.isAfter(DateTime(date.year, 3, 31)) &&
              date.isBefore(DateTime(date.year + 1, 4, 1))) {
            newPath =
                "$newPath/FY-${date.year}-${date.year + 1}/${SaveFile().getMonth(date.month.toString())}";
          } else {
            newPath =
                "$newPath/FY-${date.year - 1}-${date.year}/${SaveFile().getMonth(date.month.toString())}";
          }
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {}
      if (!await directory!.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File saveFile = File("${directory.path}/$fileName.pdf");

        await saveFile.delete();
        // await saveFile.writeAsBytes(await generateInvoice(invoiceData),
        //     flush: true);

        return true;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
    return false;
  }

  Future<bool> requestPermission() async {
    final info = await DeviceInfoPlugin().androidInfo;
    if (info.version.sdkInt! >= 30) {
      final status = await Permission.storage.isGranted &&
          await Permission.manageExternalStorage.isGranted;
      if (!status) {
        final status = await Permission.storage.request().isGranted &&
            await Permission.manageExternalStorage.request().isGranted;
        if (status) {
          return true;
        }
      }
    }

    if (await Permission.storage.isGranted) {
      return true;
    } else {
      await Permission.storage.request();
      return await Permission.storage.isGranted;
    }
  }

  String getMonth(String month) {
    switch (month) {
      case "1":
        return "January";
      case "2":
        return "February";
      case "3":
        return "March";
      case "4":
        return "April";
      case "5":
        return "May";
      case "6":
        return "June";
      case "7":
        return "July";
      case "8":
        return "August";
      case "9":
        return "September";
      case "10":
        return "October";
      case "11":
        return "November";
      case "12":
        return "December";
      default:
        return "";
    }
  }
}
