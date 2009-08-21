use Test::Simple 'no_plan';
use strict;
use lib './lib';
use Cwd;
use vars qw($_part $cwd);
$cwd = cwd();
use File::Trash 'trash';


ok ! trash(), 'trash()';

for my $arg ( qw(bogus ./bogusette) ){
   
   ok( ! trash($arg), 'trash()' );
   




}
















sub ok_part {
   printf STDERR "\n\n===================\nPART %s %s\n==================\n\n",
      $_part++, "@_";
}


