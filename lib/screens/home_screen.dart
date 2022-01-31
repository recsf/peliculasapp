import 'package:flutter/material.dart';
import 'package:peliculasapp/providers/providers.dart';
import 'package:peliculasapp/search/search_delegate.dart';
import 'package:peliculasapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas en cines'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(
              context: context, 
              delegate: MovieSearchDelegate()),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [
          //tarjetas Principales
          CardSwiper(movies: moviesProvider.onDisplayMovies,),
          
          //slider
          MovieSlider(movies: moviesProvider.popularMovies, title: 'Populares', onNextPage: () => moviesProvider.getPopularMovie(),)
        ],
      ),
      )
    );
  }
}