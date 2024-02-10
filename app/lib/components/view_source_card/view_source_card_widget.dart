import '/flutter_flow/flutter_flow_audio_player.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'view_source_card_model.dart';
export 'view_source_card_model.dart';

class ViewSourceCardWidget extends StatefulWidget {
  const ViewSourceCardWidget({
    super.key,
    required this.image,
    required this.audio,
    required this.name,
  });

  final String? image;
  final String? audio;
  final String? name;

  @override
  State<ViewSourceCardWidget> createState() => _ViewSourceCardWidgetState();
}

class _ViewSourceCardWidgetState extends State<ViewSourceCardWidget> {
  late ViewSourceCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViewSourceCardModel());

    _model.textController ??= TextEditingController(text: widget.name);
    _model.textFieldFocusNode ??= FocusNode();

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
          if (functions.isImageFile(widget.name!) ?? true)
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.image!,
                  height: 400.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (functions.isAudioFile(widget.name!) ?? true)
            Padding(
              padding: EdgeInsets.all(16.0),
              child: FlutterFlowAudioPlayer(
                audio: Audio.network(
                  widget.audio!,
                  metas: Metas(
                    id: '2vqf7_-d3d36ce3',
                    title: 'Recoding',
                  ),
                ),
                titleTextStyle: FlutterFlowTheme.of(context).titleLarge,
                playbackDurationTextStyle:
                    FlutterFlowTheme.of(context).labelMedium,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                playbackButtonColor: FlutterFlowTheme.of(context).primaryText,
                activeTrackColor: FlutterFlowTheme.of(context).alternate,
                elevation: 4.0,
                playInBackground: PlayInBackground.disabledRestoreOnForeground,
              ),
            ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (!functions.isAudioFile(widget.name!)! &&
                  !functions.isImageFile(widget.name!)!)
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                    child: TextFormField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      readOnly: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: FFLocalizations.of(context).getText(
                          'vydoahb2' /* Source */,
                        ),
                        labelStyle: FlutterFlowTheme.of(context).labelMedium,
                        hintStyle: FlutterFlowTheme.of(context).labelMedium,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x0014181B),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x004B39EF),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: Icon(
                          Icons.description,
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      textAlign: TextAlign.start,
                      maxLines: 30,
                      minLines: 1,
                      validator:
                          _model.textControllerValidator.asValidator(context),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
