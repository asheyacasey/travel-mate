import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/screens/login/login_screen.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screen.dart';
import 'package:travel_mate/screens/onboarding/widgets/widgets.dart';
import 'package:travel_mate/widgets/widgets.dart';
import 'package:unicons/unicons.dart';

import '../../blocs/blocs.dart';
import '../../repositories/repositories.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (context) {
          print(BlocProvider.of<AuthBloc>(context).state.status);
          return BlocProvider.of<AuthBloc>(context).state.status ==
                  AuthStatus.unauthenticated
              ? LoginScreen()
              : BlocProvider<ProfileBloc>(
                  create: (context) => ProfileBloc(
                    authBloc: BlocProvider.of<AuthBloc>(context),
                    databaseRepository: context.read<DatabaseRepository>(),
                    //locationRepository: context.read<LocationRepository>(),
                  )..add(
                      LoadProfile(
                          userId: context.read<AuthBloc>().state.authUser!.uid),
                    ),
                  child: ProfileScreen(),
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ProfileLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(context
                                      .read<AuthBloc>()
                                      .state
                                      .user!
                                      .imageUrls[0]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Text(
                          context.read<AuthBloc>().state.user!.name,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline2!
                              .copyWith(color: Colors.black),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CustomElevatedButton(
                          text: 'View',
                          beginColor: state.isEditingOn
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          endColor: state.isEditingOn
                              ? Colors.white
                              : Theme.of(context).accentColor,
                          textColor:
                              state.isEditingOn ? Colors.black : Colors.white,
                          width: MediaQuery.of(context).size.width * 0.45,
                          onPressed: () {
                            context.read<ProfileBloc>().add(
                                  SaveProfile(user: state.user),
                                );
                          },
                        ),
                        SizedBox(width: 10),
                        CustomElevatedButton(
                          text: 'Edit',
                          beginColor: state.isEditingOn
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          endColor: state.isEditingOn
                              ? Theme.of(context).accentColor
                              : Colors.white,
                          textColor:
                              state.isEditingOn ? Colors.white : Colors.black,
                          width: MediaQuery.of(context).size.width * 0.45,
                          onPressed: () {
                            context.read<ProfileBloc>().add(
                                  EditProfile(
                                    isEditingOn: true,
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TextField(
                          title: 'Biography',
                          value: context.read<AuthBloc>().state.user!.bio,
                          onChanged: (value) {
                            context.read<ProfileBloc>().add(
                                  UpdateUserProfile(
                                    user: context
                                        .read<AuthBloc>()
                                        .state
                                        .user!
                                        .copyWith(bio: value),
                                  ),
                                );
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _TextField(
                          title: 'Age',
                          value: '${context.read<AuthBloc>().state.user!.age}',
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            if (value == '') {
                              return;
                            }
                            context.read<ProfileBloc>().add(
                                  UpdateUserProfile(
                                    user: context
                                        .read<AuthBloc>()
                                        .state
                                        .user!
                                        .copyWith(age: int.parse(value)),
                                  ),
                                );
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _TextField(
                          title: 'Job Title',
                          value:
                              '${context.read<AuthBloc>().state.user!.jobTitle}',
                          onChanged: (value) {
                            context.read<ProfileBloc>().add(
                                  UpdateUserProfile(
                                    user: context
                                        .read<AuthBloc>()
                                        .state
                                        .user!
                                        .copyWith(jobTitle: value),
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         width: MediaQuery.of(context).size.width,
                  //         decoration: BoxDecoration(
                  //           border: Border.all(
                  //               color: Theme.of(context).primaryColor),
                  //           borderRadius: BorderRadius.circular(8),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Column(
                  //             mainAxisSize: MainAxisSize.max,
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               TitleWithIcon(
                  //                   title: 'Profile Summary',
                  //                   icon: UniconsLine.edit),
                  //               Text(context.read<AuthBloc>().state.user!.bio,
                  //                   style:
                  //                       Theme.of(context).textTheme.headline6)
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         height: 10,
                  //       ),
                  //       Container(
                  //         width: MediaQuery.of(context).size.width,
                  //         decoration: BoxDecoration(
                  //           border: Border.all(
                  //             color: Theme.of(context).primaryColor,
                  //           ),
                  //           borderRadius: BorderRadius.circular(8),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(10.0),
                  //           child: Column(
                  //             mainAxisSize: MainAxisSize.max,
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               TitleWithIcon(
                  //                   title: 'I\'m interested in...',
                  //                   icon: UniconsLine.edit),
                  //               CustomTextContainer(
                  //                 text: state.user.interests[0],
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         height: 10,
                  //       ),
                  //       TitleWithIcon(title: 'Photos', icon: UniconsLine.edit),
                  //       SizedBox(
                  //         height: 125,
                  //         child: ListView.builder(
                  //             itemCount: context
                  //                 .read<AuthBloc>()
                  //                 .state
                  //                 .user!
                  //                 .imageUrls
                  //                 .length,
                  //             shrinkWrap: true,
                  //             scrollDirection: Axis.horizontal,
                  //             itemBuilder: (context, index) {
                  //               return Padding(
                  //                 padding: const EdgeInsets.only(right: 5),
                  //                 child: UserImage.small(
                  //                   width: 100,
                  //                   height: 125,
                  //                   url: context
                  //                       .read<AuthBloc>()
                  //                       .state
                  //                       .user!
                  //                       .imageUrls[index],
                  //                   border: Border.all(
                  //                     color: Theme.of(context).primaryColor,
                  //                     width: 2,
                  //                   ),
                  //                 ),
                  //               );
                  //             }),
                  //       ),
                  //       SizedBox(
                  //         height: 15,
                  //       ),
                  //       Container(
                  //         width: MediaQuery.of(context).size.width,
                  //         decoration: BoxDecoration(
                  //           border: Border.all(
                  //             color: Theme.of(context).primaryColor,
                  //           ),
                  //           borderRadius: BorderRadius.circular(8),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Row(
                  //             children: [
                  //               Container(
                  //                 child: Icon(
                  //                   UniconsLine.user_location,
                  //                   color: Theme.of(context).primaryColor,
                  //                   size: 30,
                  //                 ),
                  //               ),
                  //               SizedBox(
                  //                 width: 2,
                  //               ),
                  //               Text(
                  //                 context.read<AuthBloc>().state.user!.location,
                  //                 style: Theme.of(context)
                  //                     .textTheme
                  //                     .headline4!
                  //                     .copyWith(height: 1.5),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       TextButton(
                  //         onPressed: () {
                  //           RepositoryProvider.of<AuthRepository>(context)
                  //               .signOut();
                  //         },
                  //         child: Center(
                  //           child: Text(
                  //             'Sign Out',
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .headline5!
                  //                 .copyWith(
                  //                     color: Theme.of(context).primaryColor),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              );
            } else {
              return Text('Something went wrong');
            }
          },
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final String title;
  final String value;
  final Function(String?) onChanged;

  const _TextField({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: 10,
            ),
            state.isEditingOn
                ? CustomTextField(
                    initialValue: value,
                    padding: EdgeInsets.zero,
                  )
                : Text(
                    value,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(height: 1.5),
                  ),
            SizedBox(),
          ],
        );
      },
    );
  }
}
