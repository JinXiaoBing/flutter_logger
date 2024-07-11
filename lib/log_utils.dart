library log_utils;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

enum Level {
  trace(1000),
  debug(2000),
  info(3000),
  warning(4000),
  error(5000),
  fatal(6000),
  ;

  final int value;

  const Level(this.value);
}

class LogUtils {
  late int? maxLength;
  late int maxFileCount;

  late final String dirPath;
  late final String fileName;

  LogUtils();

  static final levelPrefixes = {
    Level.trace: 'trace',
    Level.debug: 'debug',
    Level.info: 'info',
    Level.warning: 'warning',
    Level.error: 'error',
    Level.fatal: 'fatal',
  };

  init(String dirPath, String fileName, {int? maxLength, int maxFileCount = 99}) {
    this.dirPath = dirPath;
    this.fileName = fileName;
    this.maxFileCount = maxFileCount;
    this.maxLength = maxLength;
    debugPrint("dirPath:$dirPath");
    debugPrint("fileName:$fileName");
    debugPrint("maxFileCount:$maxFileCount");
    debugPrint("maxLength:$maxLength");
  }

  void log(String log,{Level level = Level.info}) {
    String logFilePath = path.join(dirPath, "$fileName.log");
    File logFile = File(logFilePath);
    if (!logFile.existsSync()) {
      logFile.createSync(recursive: true);
    }
    log = "${DateTime.now().toUtc().toIso8601String()}\t【${levelPrefixes[level]}】$log\n";
    debugPrint(log);
    if (!logFile.existsSync()) {
      logFile.createSync(recursive: true);
    }
    int length = logFile.lengthSync();
    if (maxLength != null && length + log.length > maxLength!) {
      _rollFiles();
    }
    logFile.writeAsStringSync(log, mode: FileMode.append);
  }

  /// 滚动日志文件
  void _rollFiles() {
    for (int i = maxFileCount - 1; i > 0; i--) {
      final oldFile = File(path.join(dirPath, "$fileName.$i.log"));
      final newFile = File(path.join(dirPath, "$fileName.${i + 1}.log"));
      if (oldFile.existsSync()) {
        if (i == maxFileCount - 1) {
          oldFile.deleteSync();
        } else {
          oldFile.renameSync(newFile.path);
        }
      }
    }
    String logFilePath = path.join(dirPath, "$fileName.log");
    File logFile = File(logFilePath);
    if (maxFileCount == 1) {
      logFile.deleteSync();
    } else {
      final rolledLogFile = File(path.join(dirPath, "$fileName.1.log"));
      logFile.renameSync(rolledLogFile.path);
    }
  }

  List<String> readLogsAsLines() {
    String logFilePath = path.join(dirPath, "$fileName.log");
    File logFile = File(logFilePath);
    if (!logFile.existsSync()) {
      return [];
    }
    return logFile.readAsLinesSync();
  }

  void clear() {
    String logFilePath = path.join(dirPath, "$fileName.log");
    File logFile = File(logFilePath);
    if (logFile.existsSync()) {
      logFile.deleteSync();
    }
  }
}
