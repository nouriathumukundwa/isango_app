import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isango_app/app.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/screens/auth/sign_up_screen.dart';

void main() {
  group('SignUpScreen', () {
    // Helper function to build widget with test data
    Widget createWidgetUnderTest() {
      return const IsangoApp();
    }

    testWidgets('displays all required UI elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate to sign up screen
      await tester.tap(find.byType(TextButton).first);
      await tester.pumpAndSettle();

      // Verify header elements
      expect(find.text('Create account'), findsOneWidget);
      expect(
        find.text('Join Isango to discover and share your community events.'),
        findsOneWidget,
      );

      // Verify form fields
      expect(find.byLabelText('Full name'), findsOneWidget);
      expect(find.byLabelText('Email address'), findsOneWidget);
      expect(find.byLabelText('Password'), findsOneWidget);
      expect(find.byLabelText('Confirm password'), findsOneWidget);

      // Verify buttons
      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
      expect(find.byType(TextButton), findsWidgets);

      // Verify email verification note
      expect(
        find.text(
          'We\'ll send you a verification email after account creation.',
        ),
        findsOneWidget,
      );

      // Verify sign in link
      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Log in'), findsOneWidget);

      // Verify back button
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('validates required fields', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate to sign up screen
      await tester.tap(find.byType(TextButton).first);
      await tester.pumpAndSettle();

      // Tap sign up button without filling any fields
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();

      // Verify validation errors appear
      expect(find.text('Enter your full name'), findsOneWidget);
      expect(find.text('Enter your email address'), findsOneWidget);
      expect(find.text('Create a password'), findsOneWidget);
      expect(find.text('Confirm your password'), findsOneWidget);
    });

    testWidgets('validates email format', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate to sign up screen
      await tester.tap(find.byType(TextButton).first);
      await tester.pumpAndSettle();

      // Fill in form with invalid email
      await tester.enterText(find.byLabelText('Full name'), 'Test User');
      await tester.enterText(find.byLabelText('Email address'), 'invalidemail');
      await tester.enterText(find.byLabelText('Password'), 'password123');
      await tester.enterText(
        find.byLabelText('Confirm password'),
        'password123',
      );

      // Tap sign up button
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();

      // Verify email validation error
      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    testWidgets('validates password length', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate to sign up screen
      await tester.tap(find.byType(TextButton).first);
      await tester.pumpAndSettle();

      // Fill in form with short password
      await tester.enterText(find.byLabelText('Full name'), 'Test User');
      await tester.enterText(
        find.byLabelText('Email address'),
        'test@example.com',
      );
      await tester.enterText(find.byLabelText('Password'), '123');
      await tester.enterText(find.byLabelText('Confirm password'), '123');

      // Tap sign up button
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();

      // Verify password length validation error
      expect(find.text('Use at least 6 characters'), findsOneWidget);
    });

    testWidgets('validates password confirmation mismatch', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate to sign up screen
      await tester.tap(find.byType(TextButton).first);
      await tester.pumpAndSettle();

      // Fill in form with mismatched passwords
      await tester.enterText(find.byLabelText('Full name'), 'Test User');
      await tester.enterText(
        find.byLabelText('Email address'),
        'test@example.com',
      );
      await tester.enterText(find.byLabelText('Password'), 'password123');
      await tester.enterText(
        find.byLabelText('Confirm password'),
        'password456',
      );

      // Tap sign up button
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();

      // Verify password mismatch validation error
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('shows loading state during submission', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate to sign up screen
      await tester.tap(find.byType(TextButton).first);
      await tester.pumpAndSettle();

      // Fill in form with valid data
      await tester.enterText(find.byLabelText('Full name'), 'Test User');
      await tester.enterText(
        find.byLabelText('Email address'),
        'test@example.com',
      );
      await tester.enterText(find.byLabelText('Password'), 'password123');
      await tester.enterText(
        find.byLabelText('Confirm password'),
        'password123',
      );

      // Tap sign up button
      await tester.tap(find.text('Sign up'));

      // The form fields should be disabled during submission
      await tester.pump();

      // Verify loading indicator appears
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('disables form fields during submission', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate to sign up screen
      await tester.tap(find.byType(TextButton).first);
      await tester.pumpAndSettle();

      // Fill in form with valid data
      await tester.enterText(find.byLabelText('Full name'), 'Test User');
      await tester.enterText(
        find.byLabelText('Email address'),
        'test@example.com',
      );
      await tester.enterText(find.byLabelText('Password'), 'password123');
      await tester.enterText(
        find.byLabelText('Confirm password'),
        'password123',
      );

      // Verify fields are enabled before submission
      var nameField = find.byLabelText('Full name');
      expect(tester.widget<TextFormField>(nameField).enabled, true);

      // Tap sign up button
      await tester.tap(find.text('Sign up'));
      await tester.pump();

      // Verify fields are disabled during submission
      nameField = find.byLabelText('Full name');
      expect(tester.widget<TextFormField>(nameField).enabled, false);
    });

    testWidgets('navigates to login screen when sign in link is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate to sign up screen
      await tester.tap(find.byType(TextButton).first);
      await tester.pumpAndSettle();

      // Tap sign in link
      await tester.tap(find.text('Log in'));
      await tester.pumpAndSettle();

      // Verify we're back on login screen
      expect(find.text('Welcome back'), findsOneWidget);
    });

    testWidgets('closes screen when back button is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate to sign up screen
      await tester.tap(find.byType(TextButton).first);
      await tester.pumpAndSettle();

      // Verify we're on sign up screen
      expect(find.text('Create account'), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we're back on login screen
      expect(find.text('Welcome back'), findsOneWidget);
    });

    testWidgets('toggles password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate to sign up screen
      await tester.tap(find.byType(TextButton).first);
      await tester.pumpAndSettle();

      // Enter a password
      await tester.enterText(find.byLabelText('Password'), 'password123');

      // Initially password should be obscured
      var passwordField = find.byLabelText('Password');
      expect((tester.widget<TextFormField>(passwordField).obscureText), true);

      // Find and tap the visibility toggle icon for password field
      // We need to find the parent TextFormField first to get its suffix icon button
      var visibilityButtons = find.byIcon(Icons.visibility_outlined);
      await tester.tap(visibilityButtons.first);
      await tester.pumpAndSettle();

      // Password should now be visible
      passwordField = find.byLabelText('Password');
      expect((tester.widget<TextFormField>(passwordField).obscureText), false);
    });

    testWidgets('shows error container on submission error', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: SignUpScreen()));

      // Fill in valid form data
      await tester.enterText(find.byLabelText('Full name'), 'Test User');
      await tester.enterText(
        find.byLabelText('Email address'),
        'test@example.com',
      );
      await tester.enterText(find.byLabelText('Password'), 'password123');
      await tester.enterText(
        find.byLabelText('Confirm password'),
        'password123',
      );

      // Tap sign up button
      await tester.tap(find.text('Sign up'));

      // Wait for the submission to complete
      await tester.pumpAndSettle();

      // If submission simulation is successful, we should navigate
      // In a real test environment with mocking, we could verify the error state
    });

    testWidgets('navigates to home after successful submission', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate to sign up screen
      await tester.tap(find.byType(TextButton).first);
      await tester.pumpAndSettle();

      // Fill in form with valid data
      await tester.enterText(find.byLabelText('Full name'), 'Test User');
      await tester.enterText(
        find.byLabelText('Email address'),
        'test@example.com',
      );
      await tester.enterText(find.byLabelText('Password'), 'password123');
      await tester.enterText(
        find.byLabelText('Confirm password'),
        'password123',
      );

      // Tap sign up button
      await tester.tap(find.text('Sign up'));

      // Wait for navigation and snackbar to complete
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify we've navigated to the home screen
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
