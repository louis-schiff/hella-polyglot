#include <stdio.h>
int main(){
  int n=2,i;
  a:printf("%d\n",n);
  b:if(++n<542){
    for(i=2;i<n;)
      if(!(n%i++))
        goto b;
    goto a;
  }
}