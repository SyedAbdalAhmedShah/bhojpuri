import 'package:bojpuri/blocs/video_blocs/bloc/video_bloc_bloc.dart';
import 'package:bojpuri/utils/app_colors.dart';
import 'package:bojpuri/views/Home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (
      context,
      orientation,
      deviceType,
    ) {
      return MultiBlocProvider(
        providers: [BlocProvider(create: (_) => VideoBloc())],
        child: MaterialApp(
          title: 'Bojpuri videos',
          theme: ThemeData(
              useMaterial3: true,
              appBarTheme: AppBarTheme(backgroundColor: Colors.white, elevation: 0),
              scaffoldBackgroundColor: Colors.white,
              textTheme: TextTheme(
                  titleMedium: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              )),
              primaryColor: AppColors.primaryColor),
          home: const HomeScreen(),
        ),
      );
    });
  }
}
