// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';
// import 'package:travel_mate/models/location_model.dart';
// import 'package:unicons/unicons.dart';

// import '../../../blocs/blocs.dart';
// import '../widgets/widgets.dart';

// class LocationTab extends StatelessWidget {
//   final TabController tabController;

//   const LocationTab({
//     Key? key,
//     required this.tabController,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<OnboardingBloc, OnboardingState>(
//       builder: (context, state) {
//         if (state is OnboardingLoading) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         if (state is OnboardingLoaded) {
//           return Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Theme.of(context).primaryColor,
//                             ),
//                             child: Icon(
//                               UniconsLine.location_point,
//                               size: 30,
//                               color: Colors.white,
//                             )),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Text(
//                           'Where are you?',
//                           style: Theme.of(context)
//                               .primaryTextTheme
//                               .headline2!
//                               .copyWith(color: Colors.black, fontSize: 24),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     CustomTextField(
//                       hint: 'Enter your location',
//                       onChanged: (value) {
//                         Location location =
//                             state.user.location.copyWith(name: value);

//                         context.read<OnboardingBloc>().add(
//                               UpdateUserLocation(
//                                 location: location,
//                               ),
//                             );
//                       },
//                       onFocusChanged: (hasFocus) {
//                         if (hasFocus) {
//                           return;
//                         } else {
//                           context.read<OnboardingBloc>().add(
//                                 UpdateUserLocation(
//                                   isUpdateComplete: true,
//                                   location: state.user.location,
//                                 ),
//                               );
//                         }
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     Column(
//                       children: [
//                         AspectRatio(
//                           aspectRatio: 1,
//                           child: GoogleMap(
//                             myLocationEnabled: true,
//                             myLocationButtonEnabled: false,
//                             onMapCreated: (GoogleMapController controller) {
//                               context.read<OnboardingBloc>().add(
//                                   UpdateUserLocation(controller: controller));
//                             },
//                             initialCameraPosition: CameraPosition(
//                               zoom: 15.5,
//                               target: LatLng(
//                                 state.user.location.lat,
//                                 state.user.location.lon,
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     StepProgressIndicator(
//                       totalSteps: 6,
//                       currentStep: 6,
//                       selectedColor: Theme.of(context).primaryColor,
//                       unselectedColor: Theme.of(context).backgroundColor,
//                     ),
//                     SizedBox(height: 10),
//                     CustomButton(tabController: tabController, text: 'DONE')
//                   ],
//                 ),
//               ],
//             ),
//           );
//         } else {
//           return Text('Something went wrong');
//         }
//       },
//     );
//   }
// }
