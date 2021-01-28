import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/search_model.dart';
import 'package:parkinson_de_bolso/widget/custom_background.dart';

class CustomListSearch extends StatefulWidget {
  final String widgetName;
  final Color barColor;
  final Function searchStatusController;
  final Function scrollStatusController;
  final Function onTap;
  final List<IconButton> actions;
  final Future future;

  CustomListSearch({ @required this.widgetName, @required this.barColor, @required this.searchStatusController, @required this.scrollStatusController, @required this.onTap, this.actions, @required this.future});
  
  @override
  _CustomListSearchState createState() => _CustomListSearchState();
}

class _CustomListSearchState extends State<CustomListSearch> {
  List<SearchModel> _data;
  ScrollController _scrollController;
  List<SearchModel> _cachedData;
  Widget _malleableWidget;
  Icon _malleableIcon;
  bool _loaded;

  @override
  void initState() {
    this._data = <SearchModel>[];
    this._cachedData = <SearchModel>[];
    this._buildTextTitle();
    this._scrollController = ScrollController();
    this._loaded = false;
    this._scrollController.addListener(() {
      bool status = this._scrollController.position.userScrollDirection == ScrollDirection.reverse;
      Function.apply(this.widget.scrollStatusController, [status]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: this._malleableWidget,
        backgroundColor: this.widget.barColor,
        actions: [
          IconButton(
            icon: this._malleableIcon, 
            onPressed: () {
              if (this._malleableIcon.icon == Icons.search) {
                this._buildSearchField();
              } else {
                this._buildTextTitle();
              }
              this.widget.searchStatusController.call();
            },
          )          
        ]..addAll((this.widget.actions == null) ? [] : this.widget.actions),
      ),
      body: CustomBackground(
        margin: 10.0,
        topColor: dashboardBarColor, 
        bottomColor: ternaryColor, 
        bottom: Container(
          child: FutureBuilder(
            future: this.widget.future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                this._data = snapshot.data;
                if (!this._loaded)
                  WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => this._cachedData = this._data));
                return ListView.builder(
                  controller: this._scrollController,
                  shrinkWrap: true,
                  itemCount: this._cachedData.length,
                  itemBuilder: (context, index) {
                    return this._cachedData[index].getListTile(this.widget.onTap);
                  }
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        horizontalPadding: 10.0
      ),
    );
  }
  
  void _onItemChanged(String query) {
    if (query.isNotEmpty) {
      setState(() {
        this._cachedData = this._data
            .where((element) => removeDiacritics(element.searchText()).toLowerCase().contains(removeDiacritics(query.toString()).toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        this._cachedData.clear();
        this._cachedData.addAll(this._data);
      });
    }
  }

  void _buildTextTitle() {
    setState(() {
      this._malleableIcon = Icon(Icons.search);
      this._malleableWidget = Text(this.widget.widgetName);
      this._cachedData = this._data;
    });
  }

  void _buildSearchField() {
    setState(() {
      this._loaded = true;
      this._malleableIcon = Icon(Icons.cancel);
      this._malleableWidget = TextField(
        autofocus: true,
        textInputAction: TextInputAction.go,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.white
          ),
          hintText: 'Pesquisar'
        ),
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0
        ),
        onChanged: (value) => this._onItemChanged(value)
      );
    });
  }
}