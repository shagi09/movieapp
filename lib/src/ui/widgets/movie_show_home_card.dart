import 'package:cineflix/src/blocs/movies_bloc.dart';
import 'package:cineflix/src/models/item_model.dart';
import 'package:cineflix/src/ui/item_navigation.dart';
import 'package:cineflix/src/ui/widgets/movie_show_carousell.dart';
import 'package:flutter/material.dart';

class MovieShowHomeCard extends StatelessWidget {
  final int categoryId;
  final int mediaId;
  final String title;
  const MovieShowHomeCard(
      {super.key,
      required this.categoryId,
      required this.title,
      required this.mediaId});

  @override
  Widget build(BuildContext context) {
    switch (mediaId) {
      case 1:
        bloc.fetchMoviesForIndex(categoryId);
        break;
      case 2:
        bloc.fetchTVShowsForIndex(categoryId);
        break;
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 260,
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            height: 60,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ItemNavigation(
                          pageTitle: title,
                          buttonIndex: mediaId,
                          itemIndex: categoryId,
                        )));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
          StreamBuilder(
            stream: bloc.getStreamForIndex(categoryId),
            builder: (context, AsyncSnapshot<ItemModel?> snapshot) {
              if (snapshot.hasData) {
                return MovieShowCarousel(snapshot: snapshot);
              } else if (snapshot.connectionState == ConnectionState.none ||
                  snapshot.connectionState == ConnectionState.waiting) {
                print("waiting state");
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                return const Center(
                  child: Text('No data avaliable'),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          )
        ],
      ),
    );
  }
}