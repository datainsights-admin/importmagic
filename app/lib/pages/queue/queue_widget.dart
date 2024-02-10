import '/backend/api_requests/api_calls.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/components/upload_image/upload_image_widget.dart';
import '/components/upload_text/upload_text_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'queue_model.dart';
export 'queue_model.dart';

class QueueWidget extends StatefulWidget {
  const QueueWidget({super.key});

  @override
  State<QueueWidget> createState() => _QueueWidgetState();
}

class _QueueWidgetState extends State<QueueWidget>
    with TickerProviderStateMixin {
  late QueueModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QueueModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'Queue'});
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    context.watch<FFAppState>();

    return Title(
        title: 'Queue',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              drawer: Drawer(
                elevation: 16.0,
                child: wrapWithModel(
                  model: _model.sidebarModel,
                  updateCallback: () => setState(() {}),
                  child: SidebarWidget(),
                ),
              ),
              appBar: AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                iconTheme: IconThemeData(
                    color: FlutterFlowTheme.of(context).primaryText),
                automaticallyImplyLeading: true,
                title: Text(
                  FFLocalizations.of(context).getText(
                    'ckgdzhtt' /* Queue */,
                  ),
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 22.0,
                      ),
                ),
                actions: [],
                flexibleSpace: FlexibleSpaceBar(
                  background: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/import_magic_login_page.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                centerTitle: false,
                elevation: 2.0,
              ),
              body: SafeArea(
                top: true,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment(0.0, 0),
                        child: TabBar(
                          labelColor: FlutterFlowTheme.of(context).primaryText,
                          unselectedLabelColor:
                              FlutterFlowTheme.of(context).secondaryText,
                          labelStyle: FlutterFlowTheme.of(context).titleMedium,
                          unselectedLabelStyle: TextStyle(),
                          indicatorColor:
                              FlutterFlowTheme.of(context).primaryText,
                          padding: EdgeInsets.all(4.0),
                          tabs: [
                            Tab(
                              text: FFLocalizations.of(context).getText(
                                'pluezd9j' /* Text */,
                              ),
                            ),
                            Tab(
                              text: FFLocalizations.of(context).getText(
                                'ee8d7igl' /* Image */,
                              ),
                            ),
                          ],
                          controller: _model.tabBarController,
                          onTap: (i) async {
                            [() async {}, () async {}][i]();
                          },
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _model.tabBarController,
                          children: [
                            Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Builder(
                                      builder: (context) {
                                        final toBeUploadText = FFAppState()
                                            .pendingAudioText
                                            .toList();
                                        return ListView.builder(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.vertical,
                                          itemCount: toBeUploadText.length,
                                          itemBuilder:
                                              (context, toBeUploadTextIndex) {
                                            final toBeUploadTextItem =
                                                toBeUploadText[
                                                    toBeUploadTextIndex];
                                            return wrapWithModel(
                                              model: _model.uploadTextModels
                                                  .getModel(
                                                toBeUploadTextItem,
                                                toBeUploadTextIndex,
                                              ),
                                              updateCallback: () =>
                                                  setState(() {}),
                                              child: UploadTextWidget(
                                                key: Key(
                                                  'Keyjsa_${toBeUploadTextItem}',
                                                ),
                                                text: toBeUploadTextItem,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: LinearPercentIndicator(
                                      percent: valueOrDefault<double>(
                                        (int index, int total) {
                                          return total > 0
                                              ? ((index + 0.0) / total)
                                              : 0.0;
                                        }(_model.index, _model.indexTotal!),
                                        0.0,
                                      ),
                                      lineHeight: 16.0,
                                      animation: true,
                                      animateFromLastPercent: true,
                                      progressColor:
                                          FlutterFlowTheme.of(context)
                                              .primaryText,
                                      backgroundColor:
                                          FlutterFlowTheme.of(context).accent4,
                                      barRadius: Radius.circular(32.0),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        32.0, 8.0, 32.0, 32.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        logFirebaseEvent(
                                            'QUEUE_PAGE_UPLOAD_BTN_ON_TAP');
                                        var _shouldSetState = false;
                                        if (FFAppState()
                                            .pendingAudioText
                                            .isNotEmpty) {
                                          logFirebaseEvent(
                                              'Button_action_block');
                                          await action_blocks
                                              .preRequestInterceptor(context);
                                          logFirebaseEvent(
                                              'Button_update_page_state');
                                          setState(() {
                                            _model.index = 0;
                                            _model.indexTotal = FFAppState()
                                                .pendingAudioText
                                                .length;
                                          });
                                          while (_model.index <
                                              _model.indexTotal!) {
                                            logFirebaseEvent(
                                                'Button_backend_call');
                                            _model.apiResult9ho =
                                                await AppCall.call(
                                              action: 'text-upload',
                                              text:
                                                  FFAppState().pendingAudioText[
                                                      _model.index],
                                              token: FFAppState().token,
                                            );
                                            _shouldSetState = true;
                                            if ((_model
                                                    .apiResult9ho?.succeeded ??
                                                true)) {
                                              logFirebaseEvent(
                                                  'Button_update_app_state');
                                              setState(() {
                                                FFAppState()
                                                    .removeAtIndexFromPendingAudioText(
                                                        0);
                                              });
                                              logFirebaseEvent(
                                                  'Button_update_page_state');
                                              setState(() {
                                                _model.index = _model.index + 1;
                                              });
                                            } else {
                                              logFirebaseEvent(
                                                  'Button_show_snack_bar');
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Some Error Occured',
                                                    style: TextStyle(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                    ),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                ),
                                              );
                                              logFirebaseEvent(
                                                  'Button_update_page_state');
                                              setState(() {
                                                _model.index = 0;
                                              });
                                              if (_shouldSetState)
                                                setState(() {});
                                              return;
                                            }
                                          }
                                          logFirebaseEvent(
                                              'Button_show_snack_bar');
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Upload Completed',
                                                style: TextStyle(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                ),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 4000),
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                          );
                                          logFirebaseEvent(
                                              'Button_action_block');
                                          await action_blocks
                                              .processData(context);
                                          logFirebaseEvent(
                                              'Button_update_page_state');
                                          setState(() {
                                            _model.index = 0;
                                          });
                                        } else {
                                          logFirebaseEvent(
                                              'Button_show_snack_bar');
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Nothing to Upload',
                                                style: TextStyle(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                ),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 4000),
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                          );
                                        }

                                        if (_shouldSetState) setState(() {});
                                      },
                                      text: FFLocalizations.of(context).getText(
                                        'icmbkrbf' /* Upload */,
                                      ),
                                      icon: Icon(
                                        Icons.upload,
                                        size: 15.0,
                                      ),
                                      options: FFButtonOptions(
                                        width: 300.0,
                                        height: 40.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14.0,
                                            ),
                                        elevation: 3.0,
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Builder(
                                      builder: (context) {
                                        final toBeUploadImage =
                                            FFAppState().pendingImages.toList();
                                        return ListView.builder(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.vertical,
                                          itemCount: toBeUploadImage.length,
                                          itemBuilder:
                                              (context, toBeUploadImageIndex) {
                                            final toBeUploadImageItem =
                                                toBeUploadImage[
                                                    toBeUploadImageIndex];
                                            return wrapWithModel(
                                              model: _model.uploadImageModels
                                                  .getModel(
                                                getJsonField(
                                                  toBeUploadImageItem,
                                                  r'''$["name"]''',
                                                ).toString(),
                                                toBeUploadImageIndex,
                                              ),
                                              updateCallback: () =>
                                                  setState(() {}),
                                              child: UploadImageWidget(
                                                key: Key(
                                                  'Keybdk_${getJsonField(
                                                    toBeUploadImageItem,
                                                    r'''$["name"]''',
                                                  ).toString()}',
                                                ),
                                                imageJson: toBeUploadImageItem,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: LinearPercentIndicator(
                                      percent: valueOrDefault<double>(
                                        (int index, int total) {
                                          return total > 0
                                              ? ((index + 0.0) / total)
                                              : 0.0;
                                        }(_model.indexImg,
                                            _model.imgIndexTotal!),
                                        0.0,
                                      ),
                                      lineHeight: 16.0,
                                      animation: true,
                                      animateFromLastPercent: true,
                                      progressColor:
                                          FlutterFlowTheme.of(context)
                                              .primaryText,
                                      backgroundColor:
                                          FlutterFlowTheme.of(context).accent4,
                                      barRadius: Radius.circular(32.0),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        32.0, 8.0, 32.0, 32.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        logFirebaseEvent(
                                            'QUEUE_PAGE_UPLOAD_BTN_ON_TAP');
                                        var _shouldSetState = false;
                                        if (FFAppState()
                                            .pendingImages
                                            .isNotEmpty) {
                                          logFirebaseEvent(
                                              'Button_action_block');
                                          await action_blocks
                                              .preRequestInterceptor(context);
                                          logFirebaseEvent(
                                              'Button_update_page_state');
                                          setState(() {
                                            _model.indexImg = 0;
                                            _model.imgIndexTotal = FFAppState()
                                                .pendingImages
                                                .length;
                                          });
                                          while (_model.indexImg <
                                              _model.imgIndexTotal!) {
                                            logFirebaseEvent(
                                                'Button_custom_action');
                                            _model.iimRes = await actions
                                                .jsonToUploadedFile(
                                              FFAppState().pendingImages[0],
                                            );
                                            _shouldSetState = true;
                                            logFirebaseEvent(
                                                'Button_backend_call');
                                            _model.apiResult9hos =
                                                await AppCall.call(
                                              action: 'image-upload',
                                              imageFile: _model.iimRes,
                                              token: FFAppState().token,
                                            );
                                            _shouldSetState = true;
                                            if ((_model
                                                    .apiResult9hos?.succeeded ??
                                                true)) {
                                              logFirebaseEvent(
                                                  'Button_update_app_state');
                                              setState(() {
                                                FFAppState()
                                                    .removeAtIndexFromPendingImages(
                                                        0);
                                              });
                                              logFirebaseEvent(
                                                  'Button_update_page_state');
                                              setState(() {
                                                _model.indexImg =
                                                    _model.indexImg + 1;
                                              });
                                            } else {
                                              logFirebaseEvent(
                                                  'Button_show_snack_bar');
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Some Error Occured',
                                                    style: TextStyle(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                    ),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .error,
                                                ),
                                              );
                                              logFirebaseEvent(
                                                  'Button_update_page_state');
                                              setState(() {
                                                _model.indexImg = 0;
                                              });
                                              if (_shouldSetState)
                                                setState(() {});
                                              return;
                                            }
                                          }
                                          logFirebaseEvent(
                                              'Button_show_snack_bar');
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Upload Completed',
                                                style: TextStyle(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                ),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 4000),
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                          );
                                          logFirebaseEvent(
                                              'Button_action_block');
                                          await action_blocks
                                              .processData(context);
                                          logFirebaseEvent(
                                              'Button_update_page_state');
                                          setState(() {
                                            _model.indexImg = 0;
                                          });
                                        } else {
                                          logFirebaseEvent(
                                              'Button_show_snack_bar');
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Nothing to Upload',
                                                style: TextStyle(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                ),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 4000),
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                          );
                                        }

                                        if (_shouldSetState) setState(() {});
                                      },
                                      text: FFLocalizations.of(context).getText(
                                        'qf33jqk5' /* Upload */,
                                      ),
                                      icon: Icon(
                                        Icons.upload,
                                        size: 15.0,
                                      ),
                                      options: FFButtonOptions(
                                        width: 300.0,
                                        height: 40.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14.0,
                                            ),
                                        elevation: 3.0,
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
