// import 'package:fifa_on4_bank/core/model/table/table_cell_property.dart';
// import 'package:flutter/material.dart';

// /// Table with sticky headers. Whenever you scroll content horizontally
// /// or vertically - top and left headers always stay.
// class StickyHeadersTable extends StatefulWidget {
//   StickyHeadersTable({
//     Key key,

//     /// Number of Columns (for content only)
//     @required this.columnsLength,

//     /// Number of Rows (for content only)
//     @required this.rowsLength,

//     /// Title for Top Left cell (always visible)
//     //this.legendCell = const Text(' '),

//     /// Builder for column titles. Takes index of content column as parameter
//     /// and returns String for column title
//     @required this.columnsTitleBuilder,

//     /// Builder for row titles. Takes index of content row as parameter
//     /// and returns String for row title
//     @required this.rowsTitleBuilder,

//     /// Builder for content cell. Takes index for content column first,
//     /// index for content row second and returns String for cell
//     @required this.contentCellBuilder,

//     @required this.legendLength,

//     @required this.legendTitleBuilder,

//     @required this.headerProperties,
//     @required this.contentProperties,

//     /// Table cell dimensions
//     //this.cellDimensions = CellDimensions.base,

//     /// Type of fit for content
//     this.cellFit = BoxFit.scaleDown,
//   }) : super(key: key) {
//     assert(columnsLength != null);
//     assert(rowsLength != null);
//     assert(columnsTitleBuilder != null);
//     assert(rowsTitleBuilder != null);
//     assert(contentCellBuilder != null);
//     assert(legendTitleBuilder != null);
//   }

//   final int rowsLength;
//   final int columnsLength;
//   //final Widget legendCell;
//   final Widget Function(int colulmnIndex) columnsTitleBuilder;
//   final Widget Function(int columnIndex, int rowIndex) rowsTitleBuilder;
//   final Widget Function(int columnIndex, int rowIndex) contentCellBuilder;
//   final BoxFit cellFit;
//   //---------------------------
//   final int legendLength;
//   final Widget Function(int legendIndex) legendTitleBuilder;
//   final List<TableCellProperty> headerProperties;
//   final List<TableCellProperty> contentProperties;

//   @override
//   _StickyHeadersTableState createState() => _StickyHeadersTableState();
// }

// class _StickyHeadersTableState extends State<StickyHeadersTable> {
//   final ScrollController _verticalTitleController = ScrollController();
//   final ScrollController _verticalBodyController = ScrollController();

//   final ScrollController _horizontalBodyController = ScrollController();
//   final ScrollController _horizontalTitleController = ScrollController();

//   _SyncScrollController _verticalSyncController;
//   _SyncScrollController _horizontalSyncController;

//   @override
//   void initState() {
//     super.initState();
//     _verticalSyncController = _SyncScrollController(
//         [_verticalTitleController, _verticalBodyController]);
//     _horizontalSyncController = _SyncScrollController(
//         [_horizontalTitleController, _horizontalBodyController]);
//   }

//   List<Widget> _buildLegendHeader() {
//     return List.generate(
//       widget.legendLength, (i) => Container(
//           width: widget.headerProperties[i].width,
//           height: widget.headerProperties[i].height,
//           child: FittedBox(
//             fit: widget.cellFit,
//             child: widget.legendTitleBuilder(i)
//           ),
//         ),
//     );
//   }

//   Widget _buildHeader() {
//     return Expanded(
//       child: NotificationListener<ScrollNotification>(
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: List.generate(
//               widget.columnsLength,
//                   (i) => Visibility(
//                     visible: widget.headerProperties[i].isVisible,
//                     child: Container(
//                 width: widget.headerProperties[i].width,
//                 height: widget.headerProperties[i].height,
//                 child: FittedBox(
//                     fit: widget.cellFit,
//                     child: widget.columnsTitleBuilder(i),
//                 ),
//               ),
//                   ),
//             ),
//           ),
//           controller: _horizontalTitleController,
//         ),
//         onNotification: (ScrollNotification notification) {
//           _horizontalSyncController.processNotification(
//               notification, _horizontalTitleController);
//           return true;
//         },
//       ),
//     );
//   }

//   List<Widget> _buildLegendContent(int columnIndex) {
//     return List.generate(
//       widget.legendLength, (j) => Container(
//         width: widget.headerProperties[j].width,
//         height: widget.contentProperties[j].height,
//         child: FittedBox(
//           fit: widget.cellFit,
//           child: widget.rowsTitleBuilder(j, columnIndex),
//           //child : widget.contentCellBuilder(j, columnIndex)
//           //child: Text('$i'),
//         ),
//       )
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Row(
//           children: <Widget>[
//             // STICKY LEGEND
//             // if (widget.isCheckBox) 
//             // _buildCheckBoxHeader(),
//             // STICKY ROW
//             //..._buildLegendHeader(),
//             _buildHeader(),
//           ],
//         ),
//         //---------------------------------------------------
//         Expanded(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               NotificationListener<ScrollNotification>(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: List.generate(
//                       widget.rowsLength,
//                       (i) => Row(
//                         children: <Widget>[
//                           // if (widget.isCheckBox) 
//                           // _buildCheckBoxContent(i),
//                           ..._buildLegendContent(i),
//                           //---------------------------------
//                         ],
//                       ),
//                     ),
//                   ),
//                   controller: _verticalTitleController,
//                 ),
//                 onNotification: (ScrollNotification notification) {
//                   _verticalSyncController.processNotification(
//                       notification, _verticalTitleController);
//                   return true;
//                 },
//               ),
//               // CONTENT
//               Expanded(
//                 child: NotificationListener<ScrollNotification>(
//                   onNotification: (ScrollNotification notification) {
//                     _horizontalSyncController.processNotification(
//                         notification, _horizontalBodyController);
//                     return true;
//                   },
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     controller: _horizontalBodyController,
//                     child: NotificationListener<ScrollNotification>(
//                       child: SingleChildScrollView(
//                         controller: _verticalBodyController,
//                           child: Column(
//                             children: List.generate(
//                               widget.rowsLength + 1,
//                                   (int i) {
//                                     // floationg action button과 겹치기 때문에 빈 공간 삽입
//                                     if ( i == widget.rowsLength) {
//                                       return SizedBox(height: 128.0,);
//                                     }

//                                     return Row(
//                                       children: List.generate(
//                                         widget.columnsLength,
//                                             (int j) {
//                                               return Visibility(
//                                                 visible: widget.headerProperties[j].isVisible,
//                                                 child: Container(
//                                                   width: widget.headerProperties[j].width,
//                                                   height: widget.contentProperties[j].height,
//                                                   child: FittedBox(
//                                                     fit: widget.cellFit,
//                                                     child: widget.contentCellBuilder(j+widget.legendLength, i),
//                                                   ),
//                                                 ),
//                                               );
//                                             } ,
//                                       ),
//                                     );
//                                   },
//                             ),
//                           )
//                         ),
//                       onNotification: (ScrollNotification notification) {
//                         _verticalSyncController.processNotification(
//                             notification, _verticalBodyController);
//                         return true;
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// /// Dimensions for table
// class CellDimensions {
//   const CellDimensions({
//     /// Content cell width. It also applied to sticky row width.
//     @required this.contentCellWidth,

//     /// Content cell height. It also applied to sticky column height.
//     @required this.contentCellHeight,

//     /// Sticky legend width. It also applied to sticky column width.
//     @required this.stickyLegendWidth,

//     /// Sticky legend height/ It also applied to sticky row height.
//     @required this.stickyLegendHeight,
//   }) : this.checkeBoxWidth = 42.0;

//   final double contentCellWidth;
//   final double contentCellHeight;
//   final double stickyLegendWidth;
//   final double stickyLegendHeight;
//   final double checkeBoxWidth;

//   static const CellDimensions base = CellDimensions(
//     contentCellWidth: 120.0,
//     contentCellHeight: 74.0,
//     stickyLegendWidth: 120.0,
//     stickyLegendHeight: 74.0,
//   );
// }

// /// SyncScrollController keeps scroll controllers in sync.
// class _SyncScrollController {
//   _SyncScrollController(List<ScrollController> controllers) {
//     controllers
//         .forEach((controller) => _registeredScrollControllers.add(controller));
//   }

//   final List<ScrollController> _registeredScrollControllers = [];

//   ScrollController _scrollingController;
//   bool _scrollingActive = false;

//   processNotification(
//       ScrollNotification notification, ScrollController sender) {
//     if (notification is ScrollStartNotification && !_scrollingActive) {
//       _scrollingController = sender;
//       _scrollingActive = true;
//       return;
//     }

//     if (identical(sender, _scrollingController) && _scrollingActive) {
//       if (notification is ScrollEndNotification) {
//         _scrollingController = null;
//         _scrollingActive = false;
//         return;
//       }

//       if (notification is ScrollUpdateNotification) {
//         for (ScrollController controller in _registeredScrollControllers) {
//           if (identical(_scrollingController, controller)) continue;
//           controller.jumpTo(_scrollingController.offset);
//         }
//       }
//     }
//   }
// }