import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'language_select_model.dart';
export 'language_select_model.dart';

class LanguageSelectWidget extends StatefulWidget {
  const LanguageSelectWidget({super.key});

  @override
  State<LanguageSelectWidget> createState() => _LanguageSelectWidgetState();
}

class _LanguageSelectWidgetState extends State<LanguageSelectWidget> {
  late LanguageSelectModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LanguageSelectModel());

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

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
            child: FlutterFlowDropDown<String>(
              controller: _model.dropDownValueController ??=
                  FormFieldController<String>(
                _model.dropDownValue ??= FFAppState().language,
              ),
              options: List<String>.from(['en-IN', 'hi-IN', 'mr-IN', 'ta-IN']),
              optionLabels: [
                FFLocalizations.of(context).getText(
                  'f8pknwau' /* English */,
                ),
                FFLocalizations.of(context).getText(
                  'g1qxfofz' /* Hindi */,
                ),
                FFLocalizations.of(context).getText(
                  'fdldtqcn' /* Marathi */,
                ),
                FFLocalizations.of(context).getText(
                  'qj5bcyg5' /* Tamil */,
                )
              ],
              onChanged: (val) async {
                setState(() => _model.dropDownValue = val);
                logFirebaseEvent('LANGUAGE_SELECT_DropDown_kslcldjw_ON_FOR');
                logFirebaseEvent('DropDown_update_app_state');
                setState(() {
                  FFAppState().language = _model.dropDownValue!;
                });
              },
              width: 300.0,
              height: 50.0,
              textStyle: FlutterFlowTheme.of(context).bodyMedium,
              hintText: FFLocalizations.of(context).getText(
                'jvngwzz8' /* Select Language */,
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 24.0,
              ),
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
              elevation: 2.0,
              borderColor: FlutterFlowTheme.of(context).alternate,
              borderWidth: 2.0,
              borderRadius: 8.0,
              margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
              hidesUnderline: true,
              isOverButton: true,
              isSearchable: false,
              isMultiSelect: false,
            ),
          ),
        ),
      ],
    );
  }
}
