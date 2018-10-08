#include <iostream>
#include <cstdlib>
#include <unordered_map>
#include <string>

int main(int argc, char **argv)
{
  using namespace std;
  
  long limit = 100000;
  int str_len = 7;
  unordered_map<string, int> duplicate_hash;
  string gen_str;
  
  if (argc == 3) {
    limit = atol(argv[1]);
    str_len = atoi(argv[2]);
  }

  for (long il = 0; il < limit; il++) {
  gen_randoms:
    gen_str = "";
    for (int is = 0; is < str_len; is++) {
      int ri = (rand() % 9) + 1;
      gen_str += '0' + ri;
    }

    if (duplicate_hash.find(gen_str) == duplicate_hash.end()) {
      duplicate_hash[gen_str] = 1;
    }
    else {
      cerr << "Duplicate found, redoing rand generation - "
	   << gen_str << endl;
      goto gen_randoms;
    }
    
    cout << gen_str << endl;
  }

  return EXIT_SUCCESS;
}
