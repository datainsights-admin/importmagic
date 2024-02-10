import '/components/view_source_card/view_source_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'view_source_b_s_model.dart';
export 'view_source_b_s_model.dart';

class ViewSourceBSWidget extends StatefulWidget {
  const ViewSourceBSWidget({
    super.key,
    required this.fileSource,
  });

  final List<String>? fileSource;

  @override
  State<ViewSourceBSWidget> createState() => _ViewSourceBSWidgetState();
}

class _ViewSourceBSWidgetState extends State<ViewSourceBSWidget> {
  late ViewSourceBSModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViewSourceBSModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                final fileSourceList = widget.fileSource!.toList();
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  itemCount: fileSourceList.length,
                  itemBuilder: (context, fileSourceListIndex) {
                    final fileSourceListItem =
                        fileSourceList[fileSourceListIndex];
                    return wrapWithModel(
                      model: _model.viewSourceCardModels.getModel(
                        fileSourceListItem,
                        fileSourceListIndex,
                      ),
                      updateCallback: () => setState(() {}),
                      child: ViewSourceCardWidget(
                        key: Key(
                          'Keyzdz_${fileSourceListItem}',
                        ),
                        image:
                            functions.getImagePathFromPath(fileSourceListItem),
                        audio:
                            functions.getAudioPathFromPath(fileSourceListItem),
                        name: fileSourceListItem,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
