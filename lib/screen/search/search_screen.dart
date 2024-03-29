import 'package:flutter/material.dart';
import 'package:liriku/bloc/search/bloc.dart';
import 'package:liriku/bloc/search/search_form_event.dart';
import 'package:liriku/injector_widget.dart';
import 'package:liriku/localizations.dart';
import 'package:liriku/screen/search/artist_page.dart';
import 'package:liriku/screen/search/songs_page.dart';
import 'package:meta/meta.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _changePage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _jumpToPage(int page) {
    _pageController.animateToPage(
      page,
      curve: Curves.decelerate,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchFormBloc = InjectorWidget.of(context).searchFormBloc();
    final lyricBloc = InjectorWidget.of(context).lyricListBloc();
    final artistBloc = InjectorWidget.of(context).artistListBloc();

    return Scaffold(
      appBar: AppBar(
        title: _SearchForm(bloc: searchFormBloc),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                _Tab(
                  label: AppLocalizations.of(context).songs,
                  selected: _currentPage == 0,
                  onTap: () {
                    _changePage(0);
                    _jumpToPage(0);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: _Tab(
                    label: AppLocalizations.of(context).artists,
                    selected: _currentPage == 1,
                    onTap: () {
                      _changePage(1);
                      _jumpToPage(1);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) => _changePage(page),
        children: <Widget>[
          SongPage(bloc: lyricBloc),
          ArtistPage(bloc: artistBloc),
        ],
      ),
    );
  }
}

class _SearchForm extends StatefulWidget {
  final SearchFormBloc bloc;

  const _SearchForm({Key key, this.bloc}) : super(key: key);

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<_SearchForm> {
  @override
  void initState() {
    super.initState();
    widget.bloc.dispatch(SearchFromSubmitted(keyword: ''));
  }

  @override
  void dispose() {
    widget.bloc.dispatch(ResetSearchForm());
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
        autofocus: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: AppLocalizations.of(context).search,
          hintStyle: TextStyle(fontWeight: FontWeight.w500),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (text) {
          widget.bloc.dispatch(SearchFromSubmitted(keyword: text));
        },
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final GestureTapCallback onTap;

  const _Tab({Key key, this.label, this.selected, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = selected ? Theme.of(context).primaryColor : Colors.grey[400];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: UnderlineTabIndicator(
          borderSide: BorderSide(color: color, width: 3),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
