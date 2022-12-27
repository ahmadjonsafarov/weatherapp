import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weatherapp/model/weather_model.dart';
import 'package:weatherapp/repository/getinformation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<WeatherModel> getWeatherInfo() async {
    final data= await Getinformation.getInformationWeather(name: 'Tashkent');
    return WeatherModel.fromJson(data);
  }
  bool chekHour(int index,WeatherModel? snapshot){
    print(TimeOfDay.now().hour);
   return int.tryParse((snapshot?.forecast?.forecastday?.first.hour?[index].time  ??  "").substring(11,13))==TimeOfDay.now().hour;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getWeatherInfo(),
        builder: (BuildContext context, AsyncSnapshot<WeatherModel> snapshot) {
          return snapshot.hasData
              ? Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/weathers.png',),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        SizedBox(height: 35,),
                        Text(snapshot.data?.location?.country ?? "",style: const TextStyle(color: Colors.white,fontSize: 31,fontWeight: FontWeight.w600),),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text((snapshot.data?.current?.tempC ?? 0).toString(),style: const TextStyle(color: Colors.white,fontSize: 80,fontWeight: FontWeight.w300),),
                        ),
                        const Text("Mostly Clear",style: TextStyle(color: Colors.white54,fontSize: 20,fontWeight: FontWeight.w500),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("H:${snapshot.data?.forecast?.forecastday?.first.day?.maxtempC ?? 0}",style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                            const SizedBox(width: 10,),
                            Text("L:${snapshot.data?.forecast?.forecastday?.last.day?.maxtempC ?? 0}",style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                          ],
                        ),
                        Image.asset('assets/house.png'),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 400,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(44),topRight: Radius.circular(44)),
                        gradient: LinearGradient(
                            colors: [
                              Color(0xff2E335A),
                              Color(0xff1C1B33),
                            ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0x30000000),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              width: 60,
                              height: 10,
                            ),
                            SizedBox(height: 15,),
                            Divider(height: 4,color: Color(0xffFFFFFF),),
                            SizedBox(height: 20,),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data?.forecast?.forecastday?.first.hour?.length ?? 0,
                                  itemBuilder: (context,index){
                                return Container(
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    gradient: chekHour(index,snapshot.data)?LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                      Color(0xff48319D),
                                      Color(0xffFFFFFF),
                                    ]):LinearGradient(
                                        colors: [
                                          Color(0x3048319D),
                                          Color(0x60FFFFFF),
                                        ]
                                    ),
                                    borderRadius: BorderRadius.circular(30)
                                  ),
                                  width: 85,
                                  height: 200,
                                  child:  Column(
                                    children: [
                                      SizedBox(height: 10,),
                                      Text(
                                          (snapshot.data?.forecast?.forecastday?.first.hour?[index].time ?? "").substring(11,13),
                                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
              :const Center(child: CupertinoActivityIndicator());
        },

      ),
    );
  }
}
