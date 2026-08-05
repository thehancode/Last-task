// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Last Task';

  @override
  String get windowTitle => 'Last Task';

  @override
  String get workspaceTitle => 'Last Task';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get close => 'Cerrar';

  @override
  String get task => 'Tarea';

  @override
  String get newTask => 'Nueva tarea';

  @override
  String get addNewTask => 'añadir nueva tarea';

  @override
  String get addNewSubtask => 'añadir nueva subtarea';

  @override
  String get newDailyTask => 'Crear nueva tarea diaria';

  @override
  String get newSubtask => 'Nueva subtarea';

  @override
  String get collapseSubtasks => 'Ocultar subtareas';

  @override
  String get expandSubtasks => 'Mostrar subtareas';

  @override
  String get editTask => 'Editar tarea';

  @override
  String get duplicateTask => 'Duplicar tarea';

  @override
  String get deleteTaskTitle => '¿Eliminar tarea?';

  @override
  String get deleteListTitle => '¿Eliminar lista?';

  @override
  String get deleteList => 'Eliminar lista';

  @override
  String get deleteTaskBody =>
      'Se eliminarán esta tarea y todas sus subtareas. Esta acción no se puede deshacer.';

  @override
  String deleteSelectedTasksTitle(Object count) {
    return '¿Eliminar tareas seleccionadas?';
  }

  @override
  String deleteSelectedTasksBody(Object count) {
    return '¿Eliminar $count tareas seleccionadas y sus subtareas? Esta acción no se puede deshacer.';
  }

  @override
  String deleteListBody(Object listName) {
    return '¿Eliminar \"$listName\" y todas sus tareas?';
  }

  @override
  String get keyboardShortcuts => 'Atajos';

  @override
  String get keyboardShortcutsHelp =>
      '↑/↓ o J/K   Mover selección\nMayús+↑/↓   Seleccionar tareas visibles\n←/→   Cambiar listas\nMantén Ctrl + ←/→   Reordenar listas\nEspacio y Espacio   Completar árbol\nMantén Ctrl + ↑/↓   Reordenar tarea\nIntro / Mayús+Intro   Crear / editar tarea\nTab / D / X   Subtarea, duplicar, eliminar\nH   Contraer / expandir subtareas\nW / Mayús+W   Cambiar etiquetas\nCtrl+C   Copiar tarea/selección\nCtrl+Mayús+C   Copiar sección\nEsc   Limpiar selección\nCtrl+A / Ctrl+Mayús+A   Seleccionar visibles / Vista múltiple\nCtrl+F o /   Buscar\nCtrl+Z / Ctrl+Mayús+Z   Deshacer / rehacer\nCtrl+N   Nueva lista\nF2 / Ctrl+R   Renombrar lista\nCtrl+X   Eliminar lista\nV   Historial completado\nG   Ajustes\nS   Sonido\nQ   Salir';

  @override
  String get couldNotLoad => 'No se pudo cargar Last Task';

  @override
  String get dragWindow => 'Arrastrar ventana';

  @override
  String get closeApp => 'Cerrar aplicación';

  @override
  String get newTaskTooltip => 'Nueva tarea (N)';

  @override
  String get newListTooltip => 'Nueva lista (Ctrl+N)';

  @override
  String get listActions => 'Lista';

  @override
  String get appActions => 'Menú';

  @override
  String get newList => 'Nueva lista';

  @override
  String get listsLabel => 'Listas';

  @override
  String get openSidebar => 'Abrir barra lateral';

  @override
  String get renameList => 'Renombrar lista';

  @override
  String get toggleMultiView => 'Multivista';

  @override
  String get settings => 'Ajustes';

  @override
  String get logIn => 'Iniciar sesión';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get username => 'Usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get administration => 'Administración';

  @override
  String get createUser => 'Crear usuario';

  @override
  String get email => 'Correo electrónico';

  @override
  String get displayName => 'Nombre visible';

  @override
  String get administrator => 'Administrador';

  @override
  String get noUsers => 'No se encontraron usuarios';

  @override
  String get deleteUser => 'Eliminar usuario';

  @override
  String get deleteUserTitle => '¿Eliminar usuario?';

  @override
  String deleteUserBody(Object userName) {
    return '¿Eliminar a $userName y todos sus datos? Esta acción no se puede deshacer.';
  }

  @override
  String get themes => 'Temas';

  @override
  String taskList(Object listName) {
    return 'Lista de tareas $listName';
  }

  @override
  String get listView => 'LISTA';

  @override
  String get completed => 'HECHAS';

  @override
  String get multiView => 'MULTIVISTA';

  @override
  String get pending => 'Pendiente';

  @override
  String get doing => 'En curso';

  @override
  String get done => 'Hecha';

  @override
  String get archived => 'Archivadas';

  @override
  String get noCompletedTasks =>
      'Aún no hay tareas completadas; completa una desde sus controles.';

  @override
  String get noDoingOrPendingTasks => 'No hay tareas en curso ni pendientes';

  @override
  String get empty => 'vacío';

  @override
  String taskSemantics(Object status, Object title, Object tags) {
    return 'Tarea $status: $title$tags';
  }

  @override
  String taskTagsSemantics(Object tags) {
    return ', etiquetas: $tags';
  }

  @override
  String get advanceTask => 'Avanzar';

  @override
  String get taskActions => 'Tarea';

  @override
  String get reopenInDoing => 'Restaurar pendiente';

  @override
  String get edit => 'Editar';

  @override
  String get copy => 'Copiar';

  @override
  String get duplicate => 'Duplicar';

  @override
  String get archive => 'Archivar';

  @override
  String get spaceArmed => ' ESPACIO activado — ESPACIO completa ';

  @override
  String dailyActivity(Object activity) {
    return ' Diaria: $activity';
  }

  @override
  String get keyboardHint =>
      'Ctrl+A múltiple   Tab listas   ↑↓ mover   N nueva   Espacio+Espacio completar   Ctrl+↑↓ ordenar   ? ayuda';

  @override
  String commandSemantics(Object label, Object keys) {
    return 'comando $label ($keys)';
  }

  @override
  String get commandMulti => 'múltiple';

  @override
  String get commandLists => 'listas';

  @override
  String get commandMove => 'Mover';

  @override
  String get commandMoveLegacy => 'mover';

  @override
  String get commandNew => 'Nueva tarea';

  @override
  String get commandNewLegacy => 'nueva';

  @override
  String get commandAdvance => 'avanzar';

  @override
  String get commandSort => 'ordenar';

  @override
  String get commandTags => 'Etiquetar tarea';

  @override
  String get commandTagsLegacy => 'etiquetas';

  @override
  String get commandNewList => 'Nueva lista';

  @override
  String get commandNewListLegacy => 'nueva lista';

  @override
  String get commandRename => 'renombrar';

  @override
  String get commandDeleteList => 'elim. lista';

  @override
  String get commandSettings => 'Ajustes';

  @override
  String get commandSettingsLegacy => 'ajustes';

  @override
  String get commandHelp => 'Ayuda';

  @override
  String get commandHelpLegacy => 'ayuda';

  @override
  String get taskTitle => 'Título';

  @override
  String get habitList => 'Lista de hábitos (las tareas se reinician cada día)';

  @override
  String get listName => 'Lista';

  @override
  String get tagNamesCannotBeEmpty =>
      'Los nombres de etiquetas no pueden estar vacíos';

  @override
  String desktopFontSize(int points) {
    return 'Tamaño de fuente de escritorio: $points pt';
  }

  @override
  String get desktopFontSizeLabel => 'Fuente de escritorio';

  @override
  String get fontFamily => 'Fuente';

  @override
  String get tagNames => 'Etiquetas';

  @override
  String get saveTagNames => 'Guardar etiquetas';

  @override
  String get language => 'Idioma';

  @override
  String languageValue(Object language) {
    return 'Idioma: $language';
  }

  @override
  String get completionDatePattern => 'dd/MM/yyyy';

  @override
  String get completionDaySuffix => 'd';

  @override
  String get exportData => 'Exportar datos';

  @override
  String get importData => 'Cargar datos';

  @override
  String get taskWasCopied => 'Se copió la tarea';

  @override
  String get selectionWasCopied => 'Se copió la selección';

  @override
  String selectedTasksCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tareas seleccionadas',
      one: '1 tarea seleccionada',
    );
    return '$_temp0';
  }

  @override
  String get search => 'Buscar';

  @override
  String get previousMatch => 'Coincidencia anterior';

  @override
  String get nextMatch => 'Coincidencia siguiente';

  @override
  String get closeSearch => 'Cerrar búsqueda';

  @override
  String get typeToSearch => 'Escribe para buscar';

  @override
  String get noSearchMatches => 'Sin coincidencias';

  @override
  String get longTitleMode => 'Modo de títulos largos';

  @override
  String get wrapSelected => 'Ajustar seleccionado';

  @override
  String get wrapAll => 'Ajustar todos';

  @override
  String get backgroundImage => 'Imagen de fondo';

  @override
  String get backgroundOpacity => 'Opacidad del color de fondo';

  @override
  String get backgroundTransparency => 'Transparencia del fondo';

  @override
  String get configTab => 'Config.';

  @override
  String get backgroundTab => 'Fondo';

  @override
  String get decrease => 'Disminuir';

  @override
  String get increase => 'Aumentar';

  @override
  String get backgroundFit => 'Ajuste de imagen';

  @override
  String get cover => 'Cubrir';

  @override
  String get contain => 'Contener';

  @override
  String get noImageSelected => 'Sin imagen seleccionada';

  @override
  String get none => 'Ninguna';

  @override
  String get clear => 'Quitar';

  @override
  String get guestImportTitle => '¿Importar tareas locales?';

  @override
  String get guestImportMessage =>
      'Este dispositivo tiene listas de invitado. Importa una copia a esta cuenta o mantenlas separadas.';

  @override
  String get importTasks => 'Importar';

  @override
  String get keepSeparate => 'Separar';

  @override
  String get languageName => 'Español';
}

/// The translations for Spanish Castilian, as used in Latin America and the Caribbean (`es_419`).
class AppLocalizationsEs419 extends AppLocalizationsEs {
  AppLocalizationsEs419() : super('es_419');

  @override
  String get appTitle => 'Last Task';

  @override
  String get windowTitle => 'Last Task';

  @override
  String get workspaceTitle => 'Last Task';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get close => 'Cerrar';

  @override
  String get task => 'Tarea';

  @override
  String get newTask => 'Nueva tarea';

  @override
  String get addNewTask => 'agregar nueva tarea';

  @override
  String get addNewSubtask => 'agregar nueva subtarea';

  @override
  String get newDailyTask => 'Crear nueva tarea diaria';

  @override
  String get newSubtask => 'Nueva subtarea';

  @override
  String get collapseSubtasks => 'Ocultar subtareas';

  @override
  String get expandSubtasks => 'Mostrar subtareas';

  @override
  String get editTask => 'Editar tarea';

  @override
  String get duplicateTask => 'Duplicar tarea';

  @override
  String get deleteTaskTitle => '¿Eliminar tarea?';

  @override
  String get deleteListTitle => '¿Eliminar lista?';

  @override
  String get deleteList => 'Eliminar lista';

  @override
  String get deleteTaskBody =>
      'Se eliminarán esta tarea y todas sus subtareas. Esta acción no se puede deshacer.';

  @override
  String deleteSelectedTasksTitle(Object count) {
    return '¿Eliminar tareas seleccionadas?';
  }

  @override
  String deleteSelectedTasksBody(Object count) {
    return '¿Eliminar $count tareas seleccionadas y sus subtareas? Esta acción no se puede deshacer.';
  }

  @override
  String deleteListBody(Object listName) {
    return '¿Eliminar \"$listName\" y todas sus tareas?';
  }

  @override
  String get keyboardShortcuts => 'Atajos';

  @override
  String get keyboardShortcutsHelp =>
      '↑/↓ o J/K   Mover selección\nMayús+↑/↓   Seleccionar tareas visibles\n←/→   Cambiar listas\nMantén Ctrl + ←/→   Reordenar listas\nEspacio y Espacio   Completar árbol\nMantén Ctrl + ↑/↓   Reordenar tarea\nIntro / Mayús+Intro   Crear / editar tarea\nTab / D / X   Subtarea, duplicar, eliminar\nH   Contraer / expandir subtareas\nW / Mayús+W   Cambiar etiquetas\nCtrl+C   Copiar tarea/selección\nCtrl+Mayús+C   Copiar sección\nEsc   Limpiar selección\nCtrl+A / Ctrl+Mayús+A   Seleccionar visibles / Vista múltiple\nCtrl+F o /   Buscar\nCtrl+Z / Ctrl+Mayús+Z   Deshacer / rehacer\nCtrl+N   Nueva lista\nF2 / Ctrl+R   Renombrar lista\nCtrl+X   Eliminar lista\nV   Historial completado\nG   Configuración\nS   Sonido\nQ   Salir';

  @override
  String get couldNotLoad => 'No se pudo cargar Last Task';

  @override
  String get dragWindow => 'Arrastrar ventana';

  @override
  String get closeApp => 'Cerrar aplicación';

  @override
  String get newTaskTooltip => 'Nueva tarea (N)';

  @override
  String get newListTooltip => 'Nueva lista (Ctrl+N)';

  @override
  String get listActions => 'Lista';

  @override
  String get appActions => 'Menú';

  @override
  String get newList => 'Nueva lista';

  @override
  String get listsLabel => 'Listas';

  @override
  String get openSidebar => 'Abrir barra lateral';

  @override
  String get renameList => 'Renombrar lista';

  @override
  String get toggleMultiView => 'Multivista';

  @override
  String get settings => 'Ajustes';

  @override
  String get logIn => 'Iniciar sesión';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get username => 'Usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get administration => 'Administración';

  @override
  String get createUser => 'Crear usuario';

  @override
  String get email => 'Correo electrónico';

  @override
  String get displayName => 'Nombre visible';

  @override
  String get administrator => 'Administrador';

  @override
  String get noUsers => 'No se encontraron usuarios';

  @override
  String get deleteUser => 'Eliminar usuario';

  @override
  String get deleteUserTitle => '¿Eliminar usuario?';

  @override
  String deleteUserBody(Object userName) {
    return '¿Eliminar a $userName y todos sus datos? Esta acción no se puede deshacer.';
  }

  @override
  String get themes => 'Temas';

  @override
  String taskList(Object listName) {
    return 'Lista de tareas $listName';
  }

  @override
  String get listView => 'LISTA';

  @override
  String get completed => 'HECHAS';

  @override
  String get multiView => 'MULTIVISTA';

  @override
  String get pending => 'Pendiente';

  @override
  String get doing => 'En curso';

  @override
  String get done => 'Completada';

  @override
  String get archived => 'Archivadas';

  @override
  String get noCompletedTasks =>
      'Aún no hay tareas completadas; completa una desde sus controles.';

  @override
  String get noDoingOrPendingTasks => 'No hay tareas en curso ni pendientes';

  @override
  String get empty => 'vacío';

  @override
  String taskSemantics(Object status, Object title, Object tags) {
    return 'Tarea $status: $title$tags';
  }

  @override
  String taskTagsSemantics(Object tags) {
    return ', etiquetas: $tags';
  }

  @override
  String get advanceTask => 'Avanzar';

  @override
  String get taskActions => 'Tarea';

  @override
  String get reopenInDoing => 'Restaurar pendiente';

  @override
  String get edit => 'Editar';

  @override
  String get copy => 'Copiar';

  @override
  String get duplicate => 'Duplicar';

  @override
  String get archive => 'Archivar';

  @override
  String get spaceArmed => ' ESPACIO activado — ESPACIO completa ';

  @override
  String dailyActivity(Object activity) {
    return ' Diaria: $activity';
  }

  @override
  String get keyboardHint =>
      'Ctrl+A múltiple   Tab listas   ↑↓ mover   N nueva   Espacio+Espacio completar   Ctrl+↑↓ ordenar   ? ayuda';

  @override
  String commandSemantics(Object label, Object keys) {
    return 'comando $label ($keys)';
  }

  @override
  String get commandMulti => 'múltiple';

  @override
  String get commandLists => 'listas';

  @override
  String get commandMove => 'Mover';

  @override
  String get commandMoveLegacy => 'mover';

  @override
  String get commandNew => 'Nueva tarea';

  @override
  String get commandNewLegacy => 'nueva';

  @override
  String get commandAdvance => 'avanzar';

  @override
  String get commandSort => 'ordenar';

  @override
  String get commandTags => 'Etiquetar tarea';

  @override
  String get commandTagsLegacy => 'etiquetas';

  @override
  String get commandNewList => 'Nueva lista';

  @override
  String get commandNewListLegacy => 'nueva lista';

  @override
  String get commandRename => 'cambiar nombre';

  @override
  String get commandDeleteList => 'elim. lista';

  @override
  String get commandSettings => 'Configuración';

  @override
  String get commandSettingsLegacy => 'config.';

  @override
  String get commandHelp => 'Ayuda';

  @override
  String get commandHelpLegacy => 'ayuda';

  @override
  String get taskTitle => 'Título';

  @override
  String get habitList => 'Lista de hábitos (las tareas se reinician cada día)';

  @override
  String get listName => 'Lista';

  @override
  String get tagNamesCannotBeEmpty =>
      'Los nombres de las etiquetas no pueden estar vacíos';

  @override
  String desktopFontSize(int points) {
    return 'Tamaño de fuente en escritorio: $points pt';
  }

  @override
  String get desktopFontSizeLabel => 'Fuente de escritorio';

  @override
  String get fontFamily => 'Fuente';

  @override
  String get tagNames => 'Etiquetas';

  @override
  String get saveTagNames => 'Guardar etiquetas';

  @override
  String get language => 'Idioma';

  @override
  String languageValue(Object language) {
    return 'Idioma: $language';
  }

  @override
  String get completionDatePattern => 'dd/MM/yyyy';

  @override
  String get completionDaySuffix => 'd';

  @override
  String get exportData => 'Exportar datos';

  @override
  String get importData => 'Importar datos';

  @override
  String get taskWasCopied => 'Se copió la tarea';

  @override
  String get selectionWasCopied => 'Se copió la selección';

  @override
  String selectedTasksCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tareas seleccionadas',
      one: '1 tarea seleccionada',
    );
    return '$_temp0';
  }

  @override
  String get search => 'Buscar';

  @override
  String get previousMatch => 'Coincidencia anterior';

  @override
  String get nextMatch => 'Coincidencia siguiente';

  @override
  String get closeSearch => 'Cerrar búsqueda';

  @override
  String get typeToSearch => 'Escribe para buscar';

  @override
  String get noSearchMatches => 'Sin coincidencias';

  @override
  String get longTitleMode => 'Modo de títulos largos';

  @override
  String get wrapSelected => 'Ajustar seleccionado';

  @override
  String get wrapAll => 'Ajustar todos';

  @override
  String get backgroundImage => 'Imagen de fondo';

  @override
  String get backgroundOpacity => 'Opacidad del color de fondo';

  @override
  String get backgroundTransparency => 'Transparencia del fondo';

  @override
  String get configTab => 'Config.';

  @override
  String get backgroundTab => 'Fondo';

  @override
  String get decrease => 'Disminuir';

  @override
  String get increase => 'Aumentar';

  @override
  String get backgroundFit => 'Ajuste de imagen';

  @override
  String get cover => 'Cubrir';

  @override
  String get contain => 'Contener';

  @override
  String get noImageSelected => 'Sin imagen seleccionada';

  @override
  String get none => 'Ninguna';

  @override
  String get clear => 'Quitar';

  @override
  String get guestImportTitle => '¿Importar tareas locales?';

  @override
  String get guestImportMessage =>
      'Este dispositivo tiene listas de invitado. Importa una copia a esta cuenta o mantenlas separadas.';

  @override
  String get importTasks => 'Importar';

  @override
  String get keepSeparate => 'Separar';

  @override
  String get languageName => 'Español Latino';
}

/// The translations for Spanish Castilian, as used in Spain (`es_ES`).
class AppLocalizationsEsEs extends AppLocalizationsEs {
  AppLocalizationsEsEs() : super('es_ES');

  @override
  String get appTitle => 'Last Task';

  @override
  String get windowTitle => 'Last Task';

  @override
  String get workspaceTitle => 'Last Task';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get close => 'Cerrar';

  @override
  String get task => 'Tarea';

  @override
  String get newTask => 'Nueva tarea';

  @override
  String get addNewTask => 'añadir nueva tarea';

  @override
  String get addNewSubtask => 'añadir nueva subtarea';

  @override
  String get newDailyTask => 'Crear nueva tarea diaria';

  @override
  String get newSubtask => 'Nueva subtarea';

  @override
  String get collapseSubtasks => 'Ocultar subtareas';

  @override
  String get expandSubtasks => 'Mostrar subtareas';

  @override
  String get editTask => 'Editar tarea';

  @override
  String get duplicateTask => 'Duplicar tarea';

  @override
  String get deleteTaskTitle => '¿Eliminar tarea?';

  @override
  String get deleteListTitle => '¿Eliminar lista?';

  @override
  String get deleteList => 'Eliminar lista';

  @override
  String get deleteTaskBody =>
      'Se eliminarán esta tarea y todas sus subtareas. Esta acción no se puede deshacer.';

  @override
  String deleteSelectedTasksTitle(Object count) {
    return '¿Eliminar tareas seleccionadas?';
  }

  @override
  String deleteSelectedTasksBody(Object count) {
    return '¿Eliminar $count tareas seleccionadas y sus subtareas? Esta acción no se puede deshacer.';
  }

  @override
  String deleteListBody(Object listName) {
    return '¿Eliminar \"$listName\" y todas sus tareas?';
  }

  @override
  String get keyboardShortcuts => 'Atajos';

  @override
  String get keyboardShortcutsHelp =>
      '↑/↓ o J/K   Mover selección\nMayús+↑/↓   Seleccionar tareas visibles\n←/→   Cambiar listas\nMantén Ctrl + ←/→   Reordenar listas\nEspacio y Espacio   Completar árbol\nMantén Ctrl + ↑/↓   Reordenar tarea\nIntro / Mayús+Intro   Crear / editar tarea\nTab / D / X   Subtarea, duplicar, eliminar\nH   Contraer / expandir subtareas\nW / Mayús+W   Cambiar etiquetas\nCtrl+C   Copiar tarea/selección\nCtrl+Mayús+C   Copiar sección\nEsc   Limpiar selección\nCtrl+A / Ctrl+Mayús+A   Seleccionar visibles / Vista múltiple\nCtrl+F o /   Buscar\nCtrl+Z / Ctrl+Mayús+Z   Deshacer / rehacer\nCtrl+N   Nueva lista\nF2 / Ctrl+R   Renombrar lista\nCtrl+X   Eliminar lista\nV   Historial completado\nG   Ajustes\nS   Sonido\nQ   Salir';

  @override
  String get couldNotLoad => 'No se pudo cargar Last Task';

  @override
  String get dragWindow => 'Arrastrar ventana';

  @override
  String get closeApp => 'Cerrar aplicación';

  @override
  String get newTaskTooltip => 'Nueva tarea (N)';

  @override
  String get newListTooltip => 'Nueva lista (Ctrl+N)';

  @override
  String get listActions => 'Lista';

  @override
  String get appActions => 'Menú';

  @override
  String get newList => 'Nueva lista';

  @override
  String get listsLabel => 'Listas';

  @override
  String get openSidebar => 'Abrir barra lateral';

  @override
  String get renameList => 'Renombrar lista';

  @override
  String get toggleMultiView => 'Multivista';

  @override
  String get settings => 'Ajustes';

  @override
  String get logIn => 'Iniciar sesión';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get username => 'Usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get administration => 'Administración';

  @override
  String get createUser => 'Crear usuario';

  @override
  String get email => 'Correo electrónico';

  @override
  String get displayName => 'Nombre visible';

  @override
  String get administrator => 'Administrador';

  @override
  String get noUsers => 'No se encontraron usuarios';

  @override
  String get deleteUser => 'Eliminar usuario';

  @override
  String get deleteUserTitle => '¿Eliminar usuario?';

  @override
  String deleteUserBody(Object userName) {
    return '¿Eliminar a $userName y todos sus datos? Esta acción no se puede deshacer.';
  }

  @override
  String get themes => 'Temas';

  @override
  String taskList(Object listName) {
    return 'Lista de tareas $listName';
  }

  @override
  String get listView => 'LISTA';

  @override
  String get completed => 'HECHAS';

  @override
  String get multiView => 'MULTIVISTA';

  @override
  String get pending => 'Pendiente';

  @override
  String get doing => 'En curso';

  @override
  String get done => 'Hecha';

  @override
  String get archived => 'Archivadas';

  @override
  String get noCompletedTasks =>
      'Aún no hay tareas completadas; completa una desde sus controles.';

  @override
  String get noDoingOrPendingTasks => 'No hay tareas en curso ni pendientes';

  @override
  String get empty => 'vacío';

  @override
  String taskSemantics(Object status, Object title, Object tags) {
    return 'Tarea $status: $title$tags';
  }

  @override
  String taskTagsSemantics(Object tags) {
    return ', etiquetas: $tags';
  }

  @override
  String get advanceTask => 'Avanzar';

  @override
  String get taskActions => 'Tarea';

  @override
  String get reopenInDoing => 'Restaurar pendiente';

  @override
  String get edit => 'Editar';

  @override
  String get copy => 'Copiar';

  @override
  String get duplicate => 'Duplicar';

  @override
  String get archive => 'Archivar';

  @override
  String get spaceArmed => ' ESPACIO activado — ESPACIO completa ';

  @override
  String dailyActivity(Object activity) {
    return ' Diaria: $activity';
  }

  @override
  String get keyboardHint =>
      'Ctrl+A múltiple   Tab listas   ↑↓ mover   N nueva   Espacio+Espacio completar   Ctrl+↑↓ ordenar   ? ayuda';

  @override
  String commandSemantics(Object label, Object keys) {
    return 'comando $label ($keys)';
  }

  @override
  String get commandMulti => 'múltiple';

  @override
  String get commandLists => 'listas';

  @override
  String get commandMove => 'Mover';

  @override
  String get commandMoveLegacy => 'mover';

  @override
  String get commandNew => 'Nueva tarea';

  @override
  String get commandNewLegacy => 'nueva';

  @override
  String get commandAdvance => 'avanzar';

  @override
  String get commandSort => 'ordenar';

  @override
  String get commandTags => 'Etiquetar tarea';

  @override
  String get commandTagsLegacy => 'etiquetas';

  @override
  String get commandNewList => 'Nueva lista';

  @override
  String get commandNewListLegacy => 'nueva lista';

  @override
  String get commandRename => 'renombrar';

  @override
  String get commandDeleteList => 'elim. lista';

  @override
  String get commandSettings => 'Ajustes';

  @override
  String get commandSettingsLegacy => 'ajustes';

  @override
  String get commandHelp => 'Ayuda';

  @override
  String get commandHelpLegacy => 'ayuda';

  @override
  String get taskTitle => 'Título';

  @override
  String get habitList => 'Lista de hábitos (las tareas se reinician cada día)';

  @override
  String get listName => 'Lista';

  @override
  String get tagNamesCannotBeEmpty =>
      'Los nombres de etiquetas no pueden estar vacíos';

  @override
  String desktopFontSize(int points) {
    return 'Tamaño de fuente de escritorio: $points pt';
  }

  @override
  String get desktopFontSizeLabel => 'Fuente de escritorio';

  @override
  String get fontFamily => 'Fuente';

  @override
  String get tagNames => 'Etiquetas';

  @override
  String get saveTagNames => 'Guardar etiquetas';

  @override
  String get language => 'Idioma';

  @override
  String languageValue(Object language) {
    return 'Idioma: $language';
  }

  @override
  String get completionDatePattern => 'dd/MM/yyyy';

  @override
  String get completionDaySuffix => 'd';

  @override
  String get exportData => 'Exportar datos';

  @override
  String get importData => 'Importar datos';

  @override
  String get taskWasCopied => 'Se copió la tarea';

  @override
  String get selectionWasCopied => 'Se copió la selección';

  @override
  String selectedTasksCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tareas seleccionadas',
      one: '1 tarea seleccionada',
    );
    return '$_temp0';
  }

  @override
  String get search => 'Buscar';

  @override
  String get previousMatch => 'Coincidencia anterior';

  @override
  String get nextMatch => 'Coincidencia siguiente';

  @override
  String get closeSearch => 'Cerrar búsqueda';

  @override
  String get typeToSearch => 'Escribe para buscar';

  @override
  String get noSearchMatches => 'Sin coincidencias';

  @override
  String get longTitleMode => 'Modo de títulos largos';

  @override
  String get wrapSelected => 'Ajustar seleccionado';

  @override
  String get wrapAll => 'Ajustar todos';

  @override
  String get backgroundImage => 'Imagen de fondo';

  @override
  String get backgroundOpacity => 'Opacidad del color de fondo';

  @override
  String get backgroundTransparency => 'Transparencia del fondo';

  @override
  String get configTab => 'Config.';

  @override
  String get backgroundTab => 'Fondo';

  @override
  String get decrease => 'Disminuir';

  @override
  String get increase => 'Aumentar';

  @override
  String get backgroundFit => 'Ajuste de imagen';

  @override
  String get cover => 'Cubrir';

  @override
  String get contain => 'Contener';

  @override
  String get noImageSelected => 'Sin imagen seleccionada';

  @override
  String get none => 'Ninguna';

  @override
  String get clear => 'Quitar';

  @override
  String get guestImportTitle => '¿Importar tareas locales?';

  @override
  String get guestImportMessage =>
      'Este dispositivo tiene listas de invitado. Importa una copia a esta cuenta o mantenlas separadas.';

  @override
  String get importTasks => 'Importar';

  @override
  String get keepSeparate => 'Separar';

  @override
  String get languageName => 'Español (España)';
}
