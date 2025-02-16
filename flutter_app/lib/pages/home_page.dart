import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {


  //FAKE IMAGES FOR TEMP USE
  final List<String> _images = [
    'assets/test_post.jpg',
    'assets/test_post.jpg',
    'assets/test_post.jpg',
    'assets/test_post.jpg',
    'assets/test_post.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/FitCheck.png', 
           height: 100,
        ),
        centerTitle: true,
      ),
      // will have to connect images from storage to here at some point!!
      body: ListView.builder(
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //TEMP USER INFO
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child:Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(),
                        radius: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'User $index',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                AspectRatio(aspectRatio: 4/5, 
                  child: Image.asset(_images[index], fit: BoxFit.cover),
                ),

              ],
            )
          );  
        },
      ),
      // body: PageView.builder(
      //   scrollDirection: Axis.vertical,
      //   itemCount: 10,
      //   itemBuilder: (context, index) {
      //     return Container(
      //       color: Colors.accents[index % Colors.accents.length],
      //       child: Center(
      //         child: Text(
      //           'Item $index',
      //           style: TextStyle(fontSize: 24, color: Colors.white),
      //         )
      //       )
      //     );
      //   },
      // )
    );
  }
}
