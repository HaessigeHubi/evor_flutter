import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import '../lib/home.dart';
import '../lib/home.dart';
import '../lib/pages/login/signup.dart';
import '../lib/pages/event/search/eventlist.dart';
import '../lib/pages/event/create/createEvent.dart';
import '../lib/pages/event/owner/userEventList.dart';
import '../lib/pages/Maps/googlemaps.dart';
import '../lib/domain/repository/models/users.dart' as User;

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockUser extends Mock implements User.User {}

class MockGoogleMapController extends Mock implements GoogleMapController {}

class MockBuildContext extends Mock implements BuildContext {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}


class MockPageRoute extends Mock implements PageRoute {}

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}


void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockNavigatorObserver mockObserver;
  late User.User mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockObserver = MockNavigatorObserver();
    mockUser = MockUser();
  });

  group('Home', ()
  {
    final widget = MaterialApp(
        home: Home(
          user: mockUser,
        ));

    testWidgets('has GoogleMapsWidget', (tester) async {
      await tester.pumpWidget(widget);
      expect(find.byType(GoogleMapsWidget), findsOneWidget);
    });

    testWidgets('has FancyBottomNavigation', (tester) async {
      await tester.pumpWidget(widget);
      expect(find.byType(FancyBottomNavigation), findsOneWidget);
    });

    testWidgets('has AppBar', (tester) async {
      await tester.pumpWidget(widget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('sign out button works', (tester) async {
      await tester.pumpWidget(widget);
      var signOutButton =
          find
              .widgetWithIcon(AppBar, Icons.exit_to_app)
              .first;
      await tester.tap(signOutButton);
      verify(mockFirebaseAuth.signOut());
    });

    testWidgets('has TabData with title "Add"', (tester) async {
      await tester.pumpWidget(widget);
      var tabData =
          find
              .byWidgetPredicate((widget) => widget is TabData)
              .first;
      var title = find.text('Add');
      expect(tabData, findsOneWidget);
      expect(title, findsOneWidget);
    });

    testWidgets('has TabData with title "List"', (tester) async {
      await tester.pumpWidget(widget);
      var tabData =
          find
              .byWidgetPredicate((widget) => widget is TabData)
              .first;
      var title = find.text('List');
      expect(tabData, findsOneWidget);
      expect(title, findsOneWidget);
    });

    testWidgets('has TabData with title "Map"', (tester) async {
      await tester.pumpWidget(widget);
      var tabData =
          find
              .byWidgetPredicate((widget) => widget is TabData)
              .first;
      var title = find.text('Map');
      expect(tabData, findsOneWidget);
      expect(title, findsOneWidget);
    });
  });
  group('Home widget tests', () {
    testWidgets('Renders the AppBar with the correct content',
            (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(
            home: Home(user: mockUser),
          ));

          final appBarTitleFinder = find.text('EVOR John');
          final exitIconFinder = find.byIcon(Icons.exit_to_app);

          expect(appBarTitleFinder, findsOneWidget);
          expect(exitIconFinder, findsOneWidget);
        });

    testWidgets('Renders the bottom navigation bar with the correct content',
            (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(
            home: Home(user: mockUser),
          ));

          final addIconFinder = find.byIcon(Icons.add);
          final listIconFinder = find.byIcon(Icons.list);
          final mapIconFinder = find.byIcon(Icons.map);
          final ownerIconFinder = find.byIcon(Icons.calendar_month);
          final filterIconFinder = find.byIcon(Icons.filter_alt);

          expect(addIconFinder, findsOneWidget);
          expect(listIconFinder, findsOneWidget);
          expect(mapIconFinder, findsOneWidget);
          expect(ownerIconFinder, findsOneWidget);
          expect(filterIconFinder, findsOneWidget);
        });

    testWidgets('Tapping on the add icon navigates to the CreateEvent page',
            (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(
            home: Home(user: mockUser),
          ));

          await tester.tap(find.byIcon(Icons.add));
          await tester.pumpAndSettle();

          expect(find.byType(CreateEvent), findsOneWidget);
        });

    testWidgets('Tapping on the list icon navigates to the EventList page',
            (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(
            home: Home(user: mockUser),
          ));

          await tester.tap(find.byIcon(Icons.list));
          await tester.pumpAndSettle();

          expect(find.byType(EventList), findsOneWidget);
        });

  });

}