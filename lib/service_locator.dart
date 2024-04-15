import 'package:get_it/get_it.dart';
import 'package:medireminder/View%20Models/vm_event.dart';
import 'package:medireminder/View%20Models/vm_add_med.dart';
import 'package:medireminder/View%20Models/vm_save_record.dart';

final serviceLocator = GetIt.instance;

void serviceLocatorInit() {
  serviceLocator.registerLazySingleton<VMAddMed>(() => VMAddMed());
  serviceLocator.registerLazySingleton<VMEvent>(() => VMEvent());
  serviceLocator.registerLazySingleton<VMSaveRecord>(() => VMSaveRecord());
}
