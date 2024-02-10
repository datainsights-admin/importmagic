import '/backend/schema/structs/index.dart';
import '/components/product_library_card/product_library_card_widget.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/actions/actions.dart' as action_blocks;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'product_library_model.dart';
export 'product_library_model.dart';

class ProductLibraryWidget extends StatefulWidget {
  const ProductLibraryWidget({super.key});

  @override
  State<ProductLibraryWidget> createState() => _ProductLibraryWidgetState();
}

class _ProductLibraryWidgetState extends State<ProductLibraryWidget> {
  late ProductLibraryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductLibraryModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'ProductLibrary'});
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
        title: 'Library',
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
                    'h4lqutfz' /* Library */,
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
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final products =
                                FFAppState().globalProducts.toList();
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: products.length,
                              itemBuilder: (context, productsIndex) {
                                final productsItem = products[productsIndex];
                                return wrapWithModel(
                                  model:
                                      _model.productLibraryCardModels.getModel(
                                    productsItem.id,
                                    productsIndex,
                                  ),
                                  updateCallback: () => setState(() {}),
                                  child: ProductLibraryCardWidget(
                                    key: Key(
                                      'Keyfg3_${productsItem.id}',
                                    ),
                                    name: productsItem.uniqueProductName,
                                    brand: productsItem.brand,
                                    size: productsItem.size,
                                    price: productsItem.price,
                                    description:
                                        productsItem.productDescription,
                                    id: productsItem.id,
                                    source: productsItem.sourceFile,
                                    content: productsItem.content,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            8.0, 16.0, 8.0, 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FFButtonWidget(
                              onPressed: () async {
                                logFirebaseEvent(
                                    'PRODUCT_LIBRARY_PAGE_REFRESH_BTN_ON_TAP');
                                logFirebaseEvent('Button_action_block');
                                await action_blocks
                                    .preRequestInterceptor(context);
                                logFirebaseEvent('Button_action_block');
                                await action_blocks.refreshData(
                                  context,
                                  local: false,
                                  global: true,
                                  history: false,
                                );
                              },
                              text: FFLocalizations.of(context).getText(
                                'pvkoi7o8' /* Refresh */,
                              ),
                              icon: Icon(
                                Icons.edit_road,
                                size: 15.0,
                              ),
                              options: FFButtonOptions(
                                width: 300.0,
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 14.0,
                                    ),
                                elevation: 3.0,
                                borderSide: BorderSide(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
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
