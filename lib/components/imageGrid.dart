import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
final databaseReference = FirebaseDatabase.instance.reference().child("Images");

class ImageGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Gets images from firebase Storage and builds a scrollable image grid.
    // Automatically checks for changes from other users.
    return StreamBuilder(
        stream: databaseReference.onValue,
        builder: (context, snapshots) {
          if(snapshots.hasData && !snapshots.hasError && snapshots.data.snapshot.value != null) {
            Map data = snapshots.data.snapshot.value;
            List images = [];
            data.forEach((key, value) {
              images.add({"key": key, ...value});
            }
            );
            return GridView.builder(
                itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.6, crossAxisCount: 2
                ),
                shrinkWrap: true,
                controller: ScrollController(keepScrollOffset: false),
                itemBuilder: (BuildContext context, int index) {
                  return GridTile(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Card(
                          child: ClipPath(
                            child: Image(
                              image: CachedNetworkImageProvider(images[index]['imageUrl']),
                              fit: BoxFit.fill,
                            )
                          ),
                        ),
                      )
                  );
                }
            );
          }
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
    );
  }
}
