use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile1(
    META_MERGE => {
        resources => {
            repository => q{https://github.com/richardjharris/newbg},
            bugtracker => q{https://github.com/richardjharris/newbg/issues},
        },
    },
    NAME              => q{newbg},
    AUTHOR            => q{Richard Harris <richardjharris@gmail.com>},
    ABSTRACT          => q{Set wallpaper like no-one's business},
    VERSION_FROM      => q{./bin/newbg},
    LICENSE           => q{perl},
    PREREQ_PM => { map { $_ => 0 } qw(
        File::HomeDir
        File::Slurp
        Image::Magick
        Readonly
        Time::Duration
        Try::Tiny
        X11::Wallpaper
        YAML
    ) },
    EXE_FILES           => ['bin/newbg'],
    MAN3PODS            => { },
    dist                => { COMPRESS => q{gzip -9f}, SUFFIX => q{gz}, },
    clean               => { FILES    => q{newbg-*} },
);

sub WriteMakefile1 {
    my %params = @_;
    my $eumm_version = $ExtUtils::MakeMaker::VERSION;
    $eumm_version = eval $eumm_version;
    die "EXTRA_META is deprecated" if exists $params{EXTRA_META};
    die "License not specified" if not exists $params{LICENSE};
    if ($params{AUTHOR} and ref($params{AUTHOR}) eq q{ARRAY}
        and $eumm_version < 6.5705) {
          $params{META_ADD}->{author}=$params{AUTHOR};
          $params{AUTHOR}=join(', ',@{$params{AUTHOR}});
    }
    if ($params{BUILD_REQUIRES} and $eumm_version < 6.5503) {
        #EUMM 6.5502 has problems with BUILD_REQUIRES
        $params{PREREQ_PM}={
          %{$params{PREREQ_PM} || {}} , %{$params{BUILD_REQUIRES}}
        };
        delete $params{BUILD_REQUIRES};
    }
    delete $params{CONFIGURE_REQUIRES} if $eumm_version < 6.52;
    delete $params{MIN_PERL_VERSION}   if $eumm_version < 6.48;
    delete $params{META_MERGE}         if $eumm_version < 6.46;
    delete $params{META_ADD}           if $eumm_version < 6.46;
    delete $params{LICENSE}            if $eumm_version < 6.31;
    delete $params{AUTHOR}             if $] < 5.005;
    delete $params{ABSTRACT_FROM}      if $] < 5.005;
    delete $params{BINARY_LOCATION}    if $] < 5.005;

    delete $params{MAN3PODS}->{'README.pod'};

    WriteMakefile(%params);
}


