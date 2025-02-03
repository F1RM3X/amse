String test([String name='you']){
  return ('One for ${name}, one for me.');
}

bool leap(int number){
  bool res = false;
  if (number % 4==0){
    if (number % 100==0){
      if (number % 400==0){
        res=true;
        }
    }
    else{
      res=true;
      }
    
  }
      
  return res;
}


void main() {
  int year = 1900;
  var res=leap(year);
  print(res);
  /*String name = 'leanne';
  print (test(name));*/
}
