import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var isLikeAnimation = false.obs;

  var commentLength = 0.obs;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, String>> instaStory = [
    {
      'name': 'Your Story',
      'imageUrl':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YXZhdGFyfGVufDB8MXwwfHw%3D&auto=format&fit=crop&w=800&q=60',
      'posting':
          'https://images.unsplash.com/photo-1549692520-acc6669e2f0c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8cHJvZ3JhbW1lcnxlbnwwfDF8MHx8&auto=format&fit=crop&w=800&q=60',
      'caption': 'Wow',
    },
    {
      'name': 'James Moriarty',
      'imageUrl':
          'https://images.unsplash.com/photo-1628890920690-9e29d0019b9b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8YXZhdGFyfGVufDB8MXwwfHw%3D&auto=format&fit=crop&w=800&q=60',
      'posting':
          'https://images.unsplash.com/photo-1588811752802-af42bad9f378?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8cHJvZ3JhbW1lcnxlbnwwfDF8MHx8&auto=format&fit=crop&w=800&q=60',
      'caption':
          'Aku bukan programmer yang hebat. Aku hanya programmer yang baik, dengan kebiasaan yang hebat',
    },
    {
      'name': 'Yagami',
      'imageUrl':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NjB8fGF2YXRhcnxlbnwwfDF8MHx8&auto=format&fit=crop&w=800&q=60',
      'posting':
          'https://images.unsplash.com/photo-1628258334105-2a0b3d6efee1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8cHJvZ3JhbW1lcnxlbnwwfDF8MHx8&auto=format&fit=crop&w=800&q=60',
      'caption': 'Practice makes perfect!',
    },
    {
      'name': 'Lewliet',
      'imageUrl':
          'https://images.unsplash.com/photo-1618641986557-1ecd230959aa?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfDF8MHx8&auto=format&fit=crop&w=800&q=60',
      'posting':
          'https://images.unsplash.com/photo-1594904351111-a072f80b1a71?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fHByb2dyYW1tZXJ8ZW58MHwxfDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60',
      'caption': 'Brick by brick. Step by step.',
    },
    {
      'name': 'Sherlock Holmes',
      'imageUrl':
          'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fHByb2ZpbGV8ZW58MHwxfDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60',
      'posting':
          'https://images.unsplash.com/flagged/photo-1563536310477-c7b4e3a800c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTV8fHByb2dyYW1tZXJ8ZW58MHwxfDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60',
      'caption': 'The best place to write a thousand\'s code',
    },
    {
      'name': 'Near',
      'imageUrl':
          'https://images.unsplash.com/photo-1608155686393-8fdd966d784d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzN8fHByb2ZpbGV8ZW58MHwxfDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60',
      'posting':
          'https://images.unsplash.com/photo-1618389041494-8fab89c3f22b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fHByb2dyYW1tZXJ8ZW58MHwxfDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60',
      'caption': 'Let\'s go!',
    },
  ];

  // Future<int> getComments(String postId) async {
  //   try {
  //     QuerySnapshot snapshot = await _firestore
  //         .collection('posts')
  //         .doc(postId)
  //         .collection('comments')
  //         .get();

  //     update(['comments']);
  //     print('comments $commentLength id is $postId');
  //     return commentLength.value = snapshot.docs.length;
  //   } catch (e) {
  //     print('error get comments ${e.toString()}');
  //   }
  //   return commentLength.value;
  // }

  void changeAnimation() {
    isLikeAnimation.value = false;
  }
}
