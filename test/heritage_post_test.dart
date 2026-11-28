import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngon_sac_viet/domain/models/heritage_post.dart';
import 'package:ngon_sac_viet/ui/features/heritage/widgets/heritage_post_card.dart';

void main() {
  test('HeritagePost and HeritageComment deserialize cleanly', () {
    final post = HeritagePost.fromJson({
      'id': 'p1',
      'author_id': 'u1',
      'author_name': 'H Duyên',
      'people_slug': 'ede',
      'title': 'Cồng chiêng Tây Nguyên',
      'body': 'Âm thanh vang vọng buôn làng.',
      'media_type': 'text',
      'telegram_message_id': 42,
      'telegram_url': 'https://t.me/ngonsacviet/42',
      'status': 'approved',
      'like_count': 5,
      'comment_count': 2,
      'liked_by_me': true,
      'recent_comments': [
        {
          'id': 'c1',
          'post_id': 'p1',
          'user_id': 'u2',
          'author_name': 'A Kơ',
          'body': 'Tuyệt vời quá!',
        },
      ],
      'created_at': '2026-11-28T10:00:00Z',
    });

    expect(post.id, 'p1');
    expect(post.authorName, 'H Duyên');
    expect(post.peopleSlug, 'ede');
    expect(post.likedByMe, isTrue);
    expect(post.likeCount, 5);
    expect(post.telegramUrl, 'https://t.me/ngonsacviet/42');
    expect(post.recentComments.length, 1);
    expect(post.recentComments.first.authorName, 'A Kơ');
  });

  testWidgets('HeritagePostCard renders counts, inline comments and actions', (
    tester,
  ) async {
    final post = HeritagePost.fromJson({
      'id': 'p2',
      'author_id': 'u1',
      'author_name': 'Lò Văn',
      'people_slug': 'tay',
      'title': 'Hát Then đầu xuân',
      'body': 'Đàn tính ngân vang bên suối.',
      'media_type': 'text',
      'status': 'approved',
      'like_count': 3,
      'comment_count': 1,
      'liked_by_me': false,
      'recent_comments': [
        {
          'id': 'c2',
          'post_id': 'p2',
          'user_id': 'u3',
          'author_name': 'Lan',
          'body': 'Hay quá ạ!',
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: HeritagePostCard(
              post: post,
              peopleName: 'Người Tày',
              resolveUrl: (path) => path ?? '',
              onLike: () {},
              onComment: () {},
              onQuickComment: (_) async {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Lò Văn'), findsOneWidget);
    expect(find.text('Người Tày'), findsOneWidget);
    expect(find.text('Hát Then đầu xuân'), findsOneWidget);
    expect(find.text('3 lượt thích'), findsOneWidget);
    expect(find.text('1 bình luận'), findsOneWidget);
    expect(find.text('Thích'), findsOneWidget);
    expect(find.text('Bình luận'), findsOneWidget);
    expect(find.text('Chia sẻ'), findsOneWidget);
    expect(find.textContaining('Hay quá ạ!', findRichText: true), findsOneWidget);
  });

  testWidgets('HeritagePostCard expands translate bar and renders translation', (
    tester,
  ) async {
    final post = HeritagePost.fromJson({
      'id': 'p3',
      'author_id': 'u1',
      'author_name': 'Lan',
      'people_slug': 'tay',
      'title': 'Hát Then',
      'body': 'Lễ hội đầu xuân.',
      'media_type': 'text',
      'status': 'approved',
      'like_count': 0,
      'comment_count': 0,
      'liked_by_me': false,
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: HeritagePostCard(
              post: post,
              resolveUrl: (path) => path ?? '',
              onTranslate: (lang) async => HeritagePostTranslation(
                postId: post.id,
                sourceLang: 'vi',
                targetLang: lang,
                translatedTitle: 'Mmua Then',
                translatedBody: 'Klĕi hriê̆ng.',
                engine: 'nllb',
                route: 'direct',
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Xem bản dịch tiếng dân tộc'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ê Đê'));
    await tester.pumpAndSettle();

    expect(find.text('Bản dịch · Ê Đê'), findsOneWidget);
    expect(find.text('Mmua Then'), findsOneWidget);
    expect(find.text('Klĕi hriê̆ng.'), findsOneWidget);
  });
}
