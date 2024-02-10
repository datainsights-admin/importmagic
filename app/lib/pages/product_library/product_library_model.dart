import '/backend/schema/structs/index.dart';
import '/components/product_library_card/product_library_card_widget.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/actions/actions.dart' as action_blocks;
import 'product_library_widget.dart' show ProductLibraryWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductLibraryModel extends FlutterFlowModel<ProductLibraryWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Models for ProductLibraryCard dynamic component.
  late FlutterFlowDynamicModels<ProductLibraryCardModel>
      productLibraryCardModels;
  // Model for Sidebar component.
  late SidebarModel sidebarModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    productLibraryCardModels =
        FlutterFlowDynamicModels(() => ProductLibraryCardModel());
    sidebarModel = createModel(context, () => SidebarModel());
  }

  void dispose() {
    unfocusNode.dispose();
    productLibraryCardModels.dispose();
    sidebarModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
