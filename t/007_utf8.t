# -*- perl -*-
use utf8;
use strict;
use warnings;

use Encode qw/encode_utf8/;
use Test::More;
use JSON::JQ;
use Path::Tiny qw/path/;

sub curfile {
  path(+(caller(0))[1])->realpath;
}

subtest 'data without utf8' => sub {
  no utf8;
  my $jq  = JSON::JQ->new({script => '.'});
  my $res = $jq->process({data => {message => "I ♥ JSON"}});
  is_deeply $res, [{message => 'I ♥ JSON'}], 'no utf8';
};

subtest 'data with utf8' => sub {
  my $jq  = JSON::JQ->new({script => '.'});
  my $res = $jq->process({data => {message => "I ♥ JSON"}});
  is_deeply $res, [{message => 'I ♥ JSON'}], 'use utf8';
};

subtest 'json with utf8' => sub {
  my $jq   = JSON::JQ->new({script => '.'});
  my $res1 = $jq->process({json => encode_utf8(qq/{"message": "I ♥ JSON"}/)});
  is_deeply $res1, [{message => 'I ♥ JSON'}], 'use utf8';

  my $res2 = $jq->process({json => encode_utf8(qq/{"message": "I ♥ JSON"}/)});
  is_deeply $res2, [{message => 'I ♥ JSON'}], 'use utf8';
};

subtest 'json_file with utf8' => sub {
  ## Example from https://stackoverflow.com/a/10710462
  my $jq1      = JSON::JQ->new({script => '.'});
  my $jsonfile = curfile->sibling('007.json');
  my $res1     = $jq1->process({json_file => $jsonfile->stringify});
  is_deeply $res1, [{cat => 'Büster'}], 'use utf8';

  my $jq2  = JSON::JQ->new({script    => '.cat'});
  my $res2 = $jq2->process({json_file => $jsonfile->stringify});
  is_deeply $res2, ['Büster'], 'use utf8';
};

done_testing;
