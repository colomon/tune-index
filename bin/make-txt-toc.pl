use v6;
use TuneIndex;

my $tunes = TuneIndex::Actions.new;
TuneIndex::Grammar.parse(slurp("trip-to-sligo"), :actions($tunes)) or die "Unable to parse trip-to-sligo";

for $tunes.tunes.kv -> $index, $tune {
    my $composer = $tune.composer ?? "(" ~ $tune.composer ~ ")" !! "";
    say "$index { $tune.name } $composer";
}
