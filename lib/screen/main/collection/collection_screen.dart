import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liriku/bloc/collection/bloc.dart';
import 'package:liriku/injector_widget.dart';
import 'package:liriku/localizations.dart';
import 'package:liriku/resource/colors.dart';
import 'package:liriku/screen/main/collection/collection_list.dart';
import 'package:liriku/screen/main/collection/selector_list.dart';

class CollectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectorBloc = InjectorWidget.of(context).selectorBLoc();
    final searchBloc = InjectorWidget.of(context).searchCollectionBloc();
    final collectionBloc = InjectorWidget.of(context).collectionBloc();

    return BlocBuilder<SearchEvent, SearchState>(
      bloc: searchBloc,
      builder: (BuildContext context, SearchState state) {
        return Scaffold(
          appBar: AppBar(
            title: state is SearchVisible
                ? Container()
                : Text(AppLocalizations.of(context).collection),
            actions: <Widget>[
              state is SearchVisible
                  ? Expanded(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: IconButton(
                              icon: Icon(Icons.clear, color: primaryDark),
                              onPressed: () {
                                searchBloc.dispatch(CloseSearchForm());
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 16),
                              padding: EdgeInsets.symmetric(vertical: 6)
                                  .copyWith(right: 16),
                              child: _SearchForm(bloc: searchBloc),
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
              state is SearchVisible
                  ? Container()
                  : IconButton(
                      icon: Icon(Icons.search, color: primaryDark),
                      onPressed: () {
                        searchBloc.dispatch(ShowSearchForm());
                      },
                    ),
            ],
          ),
          body: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Container(
                  width: 52,
                  child: SelectorList(
                    bloc: selectorBloc,
                  ),
                ),
              ),
              Expanded(
                child: CollectionList(
                  bloc: collectionBloc,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SearchForm extends StatefulWidget {
  final SearchBloc bloc;

  const _SearchForm({Key key, this.bloc}) : super(key: key);

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<_SearchForm> {
  SearchBloc get bloc => widget.bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey[200],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: AppLocalizations.of(context).search,
          hintStyle: TextStyle(fontWeight: FontWeight.w500),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (text) {
          bloc.dispatch(OnSearch(keyword: text));
        },
      ),
    );
  }
}
