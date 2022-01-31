import 'package:flutter/material.dart';
import 'package:peliculasapp/models/models.dart';
import 'package:peliculasapp/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate{

  @override
  String? get searchFieldLabel => 'Buscar Pelicula';
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: (){
          query = '';
        }, 
        icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context, null);
      }, 
      icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  Widget _emptyContainer(){
    return const  Center(
        child: Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 150),
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if(query.isEmpty){
      return _emptyContainer();
    }

    final movieProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: movieProvider.searhMovies(query),
      builder: (_, AsyncSnapshot<List<Movie>> snapshot){
        if(!snapshot.hasData) return _emptyContainer();

        return ListView.builder(
          itemCount: snapshot.data?.length,
          itemBuilder: (_, int index) => _MovieItem(movie: snapshot.data![index]) );
      },
    );

  }
}

class _MovieItem extends StatelessWidget {

  final Movie movie;
  const _MovieItem({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FadeInImage(
        placeholder: const AssetImage('assets/images/no-image.jpg'), 
        image: NetworkImage(movie.fullPosterImg),
        width: 50,
        fit: BoxFit.contain,
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: (){
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}
