use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'File::Trash',
   VERSION_FROM => 'lib/File/Trash.pm',
   
   LICENSE => 'perl',

   # gen /usr/bin/pmused by Sun Dec 28 18:42:33 EST 2008 
   PREREQ_PM => {
      'Carp'                              => '1',
      'Cwd'                               => '3',
      'Exporter'                          => '5',
      'File::Copy'                        => '2.09',
      'File::Path'                        => '1.08',
      'Getopt::Std::Strict'               => '1.01',
      'LEOCHARRE::DEBUG'                  => '1.11',
      'LEOCHARRE::Dir'                    => '1.06',
      'Test::Simple'                      => '0',
   },


   EXE_FILES => [qw(bin/trash)],
);


