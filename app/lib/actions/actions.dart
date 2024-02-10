import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/api_manager.dart';
import '/backend/backend.dart';
import '/backend/push_notifications/push_notifications_util.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future refreshData(
  BuildContext context, {
  required bool? local,
  required bool? global,
  required bool? history,
}) async {
  ApiCallResponse? localRes;
  ApiCallResponse? globalRes;
  ApiCallResponse? historyRes;

  logFirebaseEvent('RefreshData_show_snack_bar');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Refreshing Data',
        style: TextStyle(
          color: FlutterFlowTheme.of(context).primaryText,
        ),
      ),
      duration: Duration(milliseconds: 4000),
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
    ),
  );
  if (local!) {
    logFirebaseEvent('RefreshData_backend_call');
    localRes = await AppCall.call(
      action: 'get-local',
      lang: FFAppState().language,
      uniqueClientId: FFAppState().uniqueClientId,
      token: FFAppState().token,
    );
    logFirebaseEvent('RefreshData_update_app_state');
    FFAppState().update(() {
      FFAppState().products = functions
          .getProducts((localRes?.jsonBody ?? ''))
          .toList()
          .cast<ProductStruct>();
      FFAppState().systemProducts = functions
          .getSystemProducts((localRes?.jsonBody ?? ''))
          .toList()
          .cast<ProductStruct>();
    });
  }
  if (global!) {
    logFirebaseEvent('RefreshData_backend_call');
    globalRes = await AppCall.call(
      action: 'get-global',
      lang: FFAppState().language,
      uniqueClientId: FFAppState().uniqueClientId,
      token: FFAppState().token,
    );
    logFirebaseEvent('RefreshData_update_app_state');
    FFAppState().update(() {
      FFAppState().globalProducts = functions
          .getGlobalProducts((globalRes?.jsonBody ?? ''))
          .toList()
          .cast<ProductStruct>();
      FFAppState().globalSystemProduct = functions
          .getSystemGlobalProducts((globalRes?.jsonBody ?? ''))
          .toList()
          .cast<ProductStruct>();
    });
  }
  if (history!) {
    logFirebaseEvent('RefreshData_backend_call');
    historyRes = await AppCall.call(
      action: 'get-history',
      lang: FFAppState().language,
      uniqueClientId: FFAppState().uniqueClientId,
      token: FFAppState().token,
    );
    logFirebaseEvent('RefreshData_update_app_state');
    FFAppState().update(() {
      FFAppState().progress = functions
          .getProgress((historyRes?.jsonBody ?? ''))
          .toList()
          .cast<ProgressStruct>();
    });
  }
  logFirebaseEvent('RefreshData_show_snack_bar');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Data Refreshed',
        style: TextStyle(
          color: FlutterFlowTheme.of(context).primaryText,
        ),
      ),
      duration: Duration(milliseconds: 4000),
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
    ),
  );
}

Future processData(BuildContext context) async {
  ApiCallResponse? syncDataRes;

  logFirebaseEvent('ProcessData_show_snack_bar');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Processing Uploaded Data',
        style: TextStyle(
          color: FlutterFlowTheme.of(context).primaryText,
        ),
      ),
      duration: Duration(milliseconds: 4000),
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
    ),
  );
  logFirebaseEvent('ProcessData_backend_call');
  syncDataRes = await GoogleAICall.call(
    token: FFAppState().token,
    lang: FFAppState().language,
    action: 'process-drive',
  );
  if ((syncDataRes?.succeeded ?? true)) {
    logFirebaseEvent('ProcessData_action_block');
    await action_blocks.refreshData(
      context,
      local: true,
      global: true,
      history: true,
    );
    logFirebaseEvent('ProcessData_show_snack_bar');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Processing Completed',
          style: TextStyle(
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        duration: Duration(milliseconds: 4000),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      ),
    );
  } else {
    logFirebaseEvent('ProcessData_show_snack_bar');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Processing Failed',
          style: TextStyle(
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        duration: Duration(milliseconds: 4000),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      ),
    );
  }

  logFirebaseEvent('ProcessData_action_block');
  await action_blocks.pushNotify(
    context,
    message: 'Check History for Status',
    title: 'Processing Data Completed',
  );
}

Future clearState(BuildContext context) async {
  logFirebaseEvent('ClearState_update_app_state');
  FFAppState().update(() {
    FFAppState().sheetUrl = '';
    FFAppState().products = [];
    FFAppState().currentProduct =
        ProductStruct.fromSerializableMap(jsonDecode('{}'));
    FFAppState().driveFolderLink = '';
    FFAppState().driveSheetLink = '';
    FFAppState().globalProducts = [];
    FFAppState().systemProducts = [];
    FFAppState().progress = [];
    FFAppState().token = '';
    FFAppState().password = '';
    FFAppState().fullName = '';
    FFAppState().globalSystemProduct = [];
  });
}

Future logOut(BuildContext context) async {
  logFirebaseEvent('LogOut_close_dialog,_drawer,_etc');
  Navigator.pop(context);
  logFirebaseEvent('LogOut_action_block');
  await action_blocks.clearState(context);
  logFirebaseEvent('LogOut_navigate_to');

  context.pushNamed('Login');
}

Future preRequestInterceptor(BuildContext context) async {
  bool? isConnected;
  ApiCallResponse? authCheck;

  logFirebaseEvent('PreRequestInterceptor_custom_action');
  isConnected = await actions.isConnectedToInternet();
  if (isConnected!) {
    logFirebaseEvent('PreRequestInterceptor_backend_call');
    authCheck = await AppCall.call(
      action: 'authenticate-user',
      uniqueClientId: FFAppState().uniqueClientId,
      password: FFAppState().password,
    );
    if ((authCheck?.succeeded ?? true)) {
      logFirebaseEvent('PreRequestInterceptor_update_app_state');
      FFAppState().update(() {
        FFAppState().token = (authCheck?.bodyText ?? '');
      });
    } else {
      logFirebaseEvent('PreRequestInterceptor_show_snack_bar');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could Not Authenticate',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          duration: Duration(milliseconds: 4000),
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        ),
      );
      logFirebaseEvent('PreRequestInterceptor_action_block');
      await action_blocks.logOut(context);
      return;
    }
  } else {
    logFirebaseEvent('PreRequestInterceptor_show_snack_bar');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Not Connected To Internet',
          style: TextStyle(
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        duration: Duration(milliseconds: 4000),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      ),
    );
  }
}

Future pushNotify(
  BuildContext context, {
  required String? message,
  required String? title,
}) async {
  logFirebaseEvent('PushNotify_trigger_push_notification');
  triggerPushNotification(
    notificationTitle: title!,
    notificationText: message!,
    notificationSound: 'default',
    userRefs: [currentUserReference!],
    initialPageName: 'MyProducts',
    parameterData: {},
  );
}
