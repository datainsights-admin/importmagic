import '/backend/api_requests/api_calls.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_audio_player.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/actions/index.dart' as actions;
import 'upload_widget.dart' show UploadWidget;
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

class UploadModel extends FlutterFlowModel<UploadWidget> {
  ///  Local state fields for this page.

  int isRecording = 0;

  int index = 0;

  FFUploadedFile? cameraFile;

  List<FFUploadedFile> gallaryFile = [];
  void addToGallaryFile(FFUploadedFile item) => gallaryFile.add(item);
  void removeFromGallaryFile(FFUploadedFile item) => gallaryFile.remove(item);
  void removeAtIndexFromGallaryFile(int index) => gallaryFile.removeAt(index);
  void insertAtIndexInGallaryFile(int index, FFUploadedFile item) =>
      gallaryFile.insert(index, item);
  void updateGallaryFileAtIndex(int index, Function(FFUploadedFile) updateFn) =>
      gallaryFile[index] = updateFn(gallaryFile[index]);

  int? indexCount = 0;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  AudioRecorder? audioRecorder;
  String? currentRecording;
  FFUploadedFile recordedFileBytes =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  // Stores action output result for [Custom Action - audioPathToUploadedFile] action in Button widget.
  FFUploadedFile? conRes;
  // Stores action output result for [Backend Call - API (app)] action in Button widget.
  ApiCallResponse? transRes;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Custom Action - editImage] action in Image widget.
  FFUploadedFile? editRes;
  // Stores action output result for [Custom Action - editImage] action in Image widget.
  FFUploadedFile? editGRes;
  bool isDataUploading1 = false;
  FFUploadedFile uploadedLocalFile1 =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  bool isDataUploading2 = false;
  List<FFUploadedFile> uploadedLocalFiles2 = [];

  // Stores action output result for [Custom Action - uploadedFileToJson] action in Button widget.
  dynamic? upRes;
  // Stores action output result for [Custom Action - uploadedFileToJson] action in Button widget.
  dynamic? galRes;
  // Model for Sidebar component.
  late SidebarModel sidebarModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    sidebarModel = createModel(context, () => SidebarModel());
  }

  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();

    sidebarModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
