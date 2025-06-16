import 'package:flutter/material.dart';
import 'package:udevs/src/common/style/app_size.dart';
import 'package:udevs/src/common/utils/extension/context_extension.dart';
import 'package:udevs/src/features/underground_railway/controller/railway_controller.dart';
import 'package:udevs/src/features/underground_railway/widgets/railway_button.dart';
import 'package:video_player/video_player.dart';

class UndergroundRailway extends StatefulWidget {
  const UndergroundRailway({super.key});

  @override
  State<UndergroundRailway> createState() => _UndergroundRailwayState();
}

class _UndergroundRailwayState extends State<UndergroundRailway>
    with RailwayController {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.primary,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    height: !isAnimation ? 100 : 0,
                    child: Padding(
                      padding: AppSize.paddingAll10,
                      child: Text(
                        "Keyingi bekat",
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    color: Colors.yellow,
                    height: isAnimation ? 100 : 0,
                    duration: Duration(milliseconds: 400),
                    child: Padding(
                      padding: AppSize.paddingAll10,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Ehtiyot bo'ling! Eshiklar yopiladi",
                              style: context.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          videoPlayerController.value.isInitialized
                              ? SizedBox(
                                height: 90,
                                width: 90,
                                child: AspectRatio(
                                  aspectRatio:
                                      videoPlayerController.value.aspectRatio,
                                  child: VideoPlayer(videoPlayerController),
                                ),
                              )
                              : CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                height: 170,
                child: ListView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(width: 20),
                    for (
                      int index = 0;
                      index < mapRailwaysInFirst.length;
                      index++
                    )
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        height: 160,
                        child: Stack(
                          children: [
                            Padding(
                              padding:
                                  station == index
                                      ? EdgeInsets.only(bottom: 15.0)
                                      : EdgeInsets.zero,
                              child: AnimatedAlign(
                                duration: Duration(seconds: 1),
                                alignment: Alignment.center,
                                child: TweenAnimationBuilder(
                                  tween: Tween<double>(
                                    begin: station == index ? 1 : 0.9,
                                    end: station == index ? 1 : 0.9,
                                  ),
                                  duration: Duration(milliseconds: 300),
                                  builder: (
                                    BuildContext context,
                                    double scale,
                                    Widget? child,
                                  ) {
                                    return Transform.scale(
                                      scale: scale,
                                      alignment: Alignment.centerLeft,
                                      child: AnimatedDefaultTextStyle(
                                        style:
                                            (station == index
                                                ? context
                                                    .textTheme
                                                    .displayMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )
                                                : context
                                                    .textTheme
                                                    .headlineSmall) ??
                                            TextStyle(),
                                        duration: Duration(milliseconds: 300),
                                        child: Text(mapRailwaysInFirst[index]),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            changeRailways.contains(mapRailwaysInFirst[index])
                                ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: SizedBox(
                                    height: 60,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: SizedBox(
                                            height: 20,
                                            width: 20 * 23,
                                            child: ColoredBox(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: ColoredBox(
                                            color: Colors.white,
                                            child: CircularProgressIndicator(
                                              value: 1,
                                              color:
                                                  index == 0
                                                      ? Colors.yellow
                                                      : index == 10
                                                      ? Colors.blue
                                                      : Colors.green,
                                              strokeWidth: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                : Align(
                                  alignment: Alignment.bottomCenter,
                                  child: SizedBox(
                                    height: 60,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: station == index ? 20 : 15,
                                            width: station == index ? 20 : 15,
                                            child: ColoredBox(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        index != mapRailwaysInFirst.length - 1
                                            ? SizedBox(
                                              height: 20,
                                              width: 20 * 23,
                                              child: ColoredBox(
                                                color: Colors.black,
                                              ),
                                            )
                                            : SizedBox(
                                              height: 20,
                                              width: station == index ? 20 : 15,
                                              child: ColoredBox(
                                                color: Colors.black,
                                              ),
                                            ),
                                        SizedBox(
                                          height: 20,
                                          width: station == index ? 20 : 15,
                                          child: ColoredBox(
                                            color:
                                                index == 0 ||
                                                        index ==
                                                            mapRailwaysInFirst
                                                                    .length -
                                                                1
                                                    ? Colors.black
                                                    : Colors.transparent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    SizedBox(width: 570),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSize.paddingAll10,
          child: Row(
            spacing: 15,
            children: [
              Expanded(
                child: RailwayButton(
                  onPressed: () async {
                    await Future.delayed(Duration(seconds: 1));
                    if (station > 0) goTo(station - 1);
                  },
                  icon: Icon(Icons.arrow_back),
                ),
              ),
              Expanded(
                child: RailwayButton(
                  onPressed: () {
                    if (station < mapRailwaysInFirst.length - 1) {
                      goTo(station + 1);
                    }
                  },
                  icon: Icon(Icons.arrow_forward_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
