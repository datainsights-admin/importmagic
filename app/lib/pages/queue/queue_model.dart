import '/backend/api_requests/api_calls.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/components/upload_image/upload_image_widget.dart';
import '/components/upload_text/upload_text_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/actions/index.dart' as actions;
import 'queue_widget.dart' show QueueWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class QueueModel extends FlutterFlowModel<QueueWidget> {
  ///  Local state fields for this page.

  int index = 0;

  int indexImg = 0;

  int? indexTotal = 0;

  int? imgIndexTotal = 0;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Models for UploadText dynamic component.
  late FlutterFlowDynamicModels<UploadTextModel> uploadTextModels;
  // Stores action output result for [Backend Call - API (app)] action in Button widget.
  ApiCallResponse? apiResult9ho;
  // Models for UploadImage dynamic component.
  late FlutterFlowDynamicModels<UploadImageModel> uploadImageModels;
  // Stores action output result for [Custom Action - jsonToUploadedFile] action in Button widget.
  FFUploadedFile? iimRes;
  // Stores action output result for [Backend Call - API (app)] action in Button widget.
  ApiCallResponse? apiResult9hos;
  // Model for Sidebar component.
  late SidebarModel sidebarModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    uploadTextModels = FlutterFlowDynamicModels(() => UploadTextModel());
    uploadImageModels = FlutterFlowDynamicModels(() => UploadImageModel());
    sidebarModel = createModel(context, () => SidebarModel());
  }

  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
    uploadTextModels.dispose();
    uploadImageModels.dispose();
    sidebarModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
