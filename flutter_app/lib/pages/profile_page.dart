import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProfilePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/FitCheck.png', 
           height: 100,
        )
      ),
      body: ListView(
        children: [
          Column(
            children: [
              _buildHeader(),
              _buildProfileInfo(),
              _buildButtons(),
              _buildTabBar(),
              _buildProfileGrid(),
            ],
          )
        ],
      )
    );
  }

Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        CircleAvatar(
          radius: 40,
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'name display',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              '@username',
              style: TextStyle(fontSize: 15),
            ),
            Text('Insert bio here'),
          ],
        ),
      ],
    ),
  );
}


  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // all these need to be connected to database
          _buildProfileInfoItem('Posts', '120'),
          _buildProfileInfoItem('Followers', '1.2M'),
          _buildProfileInfoItem('Following', '1'),
          _buildProfileInfoItem('Awards', '1000'),
        ],
      ),
    );
  }

  Widget _buildProfileInfoItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(label),
      ],
    );
  }

    Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Edit Profile'),
            ),
          ),
        ],
      ),
    );
  }
    Widget _buildTabBar() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(icon: Icon(Icons.grid_on)),
              Tab(icon: Icon(Icons.favorite)),
            ],
          ),
          Container(
            height: 400,
            child: TabBarView(
              children: [
                _buildProfileGrid(),
                Center(child: Text('Favorites')),
              ],
            ),
          ),
        ],
      ),
    );
  }

    Widget _buildProfileGrid() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: 30,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.grey[300],
        );
      },
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}