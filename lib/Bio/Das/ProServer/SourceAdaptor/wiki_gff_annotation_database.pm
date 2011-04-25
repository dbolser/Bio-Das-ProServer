package Bio::Das::ProServer::SourceAdaptor::wiki_gff_annotation_database;

use strict;
use warnings;

use LWP::Simple;
use Text::CSV;

use Carp;
use base qw(Bio::Das::ProServer::SourceAdaptor);



sub init {
  my $self = shift;
  
  $self->{'capabilities'}{'features'} = '1.0';
}


sub build_features {
  my ($self, $args) = @_;
  
  my $segment = $args->{'segment'} || '';
  my $start   = $args->{'start'}   || '';
  my $end     = $args->{'end'}     || '';

  my $wikiurl     = $self->config->{'wikiurl'};
  
  ## Step 1, construct the query from the args
  
  ## I'm sure there is a better way to do this (for example using the
  ## RDF).
  
  ## This query is exemplified here:
  ## http://das.referata.com/wiki/GFF_query_example
  
  my $query =
      ## Send a query string to the 'ask' special page
      "$wikiurl/Special:Ask".
      
      ## Limit results to pages in the GFF category
      "/-5B-5BCategory:GFF-20data-5D-5D".
      
      ## Build the query from the args
      "-5B-5BGFF:seqid::". $segment.
      "-5D-5D-5B-5BGFF:start::-3E". $start.
      "-5D-5D-5B-5BGFF:end::-3C". $end.
      
      ## Select the results fields that we expect from the pages
      "/-3FGFF:seqid=seqid".
      "/-3FGFF:source=source".
      "/-3FGFF:type=type".
      "/-3FGFF:start=start".
      "/-3FGFF:end=end".
      "/-3FGFF:score=score".
      "/-3FGFF:strand=strand".
      "/-3FGFF:phase=phase".
      "/-3FGFF:attributes=attributes".
      "/format=csv/sep=,/headers=hide/limit=1000";
  
  carp $query, "\n";
  
  
  
  ## Step 2, get the data from the wiki
  
  my $data = get $query
    or die "FUCN\n";
  
  carp $data, "\n";
  
  
  
  ## Step 3, parse the data into the DAS format...
  
  my @features;
  my $csv = Text::CSV->new();
  
  foreach my $row (split(/\n/, $data)){
    carp $row, "\n";
    
    $csv->parse($row)
      or die;
    
    my @col = $csv->fields();
    
    push @features, {
	'segment' => $col[1],
	'id'      => $col[1],
	'method'  => $col[2],
	'type'    => $col[3],
	'start'   => $col[4],
	'end'     => $col[5],
	'score'   => $col[6],
	'ori'     => $col[7],
	'phase'   => $col[8],
	'note'    => $col[9],
	
	'link'    => "$wikiurl/". $col[0]
    }
  }
  
  
  
  ## Step 4, done!
  
  return(@features);
}

1;
