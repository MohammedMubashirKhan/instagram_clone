import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instragran_clone/screens/person_screen.dart';
import 'package:instragran_clone/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(labelText: "Search for a user"),
          onFieldSubmitted: (value) {
            // it build screen when username is searched
            setState(() {});
          },
        ),
      ),
      body: _searchController.text.isNotEmpty
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .where("username",
                      isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  print((snapshot.data as dynamic).docs);
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PersonScreen(
                              uid: (snapshot.data! as dynamic).docs[index]
                                  ["uid"],
                              isProfile: false),
                        )),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                (snapshot.data! as dynamic).docs[index]
                                    ["photoUrl"]),
                          ),
                          title: Text((snapshot.data! as dynamic).docs[index]
                              ["username"]),
                          subtitle: Text(
                              (snapshot.data! as dynamic).docs[index]["bio"]),
                          trailing: Text(
                              "${(snapshot.data! as dynamic).docs[index]["followers"].length} Flollowers"),
                        ),
                      );
                    },
                  );
                }
              },
            )
          : Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: FutureBuilder(
                future: FirebaseFirestore.instance.collection("posts").get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return StaggeredGridView.countBuilder(
                    staggeredTileBuilder: (index) =>
                        StaggeredTile.count(index % 3 == 0 ? 2 : 1, 2),
                    itemCount: (snapshot.data as dynamic).docs.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    itemBuilder: (context, index) => buildImage(
                        index, (snapshot.data as dynamic).docs[index].data()),
                  );
                },
              ),
            ),
    );
  }

  Card buildImage(int index, Map<String, dynamic> snapshot) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Image.network(
        snapshot["postUrl"],
        // "https://source.unsplash.com/random/240*300/?sig=$index"
      ),
    );
  }
}
