// plaNum: 0 ~ 1 gousya
// val: Mabeee's power 0 ~ 100
void setPow(int plaNum, int val) {
  if (plaNum == 0) {
    control.setDuty(1, val);
  } else if (plaNum == 1) {
    control.setDuty(2, val); 
  }
}

void delegateInit() {
  setPow(0, 100);
  setPow(1, 75);
}

// place: 0 ~ 2
void event(int plaNum, int place){
  println("gousya = " + plaNum + ", place = " + place);
  
}