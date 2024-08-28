class ApiEndPoints {
  static const String baseUrl = 'http://10.10.86.106:8001';
  static AuthEndPoints authEndpoints = AuthEndPoints();
}

class AuthEndPoints {
  final String registerEmail = '/register';
  final String loginEmail = '/login';
  final String remoteAreaWeekly = '/remote_area_weekly';

  final String submitUserDailyAudit = '/storeAuditData';
  final String submitUserWeeklyAudit = '/WeekAuditData';

  final String lastauditdata = '/last-audit-date';
  final String userdata = '/users';

  final String assignweeklytaskper = '/weeklyPersonAssign';
  final String getweeklytaskper = '/weeklyPersonAssign';
  final String getweeklyreports = '/weeklyreport';
  final String getcampusreports = '/specific-task';

  final String createweeklyauditId = '/tasks';
  final String showallweeklyauditId = '/tasks';
  final String sendNotificationToUser = '/send-user-Notification';

  final String enterAreaQuestions = '/area_questions';
  final String mainareas = '/main_area';
  final String specificareas = '/specific_areas';
  final String questions = '/questions';
  final String questionsBySpecArea = '/questionsBySpecArea';
  final String mainareaBySpecArea = '/main_area_by_spec';

  final String pdfWeekly = '/generate-pdf';
  final String pdfCampus = '/generate-specific-pdf';

  final String specificPendingAreas = '/specific-task-pending';
  final String reportspecificAreas = '/audit/area';
  final String createspecifictaskid = '/specific-task';

  final String campusStatusUpdate = '/update-status';

  final String userFCMtoken = '/store-token';
  final String FCMtokendelete = '/logout-token';
}
