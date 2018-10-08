#include <stdio.h>
#include <stdlib.h>

/* glib data structures go here */
#include <gmodule.h>

int main(int argc, char **argv)
{
  long limit = 100000;
  int str_len = 7;
  long il;
  int is;
  int ri;
  char *gen_str = NULL;
  GHashTable *duplicate_hash = g_hash_table_new(g_str_hash,
						g_str_equal);

  if (!duplicate_hash) {
    fprintf(stderr, "Cannot create hash to check duplicate values!\n");
  }

  if (argc == 3) {
    limit = atol(argv[1]);
    str_len = atoi(argv[2]);
  }

  gen_str = malloc((str_len + 1) * sizeof(char));
  if (!gen_str) {
    fprintf(stderr, "Cannot allocate string - memory full. Aborting!\n");
    exit(EXIT_FAILURE);
  }
  
  for (il = 0; il < limit; il++) {
  gen_randoms:
    for (is = 0; is < str_len; is++) {
      ri = (rand() % 9) + 1;
      gen_str[is] = '0' + ri;
    }
    gen_str[is] = '\0';

    if (duplicate_hash) {
      if (!g_hash_table_lookup(duplicate_hash, gen_str)) {
	g_hash_table_insert(duplicate_hash, gen_str, (gpointer)1);
      }
      else {
	fprintf(stderr, "Duplicate found [%s], redoing rand generation!\n",
		gen_str);
	goto gen_randoms;
      }
    }
    
    printf("%s\n", gen_str);
  }

  free(gen_str);

  if (duplicate_hash) {
    g_hash_table_destroy(duplicate_hash);
  }
  
  return EXIT_SUCCESS;
}
