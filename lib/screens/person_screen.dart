import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instragran_clone/models/user.dart';
import 'package:instragran_clone/providers/user_provider.dart';
import 'package:instragran_clone/utils/colors.dart';
import 'package:instragran_clone/utils/utils.dart';
import 'package:instragran_clone/widgets/follow_button.dart';
import 'package:provider/provider.dart';

class PersonScreen extends StatefulWidget {
  final String uid;
  final bool isProfile;
  const PersonScreen({
    Key? key,
    required this.uid,
    this.isProfile = true,
  }) : super(key: key);

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  Map userData = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();

      userData = (snap.data()! as Map);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    // print("from person screen");
    // print(userData);
    // print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    User user = Provider.of<UserProvider>(context, listen: true).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData["username"] ?? "profile"),
      ),
      body: userData.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                          userData["photoUrl"],
                        ),
                        radius: 40,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildStackColumn(20, "posts"),
                                buildStackColumn(150, "followers"),
                                buildStackColumn(5, "following"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FollowButton(
                                  text: widget.isProfile
                                      ? "Edit Profile"
                                      : user.following.contains(widget.uid)
                                          ? "UnFollow"
                                          : "Follow",
                                  backgroundColor: mobileBackgroundColor,
                                  textColor: primaryColor,
                                  borderColor: Colors.grey,
                                  function: () async {
                                    if (!widget.isProfile) {
                                      if (user.following.contains(widget.uid)) {
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(user.uid)
                                            .update({
                                          "following": FieldValue.arrayRemove(
                                              [widget.uid])
                                        });
                                        user.following.remove(widget.uid);
                                        // user.
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(widget.uid)
                                            .update({
                                          "followers":
                                              FieldValue.arrayRemove([user.uid])
                                        });
                                      } else {
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(user.uid)
                                            .update({
                                          "following": FieldValue.arrayUnion(
                                              [widget.uid])
                                        });
                                        user.following.add(widget.uid);
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(widget.uid)
                                            .update({
                                          "followers":
                                              FieldValue.arrayUnion([user.uid])
                                        });
                                      }
                                      setState(() {});
                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      userData["username"] ?? "username",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 1),
                    child: Text(
                      userData["bio"] ?? "Bio",
                    ),
                  ),
                  const Divider(),
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("posts")
                          .where("uid", isEqualTo: widget.uid)
                          .get(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        // print("11111111111111111111111111111");
                        // print(snapshot.data!.docs.isEmpty);
                        // print("11111111111111111111111111111");

                        if (snapshot.data!.docs.isEmpty) {
                          return Text("No Posts yet!!!");
                        }
                        return Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 7,
                              crossAxisSpacing: 3,
                            ),
                            itemBuilder: (context, index) => Card(
                              elevation: 7,
                              shadowColor: Colors.grey,
                              color: mobileBackgroundColor,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  snapshot.data!.docs[index].data()["postUrl"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // child: ClipRRect(
                              //   borderRadius: BorderRadius.circular(25),
                              //   child: Container(
                              //     width: 50,
                              //     height: 70,
                              //     color: Colors.red,
                              //   ),
                              // ),
                            ),
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                          ),
                        );
                      }),
                ],
              ),
            )
          : Container(),
    );
  }

  Column buildStackColumn(int num, String label) {
    return Column(
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
