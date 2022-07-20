import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hackatron/models/products.dart';
import 'package:hackatron/models/tags.dart';
import 'package:hackatron/models/users.dart';
import 'package:image_picker/image_picker.dart';

class GetDummyData {
  final firebaseStorageRef = FirebaseStorage.instance.ref();
  List<File> evenImages = [];
  List<File> oddImages = [];

  init() async {
    final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery, preferredCameraDevice: CameraDevice.front);
    File profileImagePath = File(image!.path);
    for (var i = 0; i < 10; i++) {
      await createUsers(profileImagePath);
    }
    for (var i = 0; i < 5; i++) {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          preferredCameraDevice: CameraDevice.front);

      File temporaryImagePath = File(image!.path);

      evenImages.add(temporaryImagePath);
    }
    inspect("ODD");
    for (var i = 0; i < 5; i++) {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          preferredCameraDevice: CameraDevice.front);

      File temporaryImagePath = File(image!.path);

      oddImages.add(temporaryImagePath);
    }
    int n = 0;
    for (var id in userIds) {
      bool even = false;
      if (n % 2 == 0) {
        even = true;
      }
      await createProduct(id, even);
      n++;
    }

    inspect("Done");
  }

  createUsers(File imagePath) async {
    try {
      String name = getRandomString(length: 5);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "$name@test.com",
        password: "123456",
      );
      String currentUserID = FirebaseAuth.instance.currentUser!.uid;

      try {
        final firebaseStorageImageRef =
            firebaseStorageRef.child("users/$currentUserID.jpg");

        late String imageURL;

        UploadTask imageUpoadTask = firebaseStorageImageRef.putFile(imagePath);

        imageURL = await (await imageUpoadTask).ref.getDownloadURL();

        try {
          final userRef = FirebaseFirestore.instance
              .collection('users')
              .withConverter<Users>(
                fromFirestore: (snapshot, _) =>
                    Users.fromJson(snapshot.data()!),
                toFirestore: (users, _) => users.toJson(),
              );
          String profession = "${getRandomString(length: 5)} ${getRandomString(length: 5)}";
          await userRef.doc(currentUserID).set(Users(
                name: name,
                email: "$name@test.com",
                photoURL: imageURL,
                profession: profession,
              ));

          await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
          await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageURL);
          FirebaseAuth.instance.signOut();
          userIds.add(currentUserID);
        } catch (e) {
          FirebaseAuth.instance.currentUser!.delete();
          FirebaseAuth.instance.signOut();
          firebaseStorageImageRef.delete();
          inspect(e);
        }
      } catch (e) {
        FirebaseAuth.instance.currentUser!.delete();
        FirebaseAuth.instance.signOut();
        inspect(e);
      }
    } catch (e) {
      inspect(e);
    }
  }

  createProduct(String userId, bool isEven) async {
    final productsRef = FirebaseFirestore.instance
        .collection('products')
        .withConverter<Products>(
          fromFirestore: (snapshot, _) => Products.fromJson(snapshot.data()!),
          toFirestore: (products, _) => products.toJson(),
        );
    for (var i = 0; i < 3; i++) {
      String name = getRandomString(length: 10);
      String description = getDescription(20);
      double price = Random().nextDouble() * 100;
      int type = Random().nextInt(3) + 1;

      List<String> tags = getTags();

      try {
        DocumentReference<Products> newProduct = await productsRef.add(Products(
          name: name,
          description: description,
          price: price,
          shareCount: Random().nextInt(50000),
          wishlistCount: Random().nextInt(50000),
          type: type,
          userId: userId,
          images: [],
          tags: tags,
        ));

        String productId = newProduct.id;

        List images;
        if (isEven) {
          images = evenImages;
        } else {
          images = oddImages;
        }

        final List<String> finalImages = [];
        var i = 0;
        for (var img in images) {
          final firebaseStorageImageRef =
              firebaseStorageRef.child("products/$productId/${i + 1}.jpg");

          UploadTask imageUpoadTask = firebaseStorageImageRef.putFile(img);

          finalImages.add(await (await imageUpoadTask).ref.getDownloadURL());
          i++;
        }

        await productsRef.doc(productId).set(Products(
              name: name,
              description: description,
              price: price,
              shareCount: Random().nextInt(50000),
              wishlistCount: Random().nextInt(50000),
              type: type,
              userId: userId,
              images: finalImages,
              tags: tags,
            ));
      } catch (e) {
        inspect(e);
      }
    }
  }

  List<String> getTags() {
    int start = Random().nextInt(tags.length);
    int end = Random().nextInt(tags.length);
    while (end <= start) {
      start = Random().nextInt(tags.length);
      end = Random().nextInt(tags.length);
    }
    List<String> subList = tags.sublist(start, end);
    while (subList.length > 3) {
      end = end - 1;
      subList = tags.sublist(start, end);
    }
    return subList;
  }

  createTag() {
    final tagsRef =
        FirebaseFirestore.instance.collection('tags').withConverter<Tags>(
              fromFirestore: (snapshot, _) => Tags.fromJson(snapshot.data()!),
              toFirestore: (tags, _) => tags.toJson(),
            );

    for (var tag in tags) {
      tagsRef.add(Tags(name: tag));
    }
  }

  List<String> userIds = [];
  List<String> tags = [
    "summer",
    "purple",
    "winter",
    "super",
    "fabric",
    "stylish"
  ];
  List<String> randomStrings = [];
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final _charsWithoutNumber =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
  final Random _rnd = Random();

  String getRandomString({required int length, bool onlyAlphabets = false}) {
    final String c;
    if (onlyAlphabets) {
      c = _chars;
    } else {
      c = _charsWithoutNumber;
    }
    String str = String.fromCharCodes(Iterable.generate(
        length, (_) => c.codeUnitAt(_rnd.nextInt(c.length))));
    while (randomStrings.contains(str)) {
      str = String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(_rnd.nextInt(c.length))));
    }

    randomStrings.add(str);
    return str;
  }

  String getDescription(int length) {
    String finalString = "";
    for (var i = 0; i <= length; i++) {
      finalString += " ${getRandomString(length: 10,onlyAlphabets: true)}";
    }
    return finalString;
  }
}
