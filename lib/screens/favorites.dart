import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:radio_app/current_songs.dart';

class FavoritesManager {
  SharedPreferences prefs;

  Future<List<String>> getFavoritesList() async {
    List<String> favorites;
    prefs = await SharedPreferences.getInstance();
    favorites = prefs.getStringList('favorites');
    if (favorites == null) favorites = [];
    return favorites;
  }

  Future<void> saveFavorite(String newItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites');
    if (favorites == null) favorites = [];
    if (!favorites.contains(newItem)) favorites.add(newItem);
    prefs.setStringList('favorites', favorites);
  }

  Future<void> removeFavorite(String entry) async {
    List<String> favorites;
    favorites = await getFavoritesList();
    favorites.remove(entry);
    replaceFavorites(favorites);
  }

  Future<void> replaceFavorites(List<String> items) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', items);
  }

  Future<bool> isFavorite(String entry) async {
    List<String> favorites;
    favorites = await getFavoritesList();
    return favorites.contains(entry);
  }
}

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  FavoritesManager favoritesManager = FavoritesManager();
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    getFavoritesList();
  }

  void getFavoritesList() async {
    items = await favoritesManager.getFavoritesList();
    setState(() {});
  }

  String getArtist(String item) {
    List<String> artistAndTitleList = item.split(' - ');
    if (item.contains(' - '))
      return artistAndTitleList[1];
    else
      return ' - ';
  }

  String getTitle(String item) {
    List<String> artistAndTitleList = item.split(' - ');
    return artistAndTitleList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite'),
      ),
      body: items.length == 0
          ? Center(child: Text('Nu există nicio melodie adăugată la favorite', textAlign: TextAlign.center,))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                List<String> undoItems = List.from(items);
                return Dismissible(
                  background: Container(
                    color: Colors.black87,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('DELETE', style: TextStyle(color: Colors.white),),
                  ),
                  secondaryBackground: Container(
                    color: Colors.black87,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text('DELETE', style: TextStyle(color: Colors.white),),
                  ),
                  key: Key(item),
                  onDismissed: (direction) {
                    setState(() {
                      items.removeAt(index);
                    });
                    favoritesManager.replaceFavorites(items);
                    CurrentSongsFetcher().refresh();
                    Scaffold.of(context).removeCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Melodia a fost eliminată din listă."),
                        duration: Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            favoritesManager.replaceFavorites(undoItems);
                            getFavoritesList();
                          },
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text('${getTitle(items[index])}'),
                    leading: CircleAvatar(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.teal[200],
                    ),
                    subtitle: Text('${getArtist(items[index])}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_sweep),
                      onPressed: () {
                        setState(() {
                          items.removeAt(index);
                        });
                        favoritesManager.replaceFavorites(items);
                        CurrentSongsFetcher().refresh();
                        Scaffold.of(context).removeCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Melodia a fost eliminată din listă."),
                            duration: Duration(seconds: 3),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                favoritesManager.replaceFavorites(undoItems);
                                getFavoritesList();
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
