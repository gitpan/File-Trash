package File::Trash;
use strict;
use vars qw($VERSION @EXPORT_OK %EXPORT_TAGS @ISA $DEBUG $ABS_TRASH $ABS_BACKUP);
use Exporter;
use Carp;
use File::Copy;
$VERSION = sprintf "%d.%02d", q$Revision: 1.4 $ =~ /(\d+)/g;
@ISA = qw/Exporter/;
@EXPORT_OK = qw(trash backup);
%EXPORT_TAGS = ( all => \@EXPORT_OK );
use File::Path;
use Carp;
sub debug { $DEBUG and print STDERR __PACKAGE__.", @_\n"; 1 }

$ABS_TRASH = '/tmp/trash';
$ABS_BACKUP = '/tmp/backup';


sub trash {
   @_ or carp("no arguments provided") and return;
   my $count = scalar @_;
   $count or carp("no arguments provided") and return;

   
   if ( $count == 1 ){
      return _backup($_[0], 1);
   }


   my $_count = 0;
   for (@_){
      _backup($_, 1) and $_count++; 
   }

   $_count == $count or carp("Deleted $_count/$count files.");
   $_count;
}



sub backup {
   @_ or carp("no arguments provided") and return;
   my $count = scalar @_;
   $count or carp("no arguments provided") and return;

   if ( $count == 1 ){
      return _backup($_[0]);
   }

   my $_count = 0;
   for (@_){
      _backup($_) and $_count++;
   }

   $_count == $count or carp("Backed up $_count/$count files.");
   $_count;
}


sub _backup {   
   my $abs_path = Cwd::abs_path($_[0]) 
         or carp("Can't resolve with Cwd::abs_path : '$_[0]'")
         and return;
      -f $abs_path
         or carp("Not a file on disk : '$abs_path'")
         and return;

   my $is_trash = $_[1]; # if true, we delete original after, and we use abs trash instead


   my $abs_to = $is_trash ? "$ABS_TRASH$abs_path" : "$ABS_BACKUP$abs_path";

   $abs_to =~/^(\/.+)\/[^\/]+$/ 
      or confess("Error with '$abs_to' matching into");
   _abs_dir_assure($1);

   my $backnum;
   no warnings;
   while( -e $abs_to ){
      $abs_to=~s/\.\d+$//;
      $abs_to.='.'.$backnum++;
   }


   File::Copy::copy($abs_path, $abs_to) 
      or confess("cant File::Copy::copy($abs_path, $abs_to) , $!");

   debug("moved '$abs_path' to '$abs_to'");

   unlink $abs_path if $is_trash;

   $abs_to;
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

This is the same for default abs backup dir.


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

=head2 backup()

Same as trash(), but does not move the file, copies it instead.


=head2 $File::Trash::ABS_TRASH

Default is /tmp/trash

=head2 $File::Trash::ABS_BACKUP

Default is /tmp/backup

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

