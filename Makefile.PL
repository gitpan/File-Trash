use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'File::Trash',
   VERSION_FROM => 'lib/File/Trash.pm',
   

   # gen /usr/bin/pmused by Wed Mar 18 15:49:33 EDT 2009 
   PREREQ_PM => {
      'Carp'                              => '1',
      'Cwd'                               => '3',
      'Exporter'                          => '5',
      'File::Copy'                        => '2.09',
      'File::Path'                        => '2.07',
      'Getopt::Std::Strict'               => '1.01',
      'Test::Simple'                      => '0',
   },

   
   LICENSE => 'perl',
   
   
   
   EXE_FILES => [qw(bin/trash)],
);


