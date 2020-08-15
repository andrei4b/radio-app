import 'package:flutter/material.dart';
import 'package:radio_app/screens/favorites.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.teal[400],
      ),
      child: Drawer(
        child: ListView(
          //padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                '',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/images/logo.png'),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.white,),
              title: Text('Favorite', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pushNamed(context, '/favorites');
              },
            ),
            ListTile(
              leading: Icon(Icons.fiber_new, color: Colors.white,),
              title: Text('Noutăți', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pushNamed(context, '/news');
              },
            ),
            ListTile(
              leading: Icon(Icons.live_tv, color: Colors.white,),
              title: Text('Emisiuni', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pushNamed(context, '/shows');
              },
            ),
            ListTile(
              leading: Icon(Icons.face, color: Colors.white,),
              title: Text('Despre noi', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pushNamed(context, '/members');
              },
            ),
            ListTile(
              leading: Icon(Icons.archive, color: Colors.white,),
              title: Text('Arhivă', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pushNamed(context, '/archive');
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_phone, color: Colors.white,),
              title: Text('Contact', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pushNamed(context, '/contact');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white,),
              title: Text('Setări', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: Colors.white,),
              title: Text('Despre aplicație', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pushNamed(context, '/info');
              },
            ),
          ],
        ),
      ),
    );
  }
}
