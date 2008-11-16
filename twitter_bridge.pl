#! /usr/bin/env perl

use strict ;
use Net::Twitter ;

print "Content-Type: text/plain\n\n" ;
chomp (my $POST = <STDIN>) ;

my %vars ;
my @key_value_pairs = split /&/,  $POST ;

# Adesso bisogna spezzettare il contenuto del post in un
# hash chiave-valore
foreach (@key_value_pairs) {
  my @kv = split /=/, $_ ;
  foreach (@kv) {
    # sostituisco tutti i "+" con degli spazi
    # 
    s/\+/ /g ;

    # i caratteri non-ascii nel protocollo HTTP vengono
    # coificati come un % segito dal codice esaecimale del
    # carattere stesso.
    # sostituisco ogni ricorrenza di un % seguito da due
    # simboli [ %(..) ] con il corrispondente carattere
    s/%(..)/pack('c', hex($1))/eg ;
  }
  # schiaffo ogni chiave e valore nell'hash
  $vars{$kv[0]} = $kv[1] ;
}

# Creo un account Twitter
my $TA = Net::Twitter->new(username=>$vars{"nick"}, password=>$vars{"password"} ) ;
# Aggiorno l'acccount
my $res = $TA->update($vars{"tweet"}) ;

if ($res) {
  print "Twitter aggiornato\n" ;
}
else {
  print "Error\n" ;
  foreach( keys(%vars) ) {
    print "$_:\t".$vars{"$_"}."\n" ;
  }
}
