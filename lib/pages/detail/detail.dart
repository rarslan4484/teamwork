import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_work/AppState/providers/detailsProvider.dart';
import 'package:team_work/pages/detail/widget/content_intro.dart';
import 'package:team_work/pages/detail/widget/desc.dart';
import 'package:team_work/pages/detail/widget/detail_app_bar.dart';
import 'package:team_work/pages/detail/widget/house_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../widgets/featured.dart';
import '../../widgets/loadingWidgets/detailLoading.dart';

class DetailPage extends StatefulWidget {
  dynamic id;
  DetailPage({Key? key, required this.id}) : super(key: key);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  removePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('post_id').then((value) => () {
          // print('prefsRemoved.');
          // print(prefs.getString('post_id'));
        });
  }

  @override
  void initState() {
    removePrefs();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<DetailsProvider>(context, listen: false)
          .getDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Consumer<DetailsProvider>(
              builder: (context, value, child) {
                return value.isLoading
                    ? MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: const DetailLoading(),
                      )
                    : MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: value.details.length,
                            itemBuilder: (context, index) {
                              final wvcontroller = WebViewController()
                                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                                ..setBackgroundColor(const Color(0x00000000))
                                ..setNavigationDelegate(
                                  NavigationDelegate(
                                    onProgress: (int progress) {
                                      // Update loading bar.
                                    },
                                    onPageStarted: (String url) {},
                                    onPageFinished: (String url) {},
                                    onWebResourceError:
                                        (WebResourceError error) {},
                                    onNavigationRequest:
                                        (NavigationRequest request) {
                                      if (request.url.startsWith(
                                          'https://www.youtube.com/')) {
                                        return NavigationDecision.prevent;
                                      }
                                      return NavigationDecision.navigate;
                                    },
                                  ),
                                )
                                ..loadRequest(Uri.parse(
                                    'https://teamworkpk.com/API/mapview?address=${value.details[index].address}&city=${value.details[index].city}'));
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  DetailAppBar(
                                    id: widget.id.toString(),
                                    title:
                                        value.details[index].title.toString(),
                                    primaryImage: value
                                        .details[index].primary_image
                                        .toString(),
                                  ),
                                  const SizedBox(height: 10),
                                  ContentIntro(
                                      views:
                                          value.details[index].views.toString(),
                                      title:
                                          value.details[index].title.toString(),
                                      price:
                                          value.details[index].price.toString(),
                                      type:
                                          value.details[index].type.toString()),
                                  const SizedBox(height: 10),
                                  HouseInfo(
                                      id: widget.id,
                                      internal_lead_id: value
                                          .details[index].internal_lead_id
                                          .toString(),
                                      land_area: value.details[index].land_area
                                          .toString(),
                                      property_type: value
                                          .details[index].property_type
                                          .toString(),
                                      type:
                                          value.details[index].type.toString()),
                                  const SizedBox(height: 20),
                                  About(
                                    aboutText: value.details[index].description
                                        .toString(),
                                  ),
                                  const SizedBox(height: 25),
                                  Video_tw(
                                      video: value.details[index].video_link
                                          .toString(),
                                      primaryImage: value
                                          .details[index].primary_image
                                          .toString()),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: WebViewWidget(
                                            controller: wvcontroller),
                                        //   child: WebView(
                                        //     initialUrl:
                                        //         'https://teamworkpk.com/API/mapview?address=${value.details[index].address}&city=${value.details[index].city}',
                                        //     javascriptMode:
                                        //         JavascriptMode.unrestricted,
                                        //   ),
                                        // ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        String telephoneNumber = '+92515402683';
                                        String telephoneUrl =
                                            "tel:$telephoneNumber";
                                        if (await canLaunch(telephoneUrl)) {
                                          await launch(telephoneUrl);
                                        } else {
                                          throw "Error occured trying to call that number.";
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: Text(
                                          'Contact Now',
                                          style: GoogleFonts.ubuntu(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  const Featured(),
                                ],
                              );
                            }),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Video_tw extends StatelessWidget {
  final String video;
  final String primaryImage;

  const Video_tw({Key? key, required this.video, required this.primaryImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? vid;
    vid = YoutubePlayer.convertUrlToId(video.toString());
    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: vid.toString(),
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: true,
      ),
    );

    if (video.isEmpty || video.toString() == 'null' || video.length < 5) {
      return Container();
    } else {
      return YoutubePlayerBuilder(
          player: YoutubePlayer(
            thumbnail: CachedNetworkImage(
              imageUrl: primaryImage,
              fit: BoxFit.cover,
            ),
            controller: controller,
          ),
          builder: (context, player) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text(
                    'Video',
                    style: GoogleFonts.ubuntu(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: player,
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                //some other widgets
              ],
            );
          });
    }
  }
}
