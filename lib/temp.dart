import 'package:intl/intl.dart';

void main()
{
  var temp=DateTime.now().toLocal();
  print(temp);
  var moonLanding = DateTime.parse("2020-05-13 23:32:33.503292");
  var temp2=DateFormat('D').format(temp);
  var temp3=DateFormat('D').format(moonLanding);
//  var temp2=moonLanding.difference(temp);
  print(temp2);
  print(temp3);
//  print(moonLanding);
}
