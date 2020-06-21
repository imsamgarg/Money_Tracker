main() {
  functionName();
}
final List<int> temp=[1,1,1];
void functionName() {
  temp.insert(1, 100);
  temp.insert(3, 100);
  temp.insert(5, 100);
  print(temp);
}