package File::Trash;
use strict;
use vars qw($VERSION @EXPORT_OK %EXPORT_TAGS @ISA $DEBUG $ABS_TRASH);
use Exporter;
use Carp;
use File::Copy;
$VERSION = sprintf "%d.%02d", q$Revision: 1.1.1.1 $ =~ /(\d+)/g;
@ISA = qw/Exporter/;
@EXPORT_OK = qw(trash);
%EXPORT_TAGS = ( all => \@EXPORT_OK );
use File::Path;
use Carp;
sub debug { $DEBUG and print STDERR __PACKAGE__.", @_\n"; 1 }

$ABS_TRASH = '/tmp/trash';

sub trash {
   @_ or carp("no arguments provided") and return;
   my $count = scalar @_;
   $count or carp("no arguments provided") and return;

   $count == 1 and return _trash($_[0]);
   
   my $_count = 0;
   for (@_){
      _trash($_) or next;

      $_count++;
   }

   $_count == $count or carp("Deleted $_count/$count files.");

   $_count;
}


sub _trash {   
   my $abs_path = Cwd::abs_path($_[0]) 
         or carp("Can't resolve with Cwd::abs_path : '$_[0]'")
         and return;
      -f $abs_path
         or carp("Not a file on disk : '$abs_path'")
         and return;

   my $abs_trashed = "$ABS_TRASH$abs_path";
   $abs_trashed =~/^(\/.+)\/[^\/]+$/ 
      or confess("Error with '$abs_trashed' matching into");
   _abs_dir_assure($1);

   my $backnum;
   no warnings;
   while( -e $abs_trashed ){
      $abs_trashed=~s/\.\d+$//;
      $abs_trashed.='.'.$backnum++;
   }


   File::Copy::move($abs_path, $abs_trashed) 
      or confess("cant File::Copy::move($abs_path, $abs_trashed) , $!");
   debug("moved '$abs_path' to '$abs_trashed'");
   $abs_trashed;
}


   



sub _abs_dir_assure {
   -d $_[0] or File::Path::mkpath($_[0]) # throws croak on system error
      or die("cant File::Path::mkpath $_[0], $!"); # just in case
   1;
}








1;

__END__

=pod

=head1 NAME

File::Trash - safe file delete

=head1 SYNOPSIS

   use File::Trash 'trash';

   my $trashed_path = trash('~/this_is_boring.txt');
   # returns '/tmp/trash/home/username/this_is_boring.txt'

   my $abs_trash = $File::Trash::ABS_TRASH;
   # returns '/tmp/trash' by default

   my $trash_count = trash('~/this_is_boring.txt', '~/this_is_boring_2.txt');
   # returns '2'

=head1 DESCRIPTION

File::Remove apparently does something similar. 
I don't see example for using File::Remove in a simple manner alike unlink().
Thus, here it is. 

=head2 The default abs trash dir

The default dir for trash has been chosen as /tmp/trash.
The other common sense place would be $ENV{HOME}/.trash, so, why not?
What if you are calling this from some script running under a used who does not have ~, like, maybe cron
or maybe from some cgi? This is safer.
If you want, you can set the dir to be something else..

   $File::Trash::ABS_TRASH = $ENV{HOME}/.trash

=head1 API

No subs are exported by default.

=head2 trash()

Ideally this should behave as unlink(). It does not at present.

Argument is a list of paths to files to delete.
If more than one file is provided, returns number of files deleted.
If one file is provided only, returns abs path to where the file moved.
Returns undef in failure, check errors in $File::Trash::errstr.

If the trash destination exists, the file is appended with a dot digit number.
So, this really makes sure you don't lose junk.

=head2 $File::Trash::ABS_TRASH

Default is /tmp/trash

=head2 $File::Trash::DEBUG

Set to true to see some debug info.

=head1 CAVEATS

In development. Works great as far as I know.
This is mean to be POSIX compliant only. That means no windoze support is provided.
If you have suggestions, please forward to AUTHOR.

=head1 SEE ALSO

L<File::Remove>

=head1 AUTHOR

Leo Charre leocharre at cpan dot org

=head1 LICENSE

This package is free software; you can redistribute it and/or modify it under the same terms as Perl itself, i.e., under the terms of the "Artistic License" or the "GNU General Public License".

=head1 DISCLAIMER

This package is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the "GNU General Public License" for more details.

=cut

