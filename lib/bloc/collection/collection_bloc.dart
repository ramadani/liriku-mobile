import 'package:bloc/bloc.dart';
import 'package:liriku/bloc/collection/collection_event.dart';
import 'package:liriku/bloc/collection/collection_state.dart';
import 'package:liriku/data/repository/artist_repository.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final ArtistRepository _artistRepository;

  CollectionBloc(this._artistRepository);

  @override
  CollectionState get initialState => CollectionUninitialized();

  @override
  Stream<CollectionState> mapEventToState(CollectionEvent event) async* {
    if (event is FetchCollection) {
      yield* _mapFetchToState(event);
    } else if (event is FetchMoreCollection &&
        currentState is CollectionLoaded) {
      yield* _mapFetchMoreToState(currentState as CollectionLoaded);
    }
  }

  Stream<CollectionState> _mapFetchToState(FetchCollection event) async* {
    try {
      yield CollectionLoading();

      final result = await _artistRepository.paginate(
          page: event.page, perPage: event.perPage);
      yield CollectionLoaded(
        id: event.id,
        artists: result.artists,
        page: result.page,
        perPage: result.perPage,
        hasMorePages: result.artists.length == event.perPage,
        fetchingMore: false,
      );
    } catch (_) {
      yield CollectionError();
    }
  }

  Stream<CollectionState> _mapFetchMoreToState(CollectionLoaded state) async* {
    try {
      yield state.setFetchingMore();

      final result = await _artistRepository.paginate(
        page: state.page + 1,
        perPage: state.perPage,
      );

      yield state.fetchedMore(
        page: result.page,
        newArtists: result.artists,
        hasMorePages: result.artists.length == state.perPage,
      );
    } catch (_) {
      yield CollectionError();
    }
  }
}
